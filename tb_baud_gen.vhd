library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_baud_gen is -- prazdna entita protoze jen testuje
end;

architecture sim of tb_baud_gen is

component baud_gen is       -- component definuje stejne jako ta entita ktera se testuje
 port
    (
     i_clkin  : in std_logic;
     i_res    : in std_logic;
     o_clkout : out std_logic
       --clk_per_bits : out integer;
    );
end component;

    signal clk:std_logic;
    signal reset:std_logic;
    signal clkout:std_logic;
    
begin
dut: baud_gen
    port map 
     (
      i_clkin=>clk,
      i_res=>reset,
      o_clkout=>clkout
     );
     
process 
begin
    reset<='0';
    wait for 100 ns;
    reset<= '1';
    wait;
end process;

process 
begin    
    clk<='0';
    wait for 100 ns;
    clk<='1';
    wait for 100 ns;
    clk<='0';
    wait for 100 ns;
    clk<='1';
    wait for 100 ns; 
end process;              
end;