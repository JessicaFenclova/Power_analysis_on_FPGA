library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_ctrl_tx is
  port (
        in_clock    : in std_logic;
        in_reset    : in std_logic;
        in_wr_req   : in std_logic;
        in_data     : in std_logic_vector(7 downto 0);
        out_data_tx : out std_logic;
        out_wr_ack  : out std_logic  
      );
 end top_ctrl_tx;
 
architecture rtl of top_ctrl_tx is
 
 component ctrl_tx is -- names are mixed up this tx should be rx and vice versa  
                        
    port
        (
          i_clk1     : in std_logic;
          i_clk2     : in std_logic;
          i_rst      : in std_logic;
          i_wr_req   : in std_logic;
          i_data_tx  : in std_logic_vector(7 downto 0);
          o_wr_ack   : out std_logic;
          --o_start_tx : out std_logic;
          --o_stop_tx  : out std_logic;
          o_data_tx  : out std_logic
          );
 end component;
 
 component baud_gen_tx is  
     --generic 
    generic (
            baudrate    : integer := 115200         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
            --over_sample : integer := 16
           );                    
    port
        (
         i_clkin     : in std_logic;
         i_res       : in std_logic;
         i_start_clk : in std_logic;
         --i_stop_clk  : in std_logic;
         o_clkout    : out std_logic
       );
 end component;
 
    signal datatx   : std_logic :='1';
    signal start_ack    : std_logic:='0';  --for start that is the same as wr_ack
    --signal stop     : std_logic:='0';
    signal clk2     : std_logic;
  --constant prescaler : integer := 16; -- for rx   
     
 begin
  
 p_tx_rx : process(in_clock, in_reset)
  begin
    if in_reset = '0' then
       --datatx <= '1';    -- all of this caused signals to be in X
       --start <= '0';
       --stop <= '0';
       --out_wr_ack <= '0'; 
    end if;
    
    end process p_tx_rx;
  
  i_ctrl_tx: ctrl_tx port map
    (
     i_clk1    => in_clock,
     i_clk2    => clk2, 
     i_rst     => in_reset, 
     i_wr_req  => in_wr_req,
     i_data_tx  => in_data,
     o_wr_ack   => start_ack,
     --o_start_tx => start,
     --o_stop_tx => stop,
     o_data_tx  => datatx
    );
    
  i_baud: baud_gen_tx port map
    (
       i_clkin     => in_clock,
       i_res       =>in_reset,
       i_start_clk => start_ack,
       --i_stop_clk  => stop,
       o_clkout   => clk2    
     );
     
     out_data_tx <= datatx;
     out_wr_ack <= start_ack; 
    
    
 end architecture rtl;