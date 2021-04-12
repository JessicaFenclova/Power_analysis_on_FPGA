library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sbox is 
end;

architecture sim of tb_sbox is

 component sbox is 
  port (
        input_byte  : in std_logic_vector(7 downto 0);
        output_byte : out std_logic_vector(7 downto 0)
       );
 end component;
 
 signal input : std_logic_vector(7 downto 0);
 signal output : std_logic_Vector(7 downto 0);
 
 begin
  dut: sbox
    port map 
     (
      input_byte  => input,
      output_byte => output
     ); 
     
     
     
     process 
   begin
      input <= x"01";    --x"7c"
      wait for 1100 ns;
      input <= x"03";   --x"7b"
      wait for 2120 ns;
      input <= x"05";  --x"6b" 
      wait for 2100 ns;
      input <= x"07";   --x"c5"
      wait for 2100 ns;
      input <= x"09"; 
      wait for 2100 ns;
      wait;
 end process;
 
end;