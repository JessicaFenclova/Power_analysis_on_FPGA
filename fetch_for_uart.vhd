library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity fetch_for_uart is
  port (
    i_clk       : in std_logic;
    i_rst       : in std_logic;
    i_data      : in std_logic;
    o_start     : out std_logic;
    o_rd_ack    : out std_logic; -- maybe another signal out en fetch
    o_cmd       : out std_logic_vector(2 downto 0);
    o_param     : out std_logic_vector(4 downto 0)    
  
    );
 end fetch_for_uart;
 
 architecture rtl of fetch_for_uart is
 
 
    signal en_fetch : std_logic :='0';
    signal  in_d    : std_logic_vector(7 downto 0);
    signal count    : integer :=0;
 
       
  begin
  
    p_fetch: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
           en_fetch<='0';
           count <=0;
           o_start <='0';
           o_rd_ack<='0';
           o_cmd<="111";
           o_param<="11111";
        elsif i_clk'event and (i_clk='1') then
            if (i_data='0') and (count =0) then          -- checking for start bit
               en_fetch <='1';
               o_start <='1';               
            end if;
            
            if (en_fetch='1') then
               in_d(count) <= i_data;
               count <= count+1;
            end if;
                                  
            if (count=7) then    
                o_rd_ack <='1';  
                count <= 0;
                o_start<='0';
                o_cmd <=in_d(2 downto 0);
                o_param <= in_d(7 downto 3);                      
            end if;
                     
        end if;
    end process p_fetch;
    
        
 end architecture rtl;