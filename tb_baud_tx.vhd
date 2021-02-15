library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_baud_tx is -- prazdna entita protoze jen testuje
end;

architecture sim of tb_baud_tx is

component baud_gen_tx is       -- component definuje stejne jako ta entita ktera se testuje
 port
    (
       i_clkin     : in std_logic;
       i_res       : in std_logic;
       i_en        : in std_logic;
       --i_stop_clk  : in std_logic;
       o_clkout    : out std_logic
    );
end component;

    signal clk: std_logic;
    signal reset: std_logic;
    signal start: std_logic;
    --signal stop: std_logic;
    signal clkout: std_logic;
    
begin
dut: baud_gen_tx
    port map 
     (
      i_clkin=>clk,
      i_res=>reset,
      i_en =>start,
      --i_stop_clk=>stop,
      o_clkout=>clkout
     );
     
process 
begin
    reset<='0';
    wait for 100 ns;
    reset<= '1';
    wait for 1500 ns;
    reset<='0';
    wait for 100 ns;
    reset<= '1';
    wait;
end process;

process 
begin
    start<='0';
    wait for 200 ns;
    start<= '1';
    wait for 250 ms;
    start<='0';
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