library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ctrl_rx is 
end;

architecture sim of tb_ctrl_rx is

 component ctrl_rx is 
  port (
    i_clk1      : in std_logic;
    i_clk2      : in std_logic;
    i_rst       : in std_logic;
    i_rd_ack    : in std_logic;
    i_start     : in std_logic;
    --i_stop      : in std_logic;
    i_data      : in std_logic;
    o_data      : out std_logic_vector(7 downto 0);
    o_rd_req    : out std_logic
    --o_error     : out std_logic
    --o_cnt       : out std_logic_vector(3 downto 0) -- only for checking
    --o_cnt_slow      : out std_logic_vector(3 downto 0) -- only for checking  
  
    );
 end component;
 
     signal clk1    : std_logic;
     signal clk2    : std_logic;
     signal reset   : std_logic;
     signal rd_ack  : std_logic;
     signal start   : std_logic;
     --signal stop   : std_logic;
     signal in_data : std_logic;
     signal out_data : std_logic_vector(7 downto 0);
     signal rd_req : std_logic;
     --signal o_er    : std_logic;
     --signal cnt   :  std_logic_vector(3 downto 0);
     --signal cnt_slow   :  std_logic_vector(3 downto 0);
     --signal e       :std_logic;
     
 begin
  dut: ctrl_rx
    port map 
     (
      i_clk1=>clk1,
      i_clk2=>clk2,
      i_rst=>reset,
      i_rd_ack=>rd_ack,
      i_start=>start,
      --i_stop=>stop,
      i_data=>in_data,
      o_data=>out_data,
      o_rd_req=>rd_req
      --o_error=>o_er
      --o_cnt => cnt
      --o_cnt_slow => cnt_slow          
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
      clk1<='0';
      wait for 20 ns;
      clk1<='1';
      wait for 20 ns;    
    
      --if e = '1' then 
      --wait;
      --end if;     
 end process;
 
  process 
   begin    
      clk2<='0';
      wait for 180 ns;
      clk2<='1';
      wait for 40 ns;    
    
      --if e = '1' then 
      --wait;
      --end if;     
 end process;
 
  process 
   begin
      rd_ack<='0';
      wait for 2400 ns;
      --rd_ack<= '1';
      --wait for 120 ns;
      --rd_ack<='0';
      --wait for 800 ns;
      rd_ack<= '1';
      wait for 400 ns;
      rd_ack<='0';
      --wait for 1780 ns;
      --rd_ack<= '1';
      wait;
 end process;
 
  process 
   begin
      start<='0';
      wait for 175 ns;
      start<= '1';
      wait for 40 ns;
      start<='0';
      wait for 8840 ns;
      start<= '1';
      wait for 40 ns;
      --start<='0';
      --wait;
 end process;
 
  
 
 process
   begin
 
      --e <= '0';
      in_data <= '1';   --begin
      wait for 170 ns;
      in_data <= '0';   --0
      wait for 220 ns; 
      in_data <= '1';    --1
      wait for 220 ns;
      in_data <= '1';    --2
      wait for 220 ns;
      in_data <= '1';    --3
      wait for 220 ns;
      in_data <= '1';    --4
      wait for 220 ns;
      in_data <= '1';    --5
      wait for 220 ns;
      in_data <= '1';     --6
      wait for 220 ns;
      in_data <= '0';     --7
      wait for 220 ns;
      in_data <= '0';     --8
      wait for 220 ns;
      in_data <= '1';     --9
      wait for 8040 ns;
      --in_data <= '0';   --0
      --wait for 80 ns; 
      --in_data <= '1';    --1
      --wait for 100 ns;
      --in_data <= '1';    --2
      --wait for 100 ns;
      --in_data <= '0';    --3
      --wait for 100 ns;
      --in_data <= '0';    --4
      --wait for 100 ns;
      --in_data <= '1';    --5
      --wait for 100 ns;
      --in_data <= '1';     --6
      --wait for 100 ns;
      --in_data <= '0';     --7
      --wait for 100 ns;
      --in_data <= '0';     --8
      --wait for 100 ns;
      --in_data <= '1';     --9 
      --wait for 8 ms; 
    
      --e <= '1';
      --wait;
    
 end process;
end;
 
 