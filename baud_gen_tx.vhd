library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_gen_tx is
   generic (
            baudrate    : integer := 115200         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
            --over_sample : integer := 16
           );
   
   port (
       i_clkin     : in std_logic;
       i_res       : in std_logic;
       i_start_clk : in std_logic;  -- misto start a stop staci jeden signal pro enable disable baud gen
       --i_stop_clk  : in std_logic;
       o_clkout    : out std_logic 
       --clk_per_bits : out integer;
        );
        
end baud_gen_tx;

architecture rtl of baud_gen_tx is
        
        --signal start_en : std_logic;
        signal count : integer;
        constant prescaler : integer := (500000/(baudrate));
        
begin
    pro_1 : process (i_clkin, i_res)
    begin
      if i_res = '0' then
         --start_en <= '0';
         o_clkout <= '0';
         count<=1;
         
      elsif rising_edge(i_clkin) then
         if (i_start_clk='1') then
            count <= count + 1;     
         end if;
         if count = prescaler  then    
              o_clkout <='1';
              --temp <= not temp;   
         elsif count = prescaler+1 then 
              count <= 1;
              o_clkout <= '0';
              --temp <= not temp;                
         end if; 
             
        
           --start_en <='1';
        --elsif (i_start_clk='0') then
           --start_en<='0';
        --end if;
        --if (start_en='1') then
            --count <= count + 1;     
        --end if;
        --if count = prescaler  then    
              --o_clkout <='1';
              --temp <= not temp;   
           --elsif count = prescaler+1 then 
              --count <= 1;
              --o_clkout <= '0';
              --temp <= not temp;                
           --end if; 
             
      end if;
      
        --o_clkout <= temp;
            
    end process pro_1;
end;