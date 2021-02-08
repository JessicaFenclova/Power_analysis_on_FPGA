library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_gen is
   generic (
            baudrate    : integer := 115200         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
            --over_sample : integer := 16
           );
   
   port (
       i_clkin     : in std_logic;
       i_res       : in std_logic;
       i_start_clk : in std_logic;
       --o_cnt_done  : out std_logic;
       o_clkout    : out std_logic 
       --clk_per_bits : out integer;
        );
        
end baud_gen;

architecture rtl of baud_gen is
        
        signal count:integer;
        --signal cnt_bits : integer :=0;
        signal start_en : std_logic;
        constant prescaler : integer := (50000000/(baudrate));
        
begin
    pro_1 : process (i_clkin, i_res)
    begin
      if i_res = '0' then
         count <= 1;                  -- 1 or 0, so that it counts to prescaler and the clk2 is correct
         --cnt_bits<=0;
         start_en <= '0';
         --o_cnt_done <= '0';
         o_clkout <= '0';
         
      elsif rising_edge(i_clkin) then   -- if (clk' event and clk='1') 
        if (i_start_clk='1') then     --i_start_clk' event and i_start_clk='1'
           start_en <='1';
        else
           --start_en<='0';
           count <= 1;
        end if;
         if (start_en='1') then
            count <= count + 1;     -- this might not work, then it would only increment if a start detection came, we want it to increment on its own after the start detection
         end if;
         if count = prescaler  then    --115200*16 so 1843200 to Rx divide 27 and 16 so 115200 
              o_clkout <='1';
              --cnt_bits<= cnt_bits+1;
            --if (cnt_bits=9) then
                --o_cnt_done<='1';
                --cnt_bits<=0;
            --else
                --o_cnt_done<='0';
            --end if;
              --temp <= not temp;   
         elsif count = prescaler+1 then 
              count <= 1;
              o_clkout <= '0';
              --o_cnt_done<='0';
              --temp <= not temp;                
         end if;   
      end if;
      
        --o_clkout <= temp;
            
    end process pro_1;
end;            