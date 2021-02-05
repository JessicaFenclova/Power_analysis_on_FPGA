library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity rx_sampling is
 
 generic (
            baudrate    : integer := 115200         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
            --over_sample : integer := 16
         );
           
  port (
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_data_rx   : in std_logic;
        o_start_bit : out std_logic;
        o_edge      : out std_logic;      --only for checking
        o_cnt       : out std_logic_vector(3 downto 0);  --only for checking
        o_encnt     : out std_logic       --only for checking
       );
 end rx_sampling;
 
 architecture rtl of rx_sampling is
 
        signal      cnt_samp : integer := 0;
        signal count_bits    : integer := 0;
        signal not_start     : std_logic := '0';
        constant sample_freq : integer := (500000/(baudrate/2)); --we want to sample the middle of the bit, clk1 fpga 50 000 000 for simulation make slower depending on testbench clk timing
        signal enable_cnt    : std_logic := '0';
        signal i_data_delay  : std_logic :='0';      --for falling edge detection
        signal d_edge        : std_logic :='0';
        
       
  begin
  
    p_sampling: process(i_clk, i_rst)
      begin
        if i_rst = '0' then
          o_start_bit <='0';
          cnt_samp   <=0;
          enable_cnt <='0';
          d_edge<='0';
          count_bits<=0;
          not_start<='0';
          o_edge <='0';  --only for checking
          o_cnt <="0000";   --only for checking
          o_encnt <='0';      --only for checking
          
        elsif i_clk'event and (i_clk='1') then
        --checking for the falling edge  
        
             d_edge <= (not i_data_rx) and i_data_delay;
             i_data_delay <= i_data_rx; 
                    
           if(d_edge='1') and (cnt_samp=0) then
             if(count_bits>0) then
                not_start<='1';
             end if; 
              enable_cnt <='1';
              d_edge<='0';
           end if;
           
           if (enable_cnt= '1') then      
              cnt_samp <= cnt_samp +1;
           end if;
           
           if (cnt_samp=sample_freq) then
              count_bits<= count_bits+1;
             if (i_data_rx='0') and (not_start='0') then
              o_start_bit <= '1';
              --cnt_samp <=0;
              --enable_cnt <='0';    
             end if;                    
              
           end if;
           
            if (cnt_samp=(sample_freq+1)) then
                 o_start_bit <='0';
                 enable_cnt <='0';
                 cnt_samp <=0; 
               if (count_bits=9) then
                  count_bits<=0;
               end if;
             end if;  
          
             
               
          
          o_edge <= d_edge;          --only for checking
          o_cnt <= std_logic_vector(to_unsigned(cnt_samp,o_cnt'length));       --only for checking
          o_encnt <= enable_cnt;                                              --only for checking
        end if;
    end process p_sampling;
    
        
 end architecture rtl;