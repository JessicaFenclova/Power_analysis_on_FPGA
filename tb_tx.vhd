library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_tx is 
end;

architecture sim of tb_tx is

component tx is      
   port (
    i_clk      : in std_logic;
    i_rst      : in std_logic;
    i_rd_ack   : in std_logic;
    i_cnt      : in std_logic_vector(3 downto 0);
    o_rd_req   : out std_logic;
    o_en       : out std_logic  
    
    );
 end component;
 
     signal clk     : std_logic;
     signal reset   : std_logic;
     signal rd_req  : std_logic;
     signal cnt     : std_logic_vector(3 downto 0);
     signal rd_ack  : std_logic;
     signal en      : std_logic;
     signal e:std_logic;
     
     
 begin
  dut: tx
    port map 
     (
      i_clk=>clk,
      i_rst=>reset,
      o_rd_req=>rd_req,
      i_cnt=> cnt,
      i_rd_ack => rd_ack,
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
    rd_ack<='0';
    wait for 20 ns;
    rd_ack<= '1';
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