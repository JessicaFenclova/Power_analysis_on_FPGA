library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity ctrl_aes is
  port (
    i_clk         : in std_logic;
    i_rst         : in std_logic;
    i_rd_req      : in std_logic;
    i_data        : in std_logic;
    i_cmd_done    : in std_logic;
    i_eval_result : in std_logic;
    i_wr_ack      : in std_logic;
    o_rd_ack      : out std_logic; -- do i want another signal out ready
    o_start_cmd   : out std_logic;
    o_cmd_reg     : out std_logic_vector(2 downto 0);
    o_param_reg   : out std_logic_vector(4 downto 0);
    o_wr_req      : out std_logic;
    o_data        : out std_logic    
  
    );
 end ctrl_aes;
 
 architecture rtl of ctrl_aes is
 
 type state_type is (s0,s1,s2,s3,s4);
 
 
    signal state : state_type;
    signal en_fetch: std_logic :='0';
    signal  in_d : std_logic_vector(7 downto 0) :="11111111";
    signal count : integer :=0;
    signal eval_resul : std_logic:='0';
    signal start_bit : std_logic :='0';
 
       
  begin
  
    p_wait: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
           in_d <="11111111";
           state <= s0;
           o_data <='1';
           o_param_reg <="00000";
           o_cmd_reg <="000";
           o_wr_req<='0';
           o_rd_ack<='0';
           en_fetch<='0';
           --count <=0;
           start_bit<='0';
        elsif i_clk'event and (i_clk='1') then        
        
            case state is
              when s0 =>
                 if (i_rd_req='1') then
                   state <= s1;
                  --enable <='1';
                  else
                    state<=s0;
                 end if; 
              when s1 =>
                 if (start_bit='1') then  --start bit of data i_data
                   state <= s2;
                 else
                   state<=s1;
                 end if;
              when s2 =>
                 if (i_eval_result='1') then    --if change in eval result, the input from sbox
                   state <= s3;
                 elsif (i_cmd_done='1') then
                   state <= s0;
                 else
                   state<=s2;
                 end if;
              when s3 =>
                 if (i_wr_ack='1') then
                   state <= s4;
                 else
                   state<=s3;
                 end if;
              when s4 =>
                 state <= s0;
              when others =>
                   state <= s0;
            end case;                                  
            
                     
        end if;
    end process p_wait;
    
    p_state: process(state)
      begin
        case state is
            when s0 =>
                o_rd_ack <= '0';
                o_wr_req<='0';
                en_fetch<='0'; 
            when s1 =>
                o_rd_ack <='1';
                en_fetch <='1';
                if (count<8) and (en_fetch='1') then
                   count<= count+1;
                   in_d(count)<= i_data;
                elsif (count=8)  then
                   count<=0;
                   start_bit<='1';
                end if;
            when s2 =>
                o_start_cmd <='1';
                o_rd_ack <= '0';
                en_fetch <='0';
                o_cmd_reg<=in_d(2 downto 0);
                o_param_reg <=in_d(7 downto 3);
            when s3 =>
               -- if (i_eval_result='1') then 
               -- eval_res<='1';
               eval_resul<=i_eval_result;
                o_wr_req <='1';
            when s4 =>
                o_data <= eval_resul;
            when others =>
                    o_rd_ack <= '0';
                    o_wr_req<='0';
                    en_fetch<='0';
                    
        end case;
    end process p_state;
    
        
 end architecture rtl;