library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity reg_sbox is
  --generic (parambits : std_logic_vector(4 downto 0));
    
  port (
        input_CLK     : in std_logic;
        input_RESTART : in std_logic;
        input_ENABLE  : in std_logic;
        input_TRIG    : in std_logic;
        input_IN      : in std_logic_vector(7 downto 0); 
        output_Q      : out std_logic_vector(7 downto 0)
       );

  end reg_sbox; 


architecture rtl of reg_sbox is  
  
--CONSTANT jedna: STD_LOGIC := '1';
 

 begin 

  pro_1: process(input_CLK,input_RESTART)
   begin
     if input_RESTART ='0' then 
 
    --FOR i IN 0 TO 7 LOOP
      output_Q <= "11111111";
    --END LOOP;
 
     elsif (input_CLK'event and input_CLK ='1') then
       if (input_ENABLE='1') and (input_TRIG='1') then
          output_Q <= input_IN;
       else
          --do I want all ones or zeros
       end if;
      --FOR i IN 0 TO 7 LOOP
     --output_Q(i) <= input_IN(i);
     --END LOOP;
  
     end if;
   
  end process pro_1;


end architecture rtl;