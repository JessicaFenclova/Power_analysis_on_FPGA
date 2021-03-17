library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_ctrl_aes is 
end;

architecture sim of tb_top_ctrl_aes is

 component top_ctrl_aes is 
  port (
         in_clk_aes    : in std_logic;
         in_rst_aes    : in std_logic;
         in_read_req   : in std_logic;
         in_write_ack  : in std_logic;
         in_data_aes   : in std_logic_vector(7 downto 0);
         in_data_sbox  : in std_logic_vector(7 downto 0);
         out_write_req : out std_logic;
         out_read_ack  : out std_logic;
         out_trigger   : out std_logic;
         out_bits_sbox : out std_logic_vector(7 downto 0);
         out_data_aes  : out std_logic           
  
       );
    
 end component;
 
     signal clk       : std_logic;
     signal reset     : std_logic;
     signal readreq   : std_logic;
     signal writeack  : std_logic;
     signal readack   : std_logic;
     signal writereq  : std_logic;
     signal trig      : std_logic;
     signal data_out  : std_logic;      
     signal dataaes   : std_logic_vector(7 downto 0);
     signal datasbox  : std_logic_vector(7 downto 0);
     signal gener_bits: std_logic_vector(7 downto 0);
     signal e : std_logic;

    
     
 begin
  dut: top_ctrl_aes
    port map 
     (
      in_clk_aes    => clk,  
      in_rst_aes    => reset,   
      in_read_req   => readreq,  
      in_write_ack  => writeack,  
      in_data_aes   => dataaes, 
      in_data_sbox  => datasbox, 
      out_write_req => writereq, 
      out_read_ack  => readack, 
      out_trigger   => trig,
      out_bits_sbox => gener_bits,
      out_data_aes  => data_out
                
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
      readreq<='0';
      wait for 180 ns;
      readreq<= '1';
      wait for 100 ns;
      readreq<='0';
      wait for 800 ns;
      readreq<= '1';
      wait for 100 ns;
      readreq<='0';
      wait for 1840 ns;
      readreq<= '1';
      wait for 100 ns;
      readreq<='0';
      wait for 1940 ns;
      readreq<= '1';
      wait for 100 ns;
      readreq<='0';
      wait for 1940 ns;
      readreq<= '1';
      wait for 100 ns;
      wait;
 end process;
 
 process 
   begin
      writeack<='0';
      wait for 940 ns;
      writeack<= '1';
      wait for 100 ns;
      writeack<='0';
      wait for 1800 ns;
      writeack<= '1';
      wait for 100 ns;
      writeack<='0';
      wait for 1800 ns;
      writeack<= '1';
      wait for 100 ns;
      writeack<='0';
      wait for 2000 ns;
      writeack<= '1';
      wait for 100 ns;
      writeack<='0';
      wait;
 end process;
 
 
  process 
   begin
      datasbox <= "00000000";  
      wait for 1100 ns;
      datasbox <= "11110000";  
      wait for 2120 ns;
      datasbox <= "11111111";   
      wait for 2100 ns;
      datasbox <= "00110011"; 
      wait for 2100 ns;
      datasbox <= "10000001";  
      wait for 2100 ns;
      wait;
 end process; 
 
 process 
   begin
      e <= '0';
      
      dataaes <= "00000000";   --begin , but the cmd 000 is for setting lsb
      wait for 1000 ns;
      dataaes <= "11111010";   --cmd for enable sbox, the 3 bits from the end
      wait for 2000 ns;
      dataaes <= "11111000";   --cmd for set lsb
      wait for 2000 ns;
      dataaes <= "11111001";  -- cmd for set msb
      wait for 2000 ns;
      dataaes <= "10000011";  -- cmd for starting the measuring 011
      wait for 2000 ns;
      --dataaes <= "10000011";  -- cmd for starting the measuring 011
      --wait for 2000 ns;
      
      
      e <= '1';
      wait;
      
 end process;
 
    
 
end;
 
 