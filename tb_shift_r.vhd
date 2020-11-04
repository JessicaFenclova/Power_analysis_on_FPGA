library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shift_r is 
end;

architecture sim of tb_shift_r is

component shift_r is      
   port (
    i_clock_sh   : in std_logic;
    i_reset_sh   : in std_logic;
    i_en_sh      : in std_logic;  
    i_data_sh    : in std_logic_vector(7 downto 0);  --data in is parallel
    o_data_sh    : out std_logic --data out is parallel
    
    );
 end component;
 
     signal clk     : std_logic;
     signal reset   : std_logic;
     signal en      : std_logic;
     signal datain  : std_logic_vector(7 downto 0);
     signal dataout : std_logic;
     signal e:std_logic;
     
     
 begin
  dut: shift_r
    port map 
     (
      i_clock_sh=>clk,
      i_reset_sh=>reset,
      i_en_sh=> en,
      i_data_sh=>datain,
      o_data_sh=>dataout    
    
     );
 process 
  begin
    reset<='0';
    wait for 10 ns;
    reset<= '1';
    wait;
 end process;
 
 process 
  begin
    en<='0';
    wait for 20 ns;
    en<= '1';
    wait;
 end process;
 
 process 
  begin    
    clk<='0';
    wait for 10 ns;
    clk<='1';
    wait for 10 ns;    
    
    if e = '1' then 
    wait;
    end if;
    
    
     
 end process;
 
 process
  begin
 
    e <= '0';
    datain <= "11110001";   -- nez zacne takze na vystup same 0
    wait for 60 ns;   
   
    
    e <= '1';
    wait;
    
 end process;
end;