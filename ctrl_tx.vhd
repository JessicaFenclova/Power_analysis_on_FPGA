library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity ctrl_tx is
  port (
    i_clk1     : in std_logic;
    i_clk2     : in std_logic;
    i_rst      : in std_logic;
    i_wr_req   : in std_logic;
    i_data_tx  : in std_logic_vector(7 downto 0);
    o_wr_ack   : out std_logic;
    o_data_tx  : out std_logic    
  
    );
 end ctrl_tx;
 
 architecture rtl of ctrl_tx is
 
    signal shift_reg: std_logic_vector(9 downto 0):="0000000000";
    signal proc_data: std_logic :='0'; -- flag if data is being processed 
     
     
  begin
  
   p_tx : process(i_clk1, i_rst)
    begin
        if i_rst = '0' then
          shift_reg<="0000000000";          
          o_wr_ack <= '0';
          --o_start_tx<='0';
          --o_stop_tx<='0';
          o_data_tx <= '1';
          proc_data <='0';
        elsif i_clk1'event and (i_clk1='1') then
          if (proc_data='1') then
            if (i_clk2='1') then        
               shift_reg(8 downto 0)<= shift_reg(9 downto 1);
               shift_reg(9)<=  '0';
                --shift_reg(9)<= i_data_tx;
               o_data_tx <= shift_reg(0);
              if (shift_reg="0000000000") then --"0000000000"
                --stop<='1';
                --o_stop_tx<='1';
                o_wr_ack <='0'; -- 1
                --o_start_tx<='0';
                proc_data<='0';
                o_data_tx <= '1'; --added so that when nothing is being sent the signal is in a 1
                --else
                --stop<='0';
                --o_stop_tx<='0';
                --o_wr_ack <='0'; -- ? or 1 
              end if;
            end if;
             
          else         
            if (i_wr_req='1') then
               --o_start_tx<='1';
               --o_stop_tx<='0';
               o_wr_ack <='1'; -- 0
               shift_reg(9)<='1';
               shift_reg(8 downto 1)<=i_data_tx;
               shift_reg(0)<='0';
               proc_data<='1';
            --else
             --o_start_tx<='0';
            end if; 
          end if;          
                    
        end if;
    end process p_tx;
      
        
 end architecture rtl;