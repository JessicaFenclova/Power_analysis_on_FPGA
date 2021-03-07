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
        i_xor_result  : in std_logic_vector(7 downto 0);    --the sbox outputs put through xor, the state machine measure will use to tell the main state machine maybe the eval_result signal a 0 or 1, correct incorrect
        i_wr_ack      : in std_logic;
        o_rd_ack      : out std_logic; 
        o_wr_req      : out std_logic;
        o_param       : out std_logic_vector(4 downto 0); -- cmd tells if this will be the lsb or msb or param for enabling sboxes
        o_lsb_en      : out std_logic;
        o_msb_en      : out std_logic;
        o_en_sbox     : out std_logic; -- state machine sbox will enable the decoder to take param reg bits and decode them to know which sboxes to enable
        o_gener_data  : out std_logic; -- the state machine measure will let the lfsr know to generate new data or leave the data as they are
        o_trigger     : out std_logic; -- the state machine measure will set and reset this
        o_data        : out std_logic 
     );
    
 end component;
 
     signal clk        : std_logic;
     signal reset      : std_logic;
     signal rd_req     : std_logic;
     signal data       : std_logic_vector(7 downto 0);
     signal dataout    : std_logic;
     signal xorin_res  :  std_logic_vector(7 downto 0);
     signal wr_ack     :  std_logic;
     signal rd_ack     :  std_logic; 
     signal wr_req     :  std_logic;
     signal param      : std_logic_vector(4 downto 0);
     signal lsb_en     : std_logic;
     signal msb_en     : std_logic;
     signal en_sbox    : std_logic;
     signal gener_data : std_logic;
     signal trig       : std_logic;
     signal e : std_logic;

    
     
 begin
  dut: ctrl_aes
    port map 
     (
      i_clk=>clk,
      i_rst=>reset,
      i_rd_req=>rd_req,
      i_data=>data,
      i_xor_result=>xorin_res,
      i_wr_ack=>wr_ack,
      o_rd_ack=>rd_ack,
      o_wr_req=> wr_req,
      o_param=>param,
      o_lsb_en => lsb_en,
      o_msb_en => msb_en,
      o_en_sbox => en_sbox,
      o_gener_data => gener_data,
      o_trigger => trig,
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
      wait for 800 ns;
      rd_req<= '1';
      wait for 100 ns;
      rd_req<='0';
      wait for 1840 ns;
      rd_req<= '1';
      wait for 100 ns;
      rd_req<='0';
      wait for 1940 ns;
      rd_req<= '1';
      wait for 100 ns;
      rd_req<='0';
      wait;
 end process; 
 
 process 
   begin
      xorin_res<="11111111";
      wait for 840 ns;
      xorin_res<="00000000";
      wait for 100 ns;
      xorin_res<="00110011";
      wait for 2000 ns;
      
      wait;
 end process;
 
  process 
   begin
      wr_ack<='0';
      wait for 940 ns;
      wr_ack<= '1';
      wait for 100 ns;
      wr_ack<='0';
      wait for 1800 ns;
      wr_ack<= '1';
      wait for 100 ns;
      wr_ack<='0';
      wait for 1800 ns;
      wr_ack<= '1';
      wait for 100 ns;
      wr_ack<='0';
      wait for 2000 ns;
      wr_ack<= '1';
      wait for 100 ns;
      wr_ack<='0';
      wait;
 end process;  
 
 process
   begin
 
      e <= '0';
      data <= "00000000";   --begin , but the cmd 000 is for setting lsb
      wait for 1000 ns;
      data <= "11111010";   --cmd for enable sbox, the 3 bits from the end
      wait for 2000 ns;
      data <= "11111000";   --cmd for set lsb
      wait for 2000 ns;
      data <= "11111001";  -- cmd for set msb
      wait for 2000 ns;

    
     e <= '1';
    wait;
    
 end process;
end;
 
 