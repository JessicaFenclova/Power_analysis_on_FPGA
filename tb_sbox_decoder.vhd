library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sbox_decoder is 
end;

architecture sim of tb_sbox_decoder is

 component sbox_decoder is 
  port (
        i_clock    : in std_logic;
        i_reset    : in std_logic;
        i_enable   : in std_logic;    
        i_param    : in std_logic_vector(4 downto 0);
        o_en_sbox  : out std_logic_vector(31 downto 0) --32 optional sboxes, param 5 bits 2^5 -> 32   
    );
    
 end component;
 
     signal clk        : std_logic;
     signal reset      : std_logic;
     signal enable     : std_logic;      
     signal param      : std_logic_vector(4 downto 0);
     signal en_sbox    : std_logic_vector(31 downto 0);
     signal e : std_logic;

    
     
 begin
  dut: sbox_decoder
    port map 
     (
      i_clock=>clk,
      i_reset=>reset,
      i_enable => enable,
      i_param=>param,
      o_en_sbox=> en_sbox
                
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
      enable<='0';
      wait for 100 ns;
      enable<= '1';
      wait for 2800 ns;
      enable<='0';
      wait;
 end process; 
 
 process 
   begin
      e <= '0';
      param<="00001";
      wait for 400 ns;
      param<="00010";
      wait for 400 ns;
      param<="00011";
      wait for 400 ns;
      param<="00100";
      wait for 400 ns;
      param<="00111";
      wait for 400 ns;
      param<="00101";
      wait for 400 ns;
      param<="01000";
      wait for 400 ns;
      param<="01001";
      wait for 400 ns;
      param<="01111";
      wait for 400 ns;
      param<="11111";
      
      e <= '1';
      wait;
      
 end process;
 
    
 
end;
 
 