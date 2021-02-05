library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ctrl_tx is 
end;

architecture sim of tb_ctrl_tx is

 component ctrl_tx is 
  port (
     i_clk1     : in std_logic;
     i_clk2     : in std_logic;
     i_rst      : in std_logic;
     i_wr_req   : in std_logic;
     i_data_tx  : in std_logic_vector(7 downto 0);
     o_wr_ack   : out std_logic;
     --o_start_tx : out std_logic;
     --o_stop_tx  : out std_logic;
     o_data_tx  : out std_logic  
    );
 end component;
 
     signal clk1    : std_logic;
     signal clk2    : std_logic;
     signal reset   : std_logic;
     signal wr_req  : std_logic;
     signal wr_ack  : std_logic;
     --signal start   : std_logic;
     --signal stop    : std_logic;
     signal in_data : std_logic_vector(7 downto 0);
     signal o_data  : std_logic;
     signal e       : std_logic;
     --signal s       : std_logic:='1';
     
     
 begin
  dut: ctrl_tx
    port map 
     (
      i_clk1=>clk1,
      i_clk2=>clk2,
      i_rst=>reset,
      i_wr_req=>wr_req,
      i_data_tx=>in_data,
      o_wr_ack=>wr_ack,
      --o_start_tx=>start,
      --o_stop_tx=>stop,
      o_data_tx => o_data          
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
      wr_req<='0';
      wait for 300 ns;
      --s <='0';
      wr_req<= '1';
      wait for 40  ns;
      wr_req<='0';
      wait for 1120 ns;
      --s <='0';
      wr_req<= '1';
      wait for 40  ns;
      wr_req<='0';
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
     --wait until start='1'; -- wait until or wait on  
     --if(start='1') then
     --if s ='1' then
     --wait for 100 ns;
     --end if; 
      clk2<='0';
      wait for 80 ns;
      clk2<='1';
      wait for 80 ns;
          
    
      if e = '1' then 
      wait;
      end if;
     --end if;    
 end process;
 
 process
   begin
 
      e <= '0';
      in_data <= "11111111";  
      wait for 300 ns;
      in_data <= "11001100";  
      wait for 300 ns;
      --in_data <= "11111111";  
      --wait for 600 ns;
      in_data <= "11111100";
      wait for 1800 ns; 
    
      e <= '1';
      wait;
    
 end process;
 
 
 
 end;