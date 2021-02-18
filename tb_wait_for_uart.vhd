library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_wait_for_uart is 
end;

architecture sim of tb_wait_for_uart is

 component wait_for_uart is 
  port (
    i_clk       : in std_logic;
    i_rst       : in std_logic;
    i_rd_req    : in std_logic;
    i_data      : in std_logic;
    --o_rd_ack    : out std_logic; -- do i want another signal out ready
    o_data      : out std_logic  
    );
    
 end component;
 
     signal clk    : std_logic;
     signal reset    : std_logic;
     signal rd_req   : std_logic;
     signal data  : std_logic;
     signal dataout   : std_logic;
    
     
 begin
  dut: wait_for_uart
    port map 
     (
      i_clk=>clk,
      i_rst=>reset,
      i_rd_req=>rd_req,
      i_data=>data,
      o_data=> dataout
                
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
    
      --if e = '1' then 
      --wait;
      --end if;     
 end process;
 
 
  process 
   begin
      rd_req<='0';
      wait for 400 ns;
      rd_req<= '1';
      wait for 2400 ns;
      rd_req<='0';
      wait;
 end process;
  
 
 process
   begin
 
      --e <= '0';
      data <= '1';   --begin
      wait for 170 ns;
      data <= '0';   --0
      wait for 220 ns; 
      data <= '1';    --1
      wait for 220 ns;
      data <= '1';    --2
      wait for 220 ns;
      data <= '1';    --3
      wait for 220 ns;
      data <= '1';    --4
      wait for 220 ns;
      data <= '1';    --5
      wait for 220 ns;
      data <= '1';     --6
      wait for 220 ns;
      data <= '0';     --7
      wait for 220 ns;
      data <= '0';     --8
      wait for 220 ns;
      data <= '1';     --9
      wait for 8040 ns;

    
      --e <= '1';
      --wait;
    
 end process;
end;
 
 