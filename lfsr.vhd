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
  
     signal bits_reg      : std_logic_vector(3 downto 0);
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
           --out_shift_xor<='0';                          
        elsif in_clk'event and (in_clk='1') then
             --o_gener_bits<= out_lfsr;
             out_lfsr<=in_lfsr;
            --if (i_gener_data='1') then
               --in_lfsr<= in_lfsr; -- in_lfsr<= out_lfsr, in_lfsr<=in_lfsr, o_gener_bits <= in_lfsr
               --in_lfsr<=out_lfsr;
               --out_shift_xor<=((in_lfsr(0)) XOR (in_lfsr(2)) XOR (in_lfsr(3)) XOR (in_lfsr(4)));
               --out_lfsr(0)<=out_shift_xor;
               --out_lfsr(7 downto 1)<=in_lfsr(6 downto 0);
            --elsif (i_gener_data='0') then
               --if (i_lsb_en='1') then           --(i_gener_data='0') and
                  --bits_reg<= i_param_bits(3 downto 0);
                  --in_lfsr(3 downto 0)<= bits_reg;        --bits_reg
                  
                  --out_lfsr<=in_lfsr;
               --elsif (i_msb_en='1') then       --(i_gener_data='0')  and 
                   --bits_reg<= i_param_bits(3 downto 0);
                   --in_lfsr(7 downto 4)<=bits_reg;        --bits_reg
                   
                   --out_lfsr<=in_lfsr;

               --end if;
               
            --end if;

        end if;

  end process p_lfsr;
  
  p_lfsr_2 : process(i_gener_data, i_lsb_en, i_msb_en)
    begin
       if (i_gener_data='1') then
          in_lfsr(0)<=((out_lfsr(0)) XOR (out_lfsr(2)) XOR (out_lfsr(3)) XOR (out_lfsr(4))); -- switch out with in
          in_lfsr(7 downto 1)<=out_lfsr(6 downto 0);
          --in_lfsr<=out_lfsr;         
       --elsif (i_gener_data='0') then
            --if (i_lsb_en='1') then 
               --bits_reg<= i_param_bits(3 downto 0);
               --in_lfsr(3 downto 0)<= bits_reg;
            --elsif (i_msb_en='1') then 
               --bits_reg<= i_param_bits(3 downto 0);
               --in_lfsr(7 downto 4)<=bits_reg;
            --end if;       
       end if;
       if (i_lsb_en='1') then 
               bits_reg<= i_param_bits(3 downto 0);
               in_lfsr(3 downto 0)<= bits_reg;
               --out_lfsr<=in_lfsr;
       elsif (i_msb_en='1') then 
               bits_reg<= i_param_bits(3 downto 0);
               in_lfsr(7 downto 4)<=bits_reg;
               --out_lfsr<=in_lfsr;
       end if;
  end process p_lfsr_2;
  
  
  o_gener_bits<= out_lfsr;


 end architecture rtl;