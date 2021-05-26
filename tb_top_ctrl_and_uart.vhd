library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_ctrl_and_uart is 
end;

architecture sim of tb_top_ctrl_and_uart is

 component top_ctrl_and_uart is 
  port (
         i_clock    : in std_logic;
         i_reset    : in std_logic;
         i_data      : in std_logic;
         i_data_sbox : in std_logic_vector(7 downto 0);
         o_trigger   : out std_logic;
         o_bits_sbox : out std_logic_vector(7 downto 0);
         o_test_bit  : out std_logic;
         o_data      : out std_logic           
  
       );
    
 end component;
 
     signal clk       : std_logic;
     signal reset     : std_logic;
     signal trig      : std_logic;
     signal data_out  : std_logic;      
     signal datain    : std_logic;
     signal datasbox  : std_logic_vector(7 downto 0);
     signal gener_bits: std_logic_vector(7 downto 0);
     signal test      : std_logic;
     signal e : std_logic;

    
     
 begin
  dut: top_ctrl_and_uart
    port map 
     (
      i_clock    => clk,  
      i_reset    => reset,     
      i_data   => datain, 
      i_data_sbox  => datasbox,  
      o_trigger   => trig,
      o_bits_sbox => gener_bits,
      o_test_bit => test,
      o_data  => data_out
                
     );
     
 process 
   begin
      reset<='0';
      wait for 20 ns;
      reset<= '1';
      wait for 30 ns;
      reset<='0';
      wait for 30 ns;
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
      datasbox <= "00000000";  
      wait for 401000 ns;
      datasbox <= "11110000";  
      wait for 81200 ns;
      datasbox <= "11111111";   
      wait for 81500 ns;
      datasbox <= "00110011"; 
      wait for 61000 ns;
      datasbox <= "10000001";  
      wait for 61000 ns;
      datasbox <= "11110000";  
      wait for 61200 ns;
      datasbox <= "11111111";
      wait for 681000 ns;
      datasbox <= "00000000";  
      
      wait;
 end process; 
 
 process 
   begin
      e <= '0';
      
      --datain <= '1';   --begin
      --wait for 18620 ns;
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
      datain <= '1';     --7
      wait for 17400 ns;
      datain <= '1';     --8
      wait for 17400 ns;
      datain <= '1';     --9
      wait for 52400 ns;
      datain <= '0';   --0   -----------------
      wait for 17400 ns; 
      datain <= '1';    --1
      wait for 17400 ns;
      datain <= '0';    --2
      wait for 17400 ns;
      datain <= '1';    --3
      wait for 17400 ns;
      datain <= '0';    --4
      wait for 17400 ns;
      datain <= '1';    --5
      wait for 17400 ns;
      datain <= '0';     --6
      wait for 17400 ns;
      datain <= '1';     --7
      wait for 17400 ns;
      datain <= '0';     --8
      wait for 17400 ns;
      datain <= '1';     --9
      wait for 52400 ns;
      datain <= '0';   --0 ============
      wait for 17400 ns; 
      datain <= '1';    --1
      wait for 17400 ns;
      datain <= '1';    --2
      wait for 17400 ns;
      datain <= '1';    --3
      wait for 17400 ns;
      datain <= '1';    --4
      wait for 17400 ns;
      datain <= '0';    --5
      wait for 17400 ns;
      datain <= '0';     --6
      wait for 17400 ns;
      datain <= '0';     --7
      wait for 17400 ns;
      datain <= '0';     --8
      wait for 17400 ns;
      datain <= '1';     --9
      wait for 52400 ns;
      datain <= '0';   --0 ´´´´´´´´´´´´´´´´´´´´
      wait for 17400 ns; 
      datain <= '1';    --1
      wait for 17400 ns;
      datain <= '0';    --2
      wait for 17400 ns;
      datain <= '1';    --3
      wait for 17400 ns;
      datain <= '0';    --4
      wait for 17400 ns;
      datain <= '1';    --5
      wait for 17400 ns;
      datain <= '0';     --6
      wait for 17400 ns;
      datain <= '1';     --7
      wait for 17400 ns;
      datain <= '1';     --8
      wait for 17400 ns;
      datain <= '1';     --9 
      wait for 52400 ns;
      datain <= '0';   --0 ´========================
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
      datain <= '0';     --6
      wait for 17400 ns;
      datain <= '1';     --7
      wait for 17400 ns;
      datain <= '1';     --8
      wait for 17400 ns;
      datain <= '1';     --9 
      wait for 6 ms; 
      
      
      e <= '1';
      wait;
      
 end process;
 
    
 
end;
 
 