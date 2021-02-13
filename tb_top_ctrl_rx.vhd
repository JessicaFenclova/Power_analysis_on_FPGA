library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_ctrl_rx is 
end;

architecture sim of tb_top_ctrl_rx is

 component top_ctrl_rx is 
  port (
         in_clk      : in std_logic;
         in_rst      : in std_logic;
         in_rd_ack   : in std_logic;
         in_data     : in std_logic;
         out_data    : out std_logic_vector(7 downto 0);
         out_rd_req  : out std_logic
         --out_error   : out std_logic 
  
    );
 end component;
 
     signal clk1    : std_logic;
     signal reset   : std_logic;
     signal rd_ack  : std_logic;
     signal i_data : std_logic;
     signal o_data : std_logic_vector(7 downto 0);
     signal rd_req : std_logic;
     --signal o_er    : std_logic;
     signal e       :std_logic;
     
 begin
  dut: top_ctrl_rx
    port map 
     (
      in_clk=>clk1,
      in_rst=>reset,
      in_rd_ack=>rd_ack,
      in_data=>i_data,
      out_data=>o_data,
      out_rd_req=>rd_req
      --out_error=>o_er
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
    
      if e = '1' then 
      wait;
      end if;     
 end process;
 
 
  process 
   begin
      rd_ack<='0';
      wait for 184320 ns;
      rd_ack<= '1';
      wait for 10100 ns;
      rd_ack<='0';
      wait for 193220 ns;
      rd_ack<= '1';
      wait;
 end process;

 
 process
   begin
 
      e <= '0';
      i_data <= '1';   --begin
      wait for 18620 ns;
      i_data <= '0';   --0
      wait for 17400 ns; 
      i_data <= '1';    --1
      wait for 17400 ns;
      i_data <= '1';    --2
      wait for 17400 ns;
      i_data <= '1';    --3
      wait for 17400 ns;
      i_data <= '1';    --4
      wait for 17400 ns;
      i_data <= '1';    --5
      wait for 17400 ns;
      i_data <= '1';     --6
      wait for 17400 ns;
      i_data <= '0';     --7
      wait for 17400 ns;
      i_data <= '0';     --8
      wait for 17400 ns;
      i_data <= '1';     --9
      wait for 52400 ns;
      i_data <= '0';   --0
      wait for 17400 ns; 
      i_data <= '1';    --1
      wait for 17400 ns;
      i_data <= '1';    --2
      wait for 17400 ns;
      i_data <= '0';    --3
      wait for 17400 ns;
      i_data <= '0';    --4
      wait for 17400 ns;
      i_data <= '1';    --5
      wait for 17400 ns;
      i_data <= '1';     --6
      wait for 17400 ns;
      i_data <= '0';     --7
      wait for 17400 ns;
      i_data <= '0';     --8
      wait for 17400 ns;
      i_data <= '1';     --9 
      wait for 6 ms; 
    
      e <= '1';
      wait;
    
 end process;
end;
 
 