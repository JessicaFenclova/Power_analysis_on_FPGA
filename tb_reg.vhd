library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_reg is 
end;

architecture sim of tb_reg is

component reg is      
   port (
     i_clock     : in std_logic;
     i_reset     : in std_logic;
     i_data      : in std_logic;  --data in is serial
     o_data      : out std_logic_vector(7 downto 0); --data out is parallel
     o_counter   : out std_logic_vector(3 downto 0);
     o_start_bit : out std_logic
  
    );
 end component;
 
     signal clk     : std_logic;
     signal reset   : std_logic;
     signal datain  : std_logic;
     signal dataout : std_logic_vector(7 downto 0);
     signal counter : std_logic_vector(3 downto 0);
     signal startb  : std_logic;
     signal e:std_logic;
     
     
 begin
  dut: reg
    port map 
     (
      i_clock=>clk,
      i_reset=>reset,
      i_data=>datain,
      o_data=>dataout,
      o_counter=>counter,
      o_start_bit=>startb
    
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
    datain <= '1';   -- nez zacne takze na vystup same 0
    wait for 50 ns;   
    datain <= '0'; --start bit
    wait for 30 ns;
    datain <= '1';
    wait for 30 ns;
    datain <= '1';
    wait for 30 ns;
    datain <= '1';
    wait for 30 ns;
    datain <= '1';
    wait for 30 ns;
    datain <= '1';
    wait for 30 ns;
    datain <= '0';
    wait for 30 ns;
    datain <= '0';
    wait for 30 ns;
    datain <= '1';
    wait for 30 ns;
    
    e <= '1';
    wait;
    
 end process;
end;