library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity wait_for_uart is
  port (
    i_clk       : in std_logic;
    i_rst       : in std_logic;
    i_rd_req    : in std_logic;
    i_data      : in std_logic;
    --o_rd_ack    : out std_logic; -- do i want another signal out ready
    o_data      : out std_logic    
  
    );
 end wait_for_uart;
 
 architecture rtl of wait_for_uart is
 
 
    signal enable: std_logic :='0';
    --signal  in_d : std_logic;
    signal count : integer :=0;
 
       
  begin
  
    p_wait: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
           --in_d <="11111111";
           o_data <='1';
           enable<='0';
           count <=0;
        elsif i_clk'event and (i_clk='1') then
            if (i_rd_req='1') then
               enable <='1';
               
            end if;
            if (enable='1') then
               o_data <= i_data;
               count <= count+1;
            end if;
                                  
            if (count=7) then    
                --o_rd_ack <='1';   -- set by req being recieved or by data being sent all bits and what resets this
                count <= 0;
                enable<='0';                      
            end if;
                     
        end if;
    end process p_wait;
    
        
 end architecture rtl;