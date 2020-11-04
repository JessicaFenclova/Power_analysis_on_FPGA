library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rx is 
end;

architecture sim of tb_rx is

component rx is      
   port (
    i_clk      : in std_logic;
    i_rst      : in std_logic;
    i_wr_req   : in std_logic;
    i_dete_str : in std_logic;
    i_cnt      : in std_logic_vector(3 downto 0);
    o_wr_ack   : out std_logic;
    o_en       : out std_logic  
    
    );
 end component;
 
     signal clk     : std_logic;
     signal reset   : std_logic;
     signal wr_req  : std_logic;
     signal start   : std_logic;
     signal cnt     : std_logic_vector(3 downto 0);
     signal wr_ack  : std_logic;
     signal en      : std_logic;
     signal e:std_logic;
     
     
 begin
  dut: rx
    port map 
     (
      i_clk=>clk,
      i_rst=>reset,
      i_wr_req=>wr_req,
      i_dete_str=>start,
      i_cnt=> cnt,
      o_wr_ack => wr_ack,
      o_en => en
      
  
    
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
    wait for 20 ns;
    wr_req<= '1';
    wait;
 end process;
 
 process 
  begin
    start<='0';
    wait for 20 ns;
    start<= '1';
    wait;
 end process;
 
 process 
  begin    
    clk<='0';
    wait for 10 ns;
    clk<='1';
    wait for 10 ns;    
    
    if e = '1' then 
    wait;
    end if;
    
    
     
 end process;
 
 process
  begin
 
    e <= '0';
    cnt <= "0001";   -- nez zacne takze na vystup same 0
    wait for 40 ns; 
    cnt <= "0010";   -- nez zacne takze na vystup same 0
    wait for 40 ns;
    cnt <= "0011";   -- nez zacne takze na vystup same 0
    wait for 40 ns;
    cnt <= "0100";   -- nez zacne takze na vystup same 0
    wait for 40 ns;
    cnt <= "0101";   -- nez zacne takze na vystup same 0
    wait for 40 ns;
    cnt <= "0110";   -- nez zacne takze na vystup same 0
    wait for 40 ns;
    cnt <= "0111";   -- nez zacne takze na vystup same 0
    wait for 40 ns;
    cnt <= "1000";   -- nez zacne takze na vystup same 0
    wait for 40 ns;  
    
    e <= '1';
    wait;
    
 end process;
end;