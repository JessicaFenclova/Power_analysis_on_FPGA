library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity rx_sampling is
 
 generic (
            baudrate    : integer := 115200         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
         );
           
  port (
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_data_rx   : in std_logic;
        o_start_bit : out std_logic
       );
 end rx_sampling;
 
 architecture rtl of rx_sampling is
 
        constant sample_freq : integer := (500000/(baudrate/2)); --we want to sample the middle of the bit, clk1 fpga 50 000 000 for simulation make slower depending on testbench clk timing
        
        signal cnt_samp : integer := sample_freq + 1;
        signal i_data_delay : std_logic := '0';

  begin
  
    p_sampling: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
          o_start_bit <='0';
          cnt_samp   <= sample_freq + 1;
        elsif i_clk'event and (i_clk='1') then
        
           i_data_delay <= i_data_rx;      
           if (i_data_rx = '0') and (i_data_delay = '1') then
              -- edge detected
              cnt_samp <= 0;
           else
               if (cnt_samp > sample_freq) then
                   -- do nothing
                   cnt_samp <= cnt_samp;
                 
                   o_start_bit <= '0';
               elsif (cnt_samp=sample_freq) then
                   -- detected
                   if (i_data_rx = '0') then
                       o_start_bit <= '1';
                   else
                       -- error
                   end if;
                   cnt_samp <= cnt_samp + 1;
               else
                   cnt_samp <= cnt_samp + 1;
               end if; 
            end if;
        end if;
    end process p_sampling;
    
        
 end architecture rtl;
