library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity lfsr is
  port (
        in_clk        : in std_logic;
        in_rst        : in std_logic;
        --i_sel_ctrl   : in std_logic_vector(1 downto 0);
        i_lsb_en    : in std_logic;
        i_msb_en      : in std_logic;
        i_lsb_bits  : in std_logic_vector(4 downto 0);
        i_msb_bits  : in std_logic_vector(4 downto 0);
        o_gener_bits : out std_logic_vector(7 downto 0)
       );
  end lfsr;
  
  architecture rtl of lfsr is
  
     signal bits_reg      : std_logic_vector(3 downto 0);
     signal out_lfsr      : std_logic_vector(7 downto 0);
     signal in_lfsr       : std_logic_vector(7 downto 0);
     signal out_shift_xor : std_logic; 
     
  begin
  
   p_lfsr : process(in_clk, in_rst)
    begin
        if in_rst = '0' then
           bits_reg<="0000";
           in_lfsr <="00000000";
           out_lfsr <="00000000";
           o_gener_bits<="00000000";
           out_shift_xor<='0';
        elsif in_clk'event and (in_clk='1') then
            --out_lfsr  -- using for to go bit by bit and xor them, depending on the polynom, chosen bits
            if(i_lsb_en='1') then
               bits_reg<= i_lsb_bits(3 downto 0);
               in_lfsr(3 downto 0)<= bits_reg;
            elsif (i_msb_en='1') then
               bits_reg<= i_msb_bits(3 downto 0);
               in_lfsr(7 downto 4)<=bits_reg;
            else
               in_lfsr<=out_lfsr;
            
            end if;
            out_shift_xor<=((in_lfsr(0)) XOR (in_lfsr(2)) XOR (in_lfsr(3)) XOR (in_lfsr(4)));
            out_lfsr(0)<=out_shift_xor;
            out_lfsr(7 downto 1)<=in_lfsr(6 downto 0);
            
            --in_lfsr<= in_lfsr(7 downto 1) & out_shift_xor;
            o_gener_bits<= in_lfsr;
        end if;
  end process p_lfsr;


 end architecture rtl;