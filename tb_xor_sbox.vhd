library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_xor_sbox is 
end;

architecture sim of tb_xor_sbox is

 constant s : integer := 3;
 signal input : std_logic_vector((8*s)-1 downto 0);
 signal output : std_logic_Vector(7 downto 0);
 
 component xor_sbox is 
  generic (
            groups : integer range 2 to 255 := s    -- groups value given by num of sboxes
          );
  port (
        input_byte  : in std_logic_vector((8*groups)-1 downto 0);
        output_byte : out std_logic_vector(7 downto 0)
       );
 end component;
 
 
 
 begin
  dut: xor_sbox
    port map 
     (
      input_byte  => input,
      output_byte => output
     ); 
     
     
     
  process 
   begin
      input <= "000000010000000100000011";
      --input <= "000000010000000100000000";  
      --wait for 1100 ns;
      --input <= "0000000100000000"; 
      --wait for 1100 ns;
      --input <= "1111111111111111";  
      --wait for 2120 ns;
      --input <= "";   
      --wait for 2100 ns;
      --input <= x"07";   
      --wait for 2100 ns;
      --input <= x"09"; 
      --wait for 2100 ns;
      wait;
 end process;
 
end;