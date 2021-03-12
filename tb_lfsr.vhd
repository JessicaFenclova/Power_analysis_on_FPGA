library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_lfsr is 
end;

architecture sim of tb_lfsr is

 component lfsr is 
  port (
        in_clk       : in std_logic;
        in_rst       : in std_logic;
        i_gener_data : in std_logic;    -- from the state machine measure, -- input from the state machine for measruing that says generate data here in lfsr
        i_lsb_en     : in std_logic;
        i_msb_en     : in std_logic;
        i_param_bits : in std_logic_vector(4 downto 0);
        --i_lsb_bits  : in std_logic_vector(4 downto 0);   -- will be only one input with the 4 bits from the param reg for lsb or msb
        --i_msb_bits  : in std_logic_vector(4 downto 0);
        o_gener_bits : out std_logic_vector(7 downto 0)  
    );
    
 end component;
 
     signal clk        : std_logic;
     signal reset      : std_logic;
     signal gener_data : std_logic;      
     signal bits       : std_logic_vector(4 downto 0);
     signal lsb_en     : std_logic;
     signal msb_en     : std_logic;
     --signal lsbbits       : std_logic_vector(4 downto 0);
     --signal msbbits       : std_logic_vector(4 downto 0);
     signal gener_bits : std_logic_vector(7 downto 0);
     signal e : std_logic;

    
     
 begin
  dut: lfsr
    port map 
     (
      in_clk=>clk,
      in_rst=>reset,
      i_gener_data => gener_data,
      i_param_bits=>bits,
      --i_lsb_bits=>lsbbits,
      --i_msb_bits=>msbbits,
      i_lsb_en => lsb_en,
      i_msb_en => msb_en,
      o_gener_bits=> gener_bits
                
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
      lsb_en<='0';
      wait for 180 ns;
      lsb_en<= '1';
      wait for 400 ns;
      lsb_en<='0';
      wait;
 end process; 
 
 process 
   begin
      msb_en<='0';
      wait for 1420 ns;
      msb_en<='1';
      wait for 800 ns;
      msb_en<='0';
      
      wait;
 end process;
 
 process 
   begin
      gener_data<='0';
      wait for 2000 ns;
      gener_data<= '1';
      wait for 400 ns;
      gener_data<='0';
      wait;
 end process;  
 
 process
   begin
 
      e <= '0';
      bits<="00000";    --for the lsb
      wait for 180 ns;
      bits<= "01110";
      wait for 400 ns;
      bits<="00000";  -- for the msb
      wait for 840 ns;
      bits<= "10001";
      wait for 800 ns;
      bits<="00000";
      wait for 1800 ns;

    
     e <= '1';
    wait;
    
 end process;
 
 --process
   --begin
 
      --e <= '0';
      --lsbbits<="00000";    --for the lsb
      --wait for 180 ns;
      --lsbbits<= "01110";
      --wait for 400 ns;
      --lsbbits<="00000";
      --wait for 1800 ns;

    
     --e <= '1';
    --wait;
    
 --end process;
 
--process
   --begin 
      --msbbits<="00000";  -- for the msb
      --wait for 840 ns;
      --msbbits<= "10001";
      --wait for 800 ns;
      --msbbits<="00000";
      --wait for 1800 ns;
      
      --e <= '1';
    --wait;
    
 --end process;
end;
 
 