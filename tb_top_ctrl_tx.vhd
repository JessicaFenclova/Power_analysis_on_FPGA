library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_ctrl_tx is 
end;

architecture sim of tb_top_ctrl_tx is

 component top_ctrl_tx is 
  port (
         in_clock    : in std_logic;
        in_reset    : in std_logic;
        in_wr_req   : in std_logic;
        in_data     : in std_logic_vector(7 downto 0);
        out_data_tx : out std_logic;
        out_wr_ack  : out std_logic 
  
    );
 end component;
 
     signal clk1    : std_logic;
     signal reset   : std_logic;
     signal wr_req  : std_logic;
     signal i_data : std_logic_vector(7 downto 0);
     signal o_data : std_logic;
     signal wr_ack : std_logic;
     signal e       :std_logic;
     
 begin
  dut: top_ctrl_tx
    port map 
     (
      in_clock=>clk1,
      in_reset=>reset,
      in_wr_req=>wr_req,
      in_data=>i_data,
      out_data_tx=>o_data,
      out_wr_ack=>wr_ack
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
      wr_req<='0';
      wait for 20 ns;
      wr_req<= '1';
      wait for 60 ns;
      wr_req<='0';
      wait for 500 ns;

      --if e = '1' then 
      wait;
      --end if;
      
 end process;

 
 process
   begin
 
      e <= '0';
      i_data <= "11001100";   --begin
      wait for 140 ns;
      i_data <= "11111111";
    
      wait for 5 ms; 
    
      e <= '1';
      wait;
    
 end process;
end;
 
 