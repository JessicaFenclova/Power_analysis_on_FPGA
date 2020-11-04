library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity shift_r is
  port (
    i_clock_sh   : in std_logic;
    i_reset_sh   : in std_logic;
    i_en_sh      : in std_logic;  
    i_data_sh    : in std_logic_vector(7 downto 0);  --data in is parallel
    o_data_sh    : out std_logic --data out is parallel
    
    );
 end shift_r;
 
 architecture rtl of shift_r is
 
    signal  in_d : std_logic_vector(7 downto 0):= "11111111";
    signal counter: integer :=0;
    
 begin
    p_shift: process (i_clock_sh,i_reset_sh)
    begin
         if i_reset_sh ='0' then
             counter <= 0;
             o_data_sh <=  '1';
         elsif i_clock_sh'event and (i_clock_sh='1') then
            if (i_en_sh='1') then
              in_d <= i_data_sh;
              o_data_sh <= in_d (counter);
              counter <= (counter + 1);
            else
                o_data_sh <= '1';
                counter <= 0;             
            end if;
        end if;
    end process p_shift;
 end;