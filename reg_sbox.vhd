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
--signal save_input: std_logic_vector(7 downto 0):= "00000000";
signal enabled: std_logic :='0'; 

 begin 

  pro_1: process(input_CLK,input_RESTART)
   begin
     if input_RESTART ='0' then 
 
    --FOR i IN 0 TO 7 LOOP
      enabled<='0';
      output_Q <= "00000000";
    --END LOOP;
 
     elsif (input_CLK'event and input_CLK ='1') then
       if (input_ENABLE='1') then
          enabled <= '1';
       end if;
       if (enabled='1') and (input_TRIG='1') then
          output_Q <= input_IN;
       end if;
      --FOR i IN 0 TO 7 LOOP
     --output_Q(i) <= input_IN(i);
     --END LOOP;
  
     end if;
   
  end process pro_1;


end architecture rtl;