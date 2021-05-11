library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



  entity xor_sbox is
    generic (
             groups : integer range 2 to 255    -- groups value given by num of sboxes
            );
    port (
        input_byte  : in std_logic_vector((8*groups)-1 downto 0);
        output_byte : out std_logic_vector(7 downto 0)    
       );
  end xor_sbox;

 architecture rtl of xor_sbox is

  --type newArray is array (7 downto 0) of std_logic;
  --type arr_2d is array    (30 downto 0) of newArray;  --31x7 array
  --signal arr_sig     : arr_2d;
  --signal output_sbox : std_logic_vector(7 downto 0);

  begin
  
    --if () then
      --output_sbox <= input_byte() xor input_byte();
    --else
      --arr_sig <= (others => (others => '0');
    --end if; 
     pr_xor: process(input_byte)
        variable result : std_logic_vector(7 downto 0);
      begin
        result:= input_byte(7 downto 0);
        for i in 2 to groups loop
            result := result xor input_byte((i*8)-1 downto (i-1)*8);
        end loop;
        output_byte <= result;
      end process;
  
  
  
  
  
  end architecture rtl;