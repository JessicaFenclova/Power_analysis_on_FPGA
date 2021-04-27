library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity ctrl_aes is
  --generic (parambits : std_logic_vector(4 downto 0));
    
  port (
    i_clk         : in std_logic;
    i_rst         : in std_logic;
    i_rd_req      : in std_logic;
    i_data        : in std_logic_vector(7 downto 0);
    i_xor_result  : in std_logic_vector(7 downto 0);    --the sbox outputs put through xor, the state machine measure will use to tell the main state machine maybe the eval_result signal a 0 or 1, correct incorrect
    i_wr_ack      : in std_logic;
    o_rd_ack      : out std_logic; 
    o_wr_req      : out std_logic;
    o_param       : out std_logic_vector(4 downto 0); -- cmd tells if this will be the lsb or msb or param for enabling sboxes
    --o_lsb         : out std_logic_vector(4 downto 0);     --leave only one output, make it generic, o_param
    --o_msb         : out std_logic_vector(4 downto 0);
    o_lsb_en      : out std_logic;
    o_msb_en      : out std_logic;
    o_en_sbox     : out std_logic; -- state machine sbox will enable the decoder to take param reg bits and decode them to know which sboxes to enable
    o_gener_data  : out std_logic; -- the state machine measure will let the lfsr know to generate new data or leave the data as they are
    o_trigger     : out std_logic; -- the state machine measure will set and reset this
    o_data        : out std_logic_vector(7 downto 0)    
  
    );
 end ctrl_aes;
 
 architecture rtl of ctrl_aes is  
    
 
 type ctrl_state_type  is (wait_uart,fetch,exe_cmd,eval_res,send_res);   --state type for the controll state machine
 type active_sbox_type is (ready1, set_en, done1);                       --state type for the state machine for activating and deactivating sboxes
 type set_lfsr_type    is (ready2, set_lsb, set_msb, done2);             --state type for the state machine for setting the lfsr pseudo random generator
 type measure_power_type    is (ready3, encrypt_data, set_trigger, measure, reset_trigger, done3);    --state type for the state machine for measuring power consumption of the sbox operation in aes
 
 
    signal state       : ctrl_state_type;
    signal  cmd_reg    : std_logic_vector(2 downto 0) := "000";
    signal param_reg   : std_logic_vector(4 downto 0) := "00000";
    --signal cmd_done    : std_logic :='0';  --cmd_done is the or of all cmd_done signals from state machines
    signal cmd_done    : std_logic_vector(2 downto 0) := "000";
    signal start_cmd   : std_logic :='0';
    
    signal state1_sbox    : active_sbox_type;
    --signal en_sbox   : std_logic;
    --signal cmd_done1 : std_logic; --instead cmd__done vector
    
    signal state2_lfsr    : set_lfsr_type;
    --signal lsb       : std_logic_vector(4 downto 0);
    --signal msb       : std_logic_vector(4 downto 0);
    --signal cmd_done2 : std_logic; --instead cmd__done vector
    --signal random_data : std_logic_vector(7 downto 0);
    
    signal state3_measure  : measure_power_type;
    --signal cmd_done3 : std_logic;   --instead cmd__done vector
    --signal old_result : std_logic_vector(7 downto 0);
    --signal xor_result : std_logic;
    signal eval_result :  std_logic :='1';    -- will be sent out o_data
    
 
       
  begin
  
    p_wait: process(i_clk, i_rst)    -- process for state machine controlling the aes measurement, data generation and sbox activation, deactivation
      begin
      
        if i_rst = '0' then
           state <= wait_uart;
           --start_cmd<='0';
           param_reg <="00000";
           cmd_reg <="000";
           --o_wr_req<='0';
           --o_rd_ack<='0';
           o_data <="11111111";
        elsif i_clk'event and (i_clk='1') then
               
            
            case state is
              when wait_uart =>
                 --o_data <="11111111";
                 if (i_rd_req='1') then
                   state <= fetch;
                   --o_data <="11111111";
                  --enable <='1';                    
                  else
                    state<=wait_uart;
                 end if; 
              when fetch =>
                 if (i_rd_req='1') then
                   param_reg<=i_data(4 downto 0);  --5bits
                   cmd_reg<=i_data(7 downto 5);  --3bits                 
                   state <= exe_cmd;
                 else
                   state<=fetch;
                 end if;
              when exe_cmd =>
                 if (eval_result='1') then    --if change in eval result, the input from sbox, or just act as if the data from the xor are there all the time
                   state <= eval_res;
                 elsif (cmd_done/="000") then   -- a cmd_done came from a state machine, (cmd_done1='1') or (cmd_done2='1') or (cmd_done3='1')
                   state <= wait_uart;
                 else
                   state<=exe_cmd;
                 end if;
              when eval_res =>
                 o_data <= i_xor_result; -- evaluate from measure the xor 8 bits and send 1 if ok or 0 if not
                 if (i_wr_ack='1') then
                   state <= wait_uart;
                 else
                   state<=eval_res;
                 end if;
              when others =>
                   state <= wait_uart;
            end case;
            --testing 
            
                                           
            
                     
        end if;
    end process p_wait;
    
    
    p_state: process(state)
      begin
        case state is
            when wait_uart =>         --because of latches the rd_ack and wr_req had to be added to all paths
                o_rd_ack <= '0';
                o_wr_req<='0';
                start_cmd<='0'; 
            when fetch =>
                o_rd_ack <='1';
                o_wr_req<='0';
                start_cmd<='0';  
            when exe_cmd =>
                start_cmd <='1';
                o_wr_req<='0';
                o_rd_ack <= '0';
            when eval_res =>
               o_rd_ack <= '0';
               o_wr_req <='1';
               start_cmd<='0';
               --o_data <= eval_result;    --just for now, dont have the block that would xor the sbox outputs                
            when others =>
                o_rd_ack <= '0';
                o_wr_req<='0';
                start_cmd<='0';
                    
        end case;

    end process p_state;
    
    p_ready1: process(i_clk, i_rst)   --process for the statemachine that activates/deactivvates sboxes
      begin
        if i_rst = '0' then
           state1_sbox <= ready1;

        elsif i_clk'event and (i_clk='1') then
            case state1_sbox is
              when ready1 =>
                 if (start_cmd='1') and (cmd_reg="010") then     -- cmd_reg () 3 bits from data in, the 3 msb
                   state1_sbox <= set_en;
                   --here i could put the param reg out for the decoder entity
                  else
                    state1_sbox <=ready1;
                 end if; 
              when set_en =>  
                   state1_sbox <= done1;              
              when others =>
                   state1_sbox <= ready1;
            end case;
        end if; 
    end process p_ready1;
    
    p_state1: process(state1_sbox)
      begin
        case state1_sbox is
            when ready1 =>
                o_en_sbox <= '0';
                cmd_done(0) <='0'; 
            when set_en =>
                o_en_sbox <='1';
                cmd_done(0) <='0';
                --put out the param 
                --param_reg <=  
            when done1 =>
               cmd_done(0) <='1';
               o_en_sbox <='1';                
            when others =>
                cmd_done(0) <='0';
                o_en_sbox <= '0';
                    
        end case;

    end process p_state1;
    
    
    p_ready2: process(i_clk, i_rst)     --process for state machine that sets the LFSR bits and generates random data for aes
      begin
         
        if i_rst = '0' then
           state2_lfsr <= ready2;
        elsif i_clk'event and (i_clk='1') then
            case state2_lfsr is
              when ready2 =>                
                 if (start_cmd='1') and (cmd_reg="000") then
                   state2_lfsr <= set_lsb;
                   -- put out param or in the process for state
                 elsif (start_cmd='1') and (cmd_reg="100") then
                   state2_lfsr <= set_msb;
                 else
                    state2_lfsr<=ready2;
                 end if; 
              when set_lsb => 
                   state2_lfsr <= done2;
              when set_msb =>  
                   state2_lfsr <= done2;           
              when others =>
                   state2_lfsr <= ready2;
            end case;
        end if; 
    end process p_ready2;
    
    p_state2: process(state2_lfsr)
      begin
    
        case state2_lfsr is
            when ready2 =>
                --o_lsb<="00000";
                --o_msb<="00000";
                o_lsb_en<='0';
                o_msb_en<='0';
                cmd_done(1) <= '0';
            when set_lsb =>
                --o_lsb <= param_reg; -- output to o_param
                o_lsb_en <='1';
                o_msb_en<='0';
                cmd_done(1) <= '0';  
            when set_msb =>
                --o_msb <= param_reg;
                o_lsb_en<='0';
                o_msb_en <='1';
                cmd_done(1) <= '0';
            when done2 =>
               cmd_done(1) <='1';
               o_lsb_en<='0';
               o_msb_en<='0';               
            when others =>
                cmd_done(1) <= '0';
                o_lsb_en<='0';
                o_msb_en<='0';
                    
         end case;

    end process p_state2;
    
    
    
    
    p_ready3: process(i_clk, i_rst)   --process for the statemachine that starts measuring power while encrypting data,  encrypt_data, set_trigger, measure, reset_trigger, done3
      begin
        if i_rst = '0' then
           state3_measure <= ready3;
           
        elsif i_clk'event and (i_clk='1') then
           --old_result<= i_xor_result;
          --if (i_xor_result = old_result) then    --((old_result) xor (i_xor_result))
            --xor_result<='0';
          --else
            --xor_result<='1';
          --end if;
          
        
            case state3_measure is
              when ready3 =>
                 if (start_cmd='1') and (cmd_reg="110") then
                   state3_measure <= encrypt_data;
                  else
                    state3_measure <=ready3;
                 end if; 
              when encrypt_data =>  
                   state3_measure <= set_trigger;
              when set_trigger=>
                   state3_measure <= measure; 
              when measure =>
                 --if (xor_result='1') then  
                   state3_measure <= reset_trigger;
                   -- xor all of the 8 bits of the xor result and send that to eval_result
                 --end if;
              when reset_trigger => 
                   state3_measure <= done3;
             
              when others =>
                   state3_measure <= ready3;
            end case;
        end if;
        --o_data<= eval_result; 
    end process p_ready3;
    
    p_state3: process(state3_measure, i_xor_result)
      begin
        case state3_measure is
            when ready3 =>
                o_gener_data <= '0';
                cmd_done(2) <='0';
                eval_result <='1';
                --o_data<='1';
                o_trigger<='0'; 
            when encrypt_data =>
                o_gener_data <='1';
                cmd_done(2) <='0';
                o_trigger<='0';
                eval_result <='0';  
            when set_trigger =>
               o_gener_data <= '0';
               cmd_done(2) <='0';
               o_trigger <='1';
               eval_result <='0';
            when measure =>
                -- maybe the trigger for sboxes
                o_trigger <='1';
                o_gener_data <='0';
                cmd_done(2) <='0';
                eval_result <='0';  
            when reset_trigger =>
               o_gener_data <= '0';
               cmd_done(2) <='0';
               o_trigger <='0';
               eval_result <='0';
            when done3 =>
               cmd_done(2) <='1';
               o_gener_data <= '0';
               o_trigger<='0';
               --o_data<=i_xor_result;
               if  (i_xor_result="00000000")  then
                  eval_result <='1'; -- need to add code for taking the xor 8 bits and evaluating if ok 1 or not 0
                  --o_data<='1';
                 --i_xor_result(i) xor i_xor_result(i+1) 
               --elsif (i_xor_result="11111111") then        -- probably could just put else and that it is incorrect so out 0
                  --eval_result <='0';
               else
                  eval_result <='0';
                  --o_data<='0'; 
               end if;              
            when others =>
                cmd_done(2) <= '0';
                o_gener_data <= '0';
                cmd_done(2) <='0';
                o_trigger<='0';
                eval_result <='0';
                    
        end case;
        
    

    end process p_state3;
    
     --o_data<= eval_result;
     o_param<= param_reg;
     
    
    
    
    
        
 end architecture rtl;