library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_cpa is 
end;

architecture sim of tb_top_cpa is

     constant s : integer := 2;    --or change to make it work with the signal out_en_sbox, that will be the value of generic

     signal clk       : std_logic;
     signal reset     : std_logic;
     signal trig      : std_logic;
     signal data_out  : std_logic;      
     signal datain    : std_logic;
     signal e : std_logic;

 component top_cpa is 
  generic (num_sbox : integer range 1 to 32:= s);
  port (
         i_cloc    : in std_logic;
         i_res     : in std_logic;
         i_data_rx : in std_logic;
         o_trigger : out std_logic;
         o_data_tx : out std_logic           
  
       );
 end component;
 
     
     
  begin
  dut: top_cpa
    port map 
     (
      i_cloc    => clk,  
      i_res    => reset,     
      i_data_rx   => datain,  
      o_trigger   => trig,
      o_data_tx  => data_out
                
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
      wait for 40 ns;
      clk<='1';
      wait for 40 ns;    
    
      if e = '1' then 
       wait;
      end if;     
 end process;
 
 process
   begin
 
      e <= '0';
      datain <= '1';   --begin
      wait for 18620 ns;
      datain <= '0';   --0
      wait for 17400 ns; 
      datain <= '1';    --1
      wait for 17400 ns;
      datain <= '1';    --2
      wait for 17400 ns;
      datain <= '1';    --3
      wait for 17400 ns;
      datain <= '1';    --4
      wait for 17400 ns;
      datain <= '1';    --5
      wait for 17400 ns;
      datain <= '1';     --6
      wait for 17400 ns;
      datain <= '0';     --7
      wait for 17400 ns;
      datain<= '0';     --8
      wait for 17400 ns;
      datain <= '1';     --9
      wait for 52400 ns;
      datain <= '0';   --0
      wait for 17400 ns; 
      datain <= '1';    --1
      wait for 17400 ns;
      datain <= '1';    --2
      wait for 17400 ns;
      datain <= '0';    --3
      wait for 17400 ns;
      datain <= '0';    --4
      wait for 17400 ns;
      datain <= '1';    --5
      wait for 17400 ns;
      datain <= '1';     --6
      wait for 17400 ns;
      datain <= '0';     --7
      wait for 17400 ns;
      datain <= '0';     --8
      wait for 17400 ns;
      datain <= '1';     --9 
      wait for 6 ms; 
    
      e <= '1';
      wait;
    
 end process;
 
 
 
    
 
end;



