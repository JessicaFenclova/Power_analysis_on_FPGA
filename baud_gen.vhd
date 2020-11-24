library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_gen is
   generic (
            baudrate    : integer := 115200;         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
            over_sample : integer := 16
           );
   
   port (
       i_clkin : in std_logic;
       i_res : in std_logic;
       o_clkout : out std_logic 
       --clk_per_bits : out integer;
        );
        
end baud_gen;

architecture rtl of baud_gen is
        
        signal count : integer;
        constant prescaler : integer := (50000000/(baudrate*over_sample));
        
begin
    pro_1 : process (i_clkin, i_res)
    begin
      if i_res = '0' then
         count <= 1;
         o_clkout <= '0';
         --temp <= '0';
         elsif rising_edge(i_clkin) then
         count <= count + 1;
         if count = prescaler  then    --115200*16 so 1843200 to Rx divide 27 and 16 so 115200 
            o_clkout <='1';
            --temp <= not temp;   
         elsif count = prescaler+1 then 
            count <= 1;
            o_clkout <= '0';
            --temp <= not temp;                
         end if;   
      end if;
      
        --o_clkout <= temp;
            
    end process pro_1;
end;            