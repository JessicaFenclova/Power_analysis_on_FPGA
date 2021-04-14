library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_reg_sbox is 
end;

architecture sim of tb_reg_sbox is

 component reg_sbox is 
  port (
        input_CLK     : in std_logic;
        input_RESTART : in std_logic;
        input_ENABLE  : in std_logic;
        input_TRIG    : in std_logic;
        input_IN      : in std_logic_vector(7 downto 0); 
        output_Q      : out std_logic_vector(7 downto 0)
       );
    
 end component;
 
     signal clk       : std_logic;
     signal reset     : std_logic;
     signal trig      : std_logic;
     signal en      : std_logic;
     signal data_out  : std_logic_vector(7 downto 0);      
     signal datain    : std_logic_vector(7 downto 0);
     signal e : std_logic;

    
     
 begin
  dut: reg_sbox
    port map 
     (
      input_CLK  => clk,  
      input_RESTART => reset,
        input_ENABLE =>en, 
        input_TRIG => trig,   
        input_IN =>datain,      
        output_Q =>data_out
                
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
      wait for 80 ns;
      trig<='1';
      wait for 80 ns;
      trig<='0';
      wait for 80 ns;
      trig<='1';
      wait for 80 ns;
      trig<='0';
      wait for 80 ns;
      trig<='1';
      wait for 80 ns;    
    
       wait;
           
 end process;
 
 process 
   begin    
      en<='0';
      wait for 80 ns;
      en<='1';
      wait for 80 ns;
      en<='0';
      wait for 40 ns;
      en<='1';
      wait for 40 ns;    
    
       wait;
           
 end process;
 
  process 
   begin
   e <= '0';
      datain <= "00000000";  
      wait for 500 ns;
      datain <= "11110000";  
      wait for 600 ns;
      datain <= "11111111";   
      wait for 600 ns;
      datain <= "00110011"; 
      wait for 600 ns;
      datain <= "10000001";  
      wait for 600 ns;
      datain <= "11110000";  
      wait for 600 ns;
      datain <= "11111111";
      wait for 600 ns;
      datain <= "00000000";
      wait for 600 ns;
      e <= '1';  
      
      wait;
 end process;
 
 end;