library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_ctrl_rx is
  port (
         in_clk      : in std_logic;
         in_rst      : in std_logic;
         in_rd_ack   : in std_logic;
         in_data     : in std_logic;
         out_data    : out std_logic_vector(7 downto 0);
         out_rd_req  : out std_logic;
         out_cnt     : out std_logic_vector(3 downto 0) --for testing
         --out_error   : out std_logic
  
       );
 end top_ctrl_rx;
 
architecture rtl of top_ctrl_rx is
 
 component ctrl_rx is -- names are mixed up this tx should be rx and vice versa  
                        
    port
        (
          i_clk1      : in std_logic;
          i_clk2      : in std_logic;
          i_rst       : in std_logic;
          i_rd_ack    : in std_logic;
          i_start     : in std_logic;
          --i_stop      : in std_logic;
          i_data      : in std_logic;
          o_data      : out std_logic_vector(7 downto 0);
          o_rd_req    : out std_logic;
          o_cnt       : out std_logic_vector(3 downto 0)
          --o_error     : out std_logic
          --o_cnt      : out std_logic_vector(3 downto 0)
         );
 end component;
 
 component rx_sampling is  
    --generic 
    generic (
            baudrate    : integer := 115200         -- calculation of the prescaler, so instead of 27 it will be the variable prescaler, which is calculated 50 MHz/(baudrate*over_sample and rounded up or down)
            --over_sample : integer := 16
           );                   
    port
        (
         i_clk       : in std_logic;
         i_rst       : in std_logic;
         i_data_rx   : in std_logic;
         o_start_bit : out std_logic   
         );
 end component;
 
 component baud_gen is  
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
          --o_cnt_done  : out std_logic;
          o_clkout    : out std_logic   
         );
 end component;
 
   
   signal dataout    : std_logic_vector(7 downto 0):="11111111";
   signal clk2       : std_logic;
   signal start      : std_logic;
   --signal cnt_done   : std_logic;

  --constant prescaler : integer := 16; -- for rx   
     
 begin
  
 p_tx_rx : process(in_rst)   --in_clk
  begin
      if in_rst = '0' then
         --dataout <= "11111111";
         --out_rd_req <='0';
         --out_error<= '0';
      end if;    
    
    
    end process p_tx_rx;
 
 i_rx_samp: rx_sampling 
 generic map (baudrate  => 115200)
 port map
    (  
     i_clk       => in_clk,
     i_rst       => in_rst,
     i_data_rx   => in_data,
     o_start_bit => start
    );  
    
  i_baud: baud_gen 
  generic map (baudrate => 115200)
  port map
    (
       i_clkin     => in_clk,
       i_res       => in_rst,
       i_start_clk => start,
       --o_cnt_done  => cnt_done,
       o_clkout    => clk2      
     ); 
    
  
  i_ctrl_rx: ctrl_rx port map
    (  
     i_clk1     => in_clk,
     i_clk2     => clk2,
     i_rst      => in_rst,
     i_rd_ack   => in_rd_ack,
     i_start    => start,
     --i_stop     => cnt_done,
     i_data     => in_data,
     o_data     => dataout,
     o_rd_req   => out_rd_req,
     o_cnt      => out_cnt
     --o_error    => out_error
    );
  
  
 
     
  
    
     out_data <= dataout; 
    
    
 end architecture rtl;