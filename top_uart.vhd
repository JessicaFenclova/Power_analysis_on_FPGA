library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_uart is
  port (
         in_clk_uart      : in std_logic;
         in_rst_uart      : in std_logic;
         in_read_ack      : in std_logic;
         in_write_req     : in std_logic;
         in_data_uart     : in std_logic;
         out_write_ack    : out std_logic;
         out_data_uart    : out std_logic;
         out_read_req     : out std_logic           
  
       );
 end top_uart;
 
architecture rtl of top_uart is
 
 component top_ctrl_rx is   
                        
    port
        (
          in_clk      : in std_logic;
          in_rst      : in std_logic;
          in_rd_ack   : in std_logic;
          in_data     : in std_logic;
          out_data    : out std_logic_vector(7 downto 0);
          out_rd_req  : out std_logic
         );
 end component;
 
 component top_ctrl_tx is  
                      
    port
        (
         in_clock    : in std_logic;
         in_reset    : in std_logic;
         in_wr_req   : in std_logic;
         in_data     : in std_logic_vector(7 downto 0);
         out_data_tx : out std_logic;
         out_wr_ack  : out std_logic 
         );
 end component;
 
   
   --signal dataout   : std_logic;
   signal datain    : std_logic_vector(7 downto 0);
       
 begin
  
 p_uart : process(in_rst_uart)   --in_clk
  begin
      if in_rst_uart = '0' then
         --dataout <= "11111111";
         --out_rd_req <='0';
         --out_wr_ack<= '0';
      end if;    
    
    
    end process p_uart;
 
 i_ctrl_rx: top_ctrl_rx 
 
 port map
    (  
     in_clk       => in_clk_uart,
     in_rst       => in_rst_uart,
     in_rd_ack    => in_read_ack,
     in_data      => in_data_uart,
     out_data     => datain,
     out_rd_req   => out_read_req
    );  
    
i_ctrl_tx: top_ctrl_tx 
  
  port map
    (
       in_clock    => in_clk_uart,
       in_reset    => in_rst_uart,
       in_wr_req   => in_write_req,
       in_data     => datain,
       out_data_tx => out_data_uart,
       out_wr_ack  => out_write_ack     
     ); 

    
     --out_data_uart <= dataout; 
    
    
 end architecture rtl;