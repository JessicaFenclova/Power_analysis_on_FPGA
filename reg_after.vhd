library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity reg_after is
  --generic (parambits : std_logic_vector(4 downto 0));
    
  port (
        in_CLK     : in std_logic;
        in_RESTART : in std_logic;
        in_ENABLE  : in std_logic;
        in_IN      : in std_logic_vector(7 downto 0); 
        out_Q      : out std_logic_vector(7 downto 0)
       );

  end reg_after; 


architecture rtl of reg_after is  
  
--CONSTANT jedna: STD_LOGIC := '1';
 --signal in_data: std_logic_vector(7 downto 0):="11111111"; 

 begin 

  pro_1: process(in_CLK,in_RESTART)
   begin
     if in_RESTART ='0' then 
 
    --FOR i IN 0 TO 7 LOOP
      out_Q <= "11111111";
    --END LOOP;
 
     elsif (in_CLK'event and in_CLK ='1') then
       --in_data<= in_IN;
       if (in_ENABLE='1') then
          out_Q <= in_IN;
       
       end if;
      --FOR i IN 0 TO 7 LOOP
     --output_Q(i) <= input_IN(i);
     --END LOOP;
  
     end if;
   
  end process pro_1;


end architecture rtl;