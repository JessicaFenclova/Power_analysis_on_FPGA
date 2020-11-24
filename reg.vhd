library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity reg is
  port (
    i_clock     : in std_logic;
    i_res_reg   : in std_logic;
    i_dat       : in std_logic;  --data in is serial
    o_dat       : out std_logic_vector(7 downto 0); --data out is parallel
    o_counter   : out std_logic_vector(3 downto 0);
    o_start_bit : out std_logic;
    o_stop_bit  : out std_logic
  
    );
 end reg;
 
 architecture rtl of reg is
 
    signal  in_d : std_logic_vector(7 downto 0):= "11111111";
    signal count : integer :=0;
    
  begin
    p_reg : process (i_clock, i_res_reg)
     begin
       if i_res_reg ='0' then 
         o_dat <= "11111111";  
         in_d <=  "11111111";
         count <= 0;
         o_start_bit <= '0';
         o_stop_bit <= '0';
       elsif i_clock'event and (i_clock='1') then
         if (count=0) then
           if (i_dat= '0') then
            o_start_bit <= '1';
            count <= (count+1);
           else
             o_start_bit <= '0';
           end if;
         elsif (count=9) then
           if (i_dat= '1') then
            o_stop_bit <= '1';
           count <=0;
           else
             o_stop_bit <= '0';
           end if; 
         elsif (count>0) and (count<9) then
          in_d(count-1) <= i_dat;
          count <= (count+1);
          o_start_bit <= '0';
         else
          o_dat <= "11111111";  
          count <= 0; 
         end if;
       
       end if;
     o_dat <= in_d;
     o_counter <= std_logic_vector(to_unsigned(count,o_counter'length));
     
   end process p_reg;
   
 end rtl;
    