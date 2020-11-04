library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity rx is
  port (
    i_clk      : in std_logic;
    i_rst      : in std_logic;
    i_wr_req   : in std_logic;
    i_dete_str : in std_logic;
    i_cnt      : in std_logic_vector(3 downto 0);
    o_wr_ack   : out std_logic;
    o_en       : out std_logic    
  
    );
 end rx;
 
 architecture rtl of rx is      
  begin
  
    p_rx: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
          o_en <='0';
          o_wr_ack <= '0';
        elsif i_clk'event and (i_clk='1') then
          if (i_wr_req='1') and (i_cnt="0111") then
             o_wr_ack <= '1';
            if (i_dete_str='1') then
              o_en <='1';
            end if;
            else
              o_wr_ack <='0';
          end if;
          
        end if;
    end process p_rx;
    
        
 end architecture rtl;
  
 
   