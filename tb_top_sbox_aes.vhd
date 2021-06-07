library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_sbox_aes is 
end;

architecture sim of tb_top_sbox_aes is

 component top_sbox_aes is 
  port (
        i_clock    : in std_logic;
        i_reset    : in std_logic;
        i_enable   : in std_logic; --might need another enable signal for the register after the sbox, or it may be possible to generate the signal inside of this entity which would be set after the trigger signal is reset
        i_trigger  : in std_logic;    
        i_data     : in std_logic_vector(7 downto 0);
        o_data     : out std_logic_vector(7 downto 0)              
       );
 end component;
 
     signal clk       : std_logic;
     signal reset     : std_logic;
     signal trig      : std_logic;
     signal en        : std_logic;      
     signal datain    : std_logic_vector(7 downto 0);
     signal dataout   : std_logic_vector(7 downto 0);
     signal e : std_logic;
 
 begin
  dut: top_sbox_aes
    port map 
       (
        i_clock =>clk,  
        i_reset   =>reset,
        i_enable  =>en,
        i_trigger =>trig,   
        i_data   =>datain,  
        o_data   =>dataout
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
      trig<='0';
      wait for 200 ns;
      trig<='1';
      wait for 100 ns;
      trig<='0';
      wait for 800 ns;
      trig<='1';
      wait for 100 ns;
      trig<='0';
      wait for 1800 ns;
      trig<='1';
      wait for 100 ns;
      trig<='0';
      wait for 1800 ns;
      trig<='1';
      wait for 100 ns;
      trig<='0';
          
    
       wait;
           
 end process;
 
 process 
   begin    
      en<='0';
      wait for 100 ns;
      en<='1';
      wait for 80 ns;
      en<='0';
      wait for 400 ns;
      en<='1';
      wait for 100 ns; 
      en<='0';
      wait for 1400 ns;
      en<='1';
      wait for 100 ns;
      en<='0';
      wait for 2140 ns;
      en<='1';
      wait for 140 ns;
      en<='0';
      wait for 2140 ns;
      en<='1';
      wait for 140 ns;
      en<='0';
         
    
       wait;
           
 end process;   
     
     
     process 
   begin
   
      e <= '0';
      
      datain <= "00000000";  
      wait for 1100 ns;
      datain <= "11110000"; --F0, 240 
      wait for 2120 ns;
      datain <= "11111111"; --FF, 255  
      wait for 2100 ns;
      datain <= "00110011"; --33,51
      wait for 2100 ns;
      datain <= "10000001"; --81,129 
      wait for 2100 ns;
      e <= '1';
      wait;
 end process;
 
end;