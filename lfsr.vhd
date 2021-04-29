library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity lfsr is
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
  end lfsr;
  
  architecture rtl of lfsr is
  
     --signal bits_reg      : std_logic_vector(3 downto 0):="1111";
     signal out_lfsr      : std_logic_vector(7 downto 0):="11111111";
     signal in_lfsr       : std_logic_vector(7 downto 0):="11111111";
     --signal out_shift_xor : std_logic; 
     
     
  begin
  
   p_lfsr : process(in_clk, in_rst)
    begin
        if in_rst = '0' then
           --bits_reg<="0000";
           --in_lfsr <="11111111";
           --out_lfsr <="11111111";
           --o_gener_bits<="00000000";
                                     
        elsif in_clk'event and (in_clk='1') then
             
             out_lfsr<=in_lfsr;            
             

        end if;

  end process p_lfsr;
  
  p_lfsr_2 : process(i_gener_data, i_lsb_en, i_msb_en,i_param_bits, out_lfsr)
    begin
       if (i_gener_data='1') then
          in_lfsr<=out_lfsr;
          in_lfsr(0)<=((out_lfsr(0)) XOR (out_lfsr(2)) XOR (out_lfsr(3)) XOR (out_lfsr(4))); -- switch out with in
          in_lfsr(7 downto 1)<=out_lfsr(6 downto 0);                   
       --elsif (i_gener_data='0') then
       else
            if (i_lsb_en='1') then                
               in_lfsr(3 downto 0)<= i_param_bits(3 downto 0);
               in_lfsr(7 downto 4)<= out_lfsr(7 downto 4);        -- to make sure in_lfsr doesn't behave as a latch, all bits must be defined  , or  in_lfsr(7 downto 4)<= in_lfsr(7 downto 4) and "1111"
            elsif (i_msb_en='1') then
               in_lfsr(7 downto 4)<= i_param_bits(3 downto 0);
               in_lfsr(3 downto 0)<= out_lfsr(3 downto 0);
            else
               in_lfsr <=out_lfsr;
            end if;
       --else
          --in_lfsr <=out_lfsr;                   
       end if;     
   
  end process p_lfsr_2;
  
  
  o_gener_bits<= out_lfsr;


 end architecture rtl;