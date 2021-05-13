library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_uart_aes is 
end;

architecture sim of tb_top_uart_aes is


 component top_uart_aes is
  port (
         in_clk_uart      : in std_logic;
         in_rst_uart      : in std_logic;
         in_read_ack      : in std_logic;
         in_write_req     : in std_logic;
         in_data_uart     : in std_logic;
         in_aes           : in std_logic_vector(7 downto 0);     -- in from ctrl aes
         out_aes          : out std_logic_vector(7 downto 0);    -- out to ctrl aes
         out_write_ack    : out std_logic;
         out_data_uart    : out std_logic;
         out_read_req     : out std_logic           
  
       );
 end component;
 
     signal clk       : std_logic;
     signal reset     : std_logic;
     signal ack_rd      : std_logic;
     signal req_wr  : std_logic;      
     signal datain    : std_logic;
     signal aesin    : std_logic_vector(7 downto 0);
     signal aesout    : std_logic_vector(7 downto 0);
     signal ack_wr    : std_logic;
     signal dataout    : std_logic;
     signal req_rd    : std_logic;
     signal e : std_logic;
     
     
  begin
  dut: top_uart_aes
    port map 
     (
      in_clk_uart   => clk,  
      in_rst_uart   => reset,     
      in_read_ack   => ack_rd,  
      in_write_req  => req_wr,
      in_data_uart  => datain,
      in_aes        => aesin,
      out_aes       => aesout,
      out_write_ack => ack_wr,
      out_data_uart => dataout,
      out_read_req  => req_rd
                
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
      ack_rd<='0';
      wait for 184320 ns;
      ack_rd<= '1';
      wait for 10100 ns;
      ack_rd<='0';
      wait for 193220 ns;
      ack_rd<= '1';
      wait;
 end process;
 
 process 
   begin
      req_wr<='0';
      wait for 185320 ns;
      req_wr<= '1';
      wait for 10200 ns;
      req_wr<='0';
      wait for 193320 ns;
      req_wr<= '1';
      wait;
 end process;
 
  process 
   begin    
      aesin<="11111111";
      wait for 17400 ns;
      aesin<="00000000";
      wait for 17400 ns;
      aesin<="11111111";
      wait for 17400 ns;
      aesin<="00000000";
      wait for 17400 ns;
          
    
           
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
 
