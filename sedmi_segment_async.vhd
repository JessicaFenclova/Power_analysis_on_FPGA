-- pak to bude first_test.vhd , otevrít z ModelSim (edit.new.file.vhd) 
-- asi by to chtelo se podivat jak PSPad s VHLD, jestli dostahnout nebo jak..

-- CTRL + F9 = KOMPILACE normálnì podle modelsimu 

LIBRARY ieee; -- obrovská knihovna

USE ieee.std_logic_1164.ALL; --  balík z knihovny (singály, logické operátory, vektroy..)
USE ieee.numeric_std.ALL; -- balík z knihovny (pokud potrebujeme po?ítat)


ENTITY sedmi_segment_async IS --
PORT
(
  input_IN : IN STD_LOGIC_VECTOR(0 TO 3); 
  output_SEGMENT : OUT STD_LOGIC_VECTOR(0 TO 6)
);

END sedmi_segment_async; 


ARCHITECTURE rtl OF sedmi_segment_async IS  

BEGIN -- telo architektury, vsechno co je mezi begin a end se deje v jeden okamziku

pro_1: PROCESS(input_IN)
BEGIN
  
  segment: CASE input_IN IS
              WHEN "0000" =>
        output_SEGMENT <= "1111110";
              WHEN "0001" =>
        output_SEGMENT <= "0000110";
              WHEN "0010" =>
        output_SEGMENT <= "1011011";
              WHEN "0011" =>
        output_SEGMENT <= "1001111";
              WHEN "0100" =>
        output_SEGMENT <= "0100111";
              WHEN "0101" =>
        output_SEGMENT <= "1101101";
              WHEN "0110" =>
        output_SEGMENT <= "1111101";
              WHEN "0111" =>
        output_SEGMENT <= "1000110";
              WHEN "1000" =>
        output_SEGMENT <= "1111111";
              WHEN "1001" =>
        output_SEGMENT <= "1101111";           
              WHEN "1010" =>
        output_SEGMENT <= "1110111";
              WHEN "1011" =>
        output_SEGMENT <= "0111101";
              WHEN "1100" =>
        output_SEGMENT <= "1111000";
              WHEN "1101" =>
        output_SEGMENT <= "0011111";
              WHEN "1110" =>
        output_SEGMENT <= "1111001";
              WHEN "1111" =>
        output_SEGMENT <= "1110001";
               WHEN others =>
        output_SEGMENT <= "0000000";
              
    END CASE;
    
END PROCESS pro_1;

END ARCHITECTURE rtl; -- konec architecture a begin  


