library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity tx is
  port (
    i_clk      : in std_logic;
    i_rst      : in std_logic;
    i_rd_ack   : in std_logic;
    i_cnt      : in std_logic_vector(3 downto 0);
    o_rd_req   : out std_logic;
    o_en       : out std_logic    
  
    );
 end tx;
 
 architecture rtl of tx is
     
     
  begin
  
   p_tx : process(i_clk, i_rst)
    begin
        if i_rst = '0' then          
          o_rd_req <= '0';
          o_en <= '0';
        elsif i_clk'event and (i_clk='1') then
          if (i_cnt="0111") then
            o_rd_req<= '1';
            o_en <= '0';
          else
            o_rd_req<= '0';
          end if;
          if  (i_rd_ack='1') then
              o_en <='1';
          end if;
                    
        end if;
    end process p_tx;
      
        
 end architecture rtl;
  