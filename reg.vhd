library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity reg is
  port (
    i_clock     : in std_logic;
    i_reset     : in std_logic;
    i_data      : in std_logic;  --data in is serial
    o_data      : out std_logic_vector(7 downto 0); --data out is parallel
    o_counter   : out std_logic_vector(3 downto 0);
    o_start_bit : out std_logic
  
    );
 end reg;
 
 architecture rtl of reg is
 
    signal  in_d : std_logic_vector(7 downto 0):= "11111111";
    signal count : integer :=0;
    
  begin
    p_reg : process (i_clock, i_reset)
     begin
       if i_reset ='0' then 
         o_data <= "11111111";  
         in_d <=  "11111111";
         count <= 0;
         o_start_bit <= '0';
       elsif i_clock'event and (i_clock='1') then
         if (count=0) then
           if (i_data= '0') then
            o_start_bit <= '1';
            count <= (count+1);
           else
             o_start_bit <= '0';
           end if;
         elsif (count=9) then
           
           count <=0; 
         elsif (count>0) and (count<9) then
          in_d(count-1) <= i_data;
          count <= (count+1);
          o_start_bit <= '0';
         else
          o_data <= "11111111";  
          count <= 0; 
         end if;
       
       end if;
     o_data <= in_d;
     o_counter <= std_logic_vector(to_unsigned(count,o_counter'length));
     
   end process p_reg;
   
 end rtl;
    