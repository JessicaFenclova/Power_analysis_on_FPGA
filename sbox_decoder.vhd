library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity sbox_decoder is
  port (
        i_clock    : in std_logic;
        i_reset    : in std_logic;
        i_enable   : in std_logic;    
        i_param    : in std_logic_vector(4 downto 0);
        o_en_sbox  : out std_logic_vector(31 downto 0) --32 options, param 5 bits 2^5 -> 32        
        
       );
  end sbox_decoder;
  
  architecture rtl of sbox_decoder is
  
     --signal out_shift_xor : std_logic; 
     
  begin
  
   p_decoder : process(i_clock, i_reset)
    begin
        if i_reset = '0' then
           o_en_sbox<="00000000000000000000000000000001";           --one sbox or none
           
        elsif i_clock'event and (i_clock='1') then
            
            if (i_enable='1') then
              case i_param is   
                     -- do I want 00000 as in zero sboxes
                   when "00000" => o_en_sbox <= "00000000000000000000000000000001"; -- for enabling 1 sbox   
                   when "00001" => o_en_sbox <= "00000000000000000000000000000011"; -- then two
                   when "00010" => o_en_sbox <= "00000000000000000000000000000111";  -- then three
                   when "00011" => o_en_sbox <= "00000000000000000000000000001111";  --4
                   when "00100" => o_en_sbox <= "00000000000000000000000000011111";  --5
                   when "00101" => o_en_sbox <= "00000000000000000000000000111111";  --6
                   when "00110" => o_en_sbox <= "00000000000000000000000001111111"; --7
                   when "00111" => o_en_sbox <= "00000000000000000000000011111111";  --8
                   when "01000" => o_en_sbox <= "00000000000000000000000111111111"; --9
                   when "01001" => o_en_sbox <= "00000000000000000000001111111111"; --10
                   when "01010" => o_en_sbox <= "00000000000000000000011111111111"; --11
                   when "01011" => o_en_sbox <= "00000000000000000000111111111111";--12
                   when "01100" => o_en_sbox <= "00000000000000000001111111111111";--13
                   when "01101" => o_en_sbox <= "00000000000000000011111111111111";  --14
                   when "01110" => o_en_sbox <= "00000000000000000111111111111111"; --15
                   when "01111" => o_en_sbox <= "00000000000000001111111111111111"; --16
                   when "10000" => o_en_sbox <= "00000000000000011111111111111111"; --17
                   when "10001" => o_en_sbox <= "00000000000000111111111111111111"; --18
                   when "10010" => o_en_sbox <= "00000000000001111111111111111111"; --19
                   when "10011" => o_en_sbox <= "00000000000111111111111111111111"; --20
                   when "10100" => o_en_sbox <= "00000000001111111111111111111111"; --21
                   when "10101" => o_en_sbox <= "00000000011111111111111111111111"; --22
                   when "10110" => o_en_sbox <= "00000000011111111111111111111111"; --23                                               
                   when "10111" => o_en_sbox <= "00000000111111111111111111111111"; --24
                   when "11000" => o_en_sbox <= "00000001111111111111111111111111"; --25
                   when "11001" => o_en_sbox <= "00000011111111111111111111111111"; --26
                   when "11010" => o_en_sbox <= "00000111111111111111111111111111"; --27
                   when "11011" => o_en_sbox <= "00001111111111111111111111111111"; --28
                   when "11100" => o_en_sbox <= "00011111111111111111111111111111"; --29
                   when "11101" => o_en_sbox <= "00111111111111111111111111111111"; --30
                   when "11110" => o_en_sbox <= "01111111111111111111111111111111";  --31
                   when "11111" => o_en_sbox <= "11111111111111111111111111111111";  --32
                   when others => o_en_sbox  <= "00000000000000000000000000000000";  --none  or  one sbox?
              end case;     
               
            
            else
               o_en_sbox  <= "00000000000000000000000000000000";               
            end if;
            
        end if;
  end process p_decoder;


 end architecture rtl;