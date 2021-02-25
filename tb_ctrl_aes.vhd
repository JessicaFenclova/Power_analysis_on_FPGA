library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ctrl_aes is 
end;

architecture sim of tb_ctrl_aes is

 component ctrl_aes is 
  port (
    i_clk         : in std_logic;
    i_rst         : in std_logic;
    i_rd_req      : in std_logic;
    i_data        : in std_logic_vector(7 downto 0);
    i_cmd_done    : in std_logic;
    i_eval_result : in std_logic_vector(7 downto 0);
    i_wr_ack      : in std_logic;
    o_rd_ack      : out std_logic; 
    o_start_cmd   : out std_logic;
    o_cmd_reg     : out std_logic_vector(2 downto 0);
    o_param_reg   : out std_logic_vector(4 downto 0);
    o_wr_req      : out std_logic;
    o_data        : out std_logic_vector(7 downto 0)  
    );
    
 end component;
 
     signal clk    : std_logic;
     signal reset    : std_logic;
     signal rd_req   : std_logic;
     signal data  : std_logic_vector(7 downto 0);
     signal dataout   : std_logic_vector(7 downto 0);
     --signal start   : std_logic;
     signal cmd_done    :  std_logic;
     signal ev_result :  std_logic_vector(7 downto 0);
     signal wr_ack      :  std_logic;
     signal rd_ack      :  std_logic; 
     signal start_cmd   : std_logic;
     signal cmd_reg     : std_logic_vector(2 downto 0);
     signal param_reg   :  std_logic_vector(4 downto 0);
     signal wr_req      :  std_logic;
     signal e : std_logic;

    
     
 begin
  dut: ctrl_aes
    port map 
     (
      i_clk=>clk,
      i_rst=>reset,
      i_rd_req=>rd_req,
      i_data=>data,
      i_cmd_done=>cmd_done,
      i_eval_result=>ev_result,
      i_wr_ack=>wr_ack,
      o_rd_ack=>rd_ack,
      o_start_cmd=> start_cmd,
      o_cmd_reg=> cmd_reg,
      o_param_reg=> param_reg,
      o_wr_req=> wr_req,
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
    
      if e = '1' then 
       wait;
      end if;     
 end process;
 
 
  process 
   begin
      rd_req<='0';
      wait for 180 ns;
      rd_req<= '1';
      wait for 100 ns;
      rd_req<='0';
      wait;
 end process;
 
 process 
   begin
      cmd_done<='0';
      wait for 8800 ns;
      cmd_done<= '1';
      wait for 400 ns;
      cmd_done<='0';
      wait;
 end process; 
 
 process 
   begin
      ev_result<="00000000";
      wait for 3800 ns;
      ev_result<="00000011";
      wait for 4000 ns;
    
      wait;
 end process;
 
  process 
   begin
      wr_ack<='0';
      wait for 4600 ns;
      wr_ack<= '1';
      wait for 600 ns;
      wr_ack<='0';
      wait;
 end process;  
 
 process
   begin
 
      e <= '0';
      data <= "00000000";   --begin
      wait for 4840 ns;
      data <= "11001100";   --begin
      wait for 4840 ns;

    
     e <= '1';
    wait;
    
 end process;
end;
 
 