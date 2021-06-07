library ieee;

use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 


entity registr_8bit_async is --
port
(
  input_IN : in std_logic_vector(7 downto 0);   --10 downto 0
  input_CLK : in std_logic;
  input_RESTART : in std_logic;
  output_Q : out std_logic_vector(7 downto 0)
);

end registr_8bit_async; 


architecture rtl of registr_8bit_async is  

CONSTANT nula: std_logic := '0';   
CONSTANT jedna: std_logic := '1';

begin 

pro_1: process(input_CLK,input_RESTART)
begin
  if input_RESTART ='0' then 
 
  for i in 0 to 7 loop
  output_Q(i) <= '0';
  end loop;
 
  elsif input_CLK'event and input_CLK ='1' then
  for i in 7 downto 0 loop
  output_Q(i) <= input_IN(i);--i+3
  end loop;
  
  
  end if;
end process pro_1;

-- output_y <= input_a and input_b; -- zapsani do portu nebo signalu <=, and, not, nor, xor atd.., ZAVORKOVAT!! divny veci s prioritama

end architecture rtl; -- konec architecture a begin  

