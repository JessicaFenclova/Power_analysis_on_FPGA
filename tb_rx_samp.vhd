library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rx_samp is 
end;

architecture sim of tb_rx_samp is

 component rx_sampling is      
   port (
         i_clk       : in std_logic;
         i_rst       : in std_logic;
         i_data_rx   : in std_logic;
         o_start_bit : out std_logic
         --o_edge      : out std_logic;
         --o_cnt       : out std_logic_vector(3 downto 0);
         --o_encnt     : out std_logic
        );
 end component;
 
     signal clk     : std_logic;
     signal reset   : std_logic;
     signal i_data  : std_logic;
     signal start   : std_logic;
     --signal edge    : std_logic;
     --signal o_count : std_logic_vector(3 downto 0);
     --signal o_en    : std_logic;
     signal e       :std_logic;
     
     
 begin
  dut: rx_sampling
    port map 
     (
      i_clk=>clk,
      i_rst=>reset,
      i_data_rx=>i_data,
      o_start_bit=>start
      --o_edge=>edge,
      --o_cnt=>o_count,
      --o_encnt => o_en          
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
      wait for 20 ns;
      clk<='1';
      wait for 20 ns;    
    
      if e = '1' then 
      wait;
      end if;     
 end process; 
 
 
 process
   begin
 
      e <= '0';
      i_data <= '1';   --begin
      wait for 680 ns;
      i_data <= '0';   --0
      wait for 680 ns; 
      i_data <= '1';    --1
      wait for 680 ns;
      i_data <= '1';    --2
      wait for 680 ns;
      i_data <= '1';    --3
      wait for 680 ns;
      i_data <= '1';    --4
      wait for 680 ns;
      i_data <= '1';    --5
      wait for 680 ns;
      i_data <= '1';     --6
      wait for 680 ns;
      i_data <= '0';     --7
      wait for 680 ns;
      i_data <= '0';     --8
      wait for 680 ns;
      i_data <= '1';     --9
      wait for 900 ns; 
      
    
      e <= '1';
      wait;
    
 end process;
end;     
        