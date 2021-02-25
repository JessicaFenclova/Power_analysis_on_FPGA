library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity ctrl_aes is
  port (
    i_clk         : in std_logic;
    i_rst         : in std_logic;
    i_rd_req      : in std_logic;
    i_data        : in std_logic_vector(7 downto 0);
    i_cmd_done    : in std_logic;
    i_eval_result : in std_logic_vector(7 downto 0);
    i_wr_ack      : in std_logic;
    --i_start       : in std_logic;
    o_rd_ack      : out std_logic; -- do i want another signal out ready
    o_start_cmd   : out std_logic;
    o_cmd_reg     : out std_logic_vector(2 downto 0);
    o_param_reg   : out std_logic_vector(4 downto 0);
    o_wr_req      : out std_logic;
    o_data        : out std_logic_vector(7 downto 0)    
  
    );
 end ctrl_aes;
 
 architecture rtl of ctrl_aes is
 
 type state_type is (wait_uart,fetch,exe_cmd,eval_res,send_res);
 
 
    signal state : state_type;
    signal change_dete : std_logic :='0';
    signal previous : std_logic_vector(7 downto 0) := "00000000";
    signal  cmd_reg : std_logic_vector(2 downto 0) := "000";
    signal param_reg : std_logic_vector(4 downto 0) := "00000";
    
 
       
  begin
  
    p_wait: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
           state <= wait_uart;
           o_data <="11111111";
           o_param_reg <="00000";
           o_cmd_reg <="000";
           o_wr_req<='0';
           o_rd_ack<='0';
        elsif i_clk'event and (i_clk='1') then
        
            previous<=i_eval_result;
            
            --change_dete<=previous xor i_eval_result;        
        
            case state is
              when wait_uart =>
                 if (i_rd_req='1') then
                   state <= fetch;
                  --enable <='1';
                  else
                    state<=wait_uart;
                 end if; 
              when fetch =>
                 if (i_rd_req='1') then  
                   cmd_reg<=i_data(2 downto 0);
                   param_reg<=i_data(7 downto 3);
                   state <= exe_cmd;
                 else
                   state<=fetch;
                 end if;
              when exe_cmd =>
                 if (change_dete='1') then    --if change in eval result, the input from sbox, or just act as if the data from the xor are there all the time
                   state <= eval_res;
                 elsif (i_cmd_done='1') then
                   state <= wait_uart;
                 else
                   state<=exe_cmd;
                 end if;
              when eval_res =>
                 if (i_wr_ack='1') then
                   state <= wait_uart;
                 else
                   state<=eval_res;
                 end if;
              --when s4 =>
                 --state <= s0;
              when others =>
                   state <= wait_uart;
            end case;
            --testing 
            
                                           
            
                     
        end if;
    end process p_wait;
    change_dete <= '0' when i_eval_result = previous else '1';--change_dete<=previous xor i_eval_result;
    
    p_state: process(state)
      begin
        case state is
            when wait_uart =>
                o_rd_ack <= '0';
                o_wr_req<='0'; 
            when fetch =>
                o_rd_ack <='1';  
            when exe_cmd =>
                o_start_cmd <='1';
                o_rd_ack <= '0';
                o_cmd_reg<=cmd_reg;
                o_param_reg <=param_reg;
            when eval_res =>
               o_wr_req <='1';
               o_data<=i_eval_result;    --just for now, dont have the block that would xor the sbox outputs                
            when others =>
                    o_rd_ack <= '0';
                    o_wr_req<='0';
                    
        end case;

    end process p_state; 
    
    
        
 end architecture rtl;