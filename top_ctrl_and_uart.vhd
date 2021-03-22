library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_ctrl_and_uart is
  port (
         i_clock    : in std_logic;
         i_reset    : in std_logic;
         --i_read_req   : in std_logic;
         --i_write_ack  : in std_logic;
         i_data      : in std_logic;
         i_data_sbox : in std_logic_vector(7 downto 0);
         --o_write_req : out std_logic;
         --o_read_ack  : out std_logic;
         o_trigger   : out std_logic;
         o_bits_sbox : out std_logic_vector(7 downto 0);
         o_data      : out std_logic           
  
       );
 end top_ctrl_and_uart;
 
architecture rtl of top_ctrl_and_uart is
 
 component top_ctrl_aes is   
                        
    port
        (
         in_clk_aes    : in std_logic;
         in_rst_aes    : in std_logic;
         in_read_req   : in std_logic;
         in_write_ack  : in std_logic;
         in_data_aes   : in std_logic_vector(7 downto 0);
         in_data_sbox  : in std_logic_vector(7 downto 0);
         out_write_req : out std_logic;
         out_read_ack  : out std_logic;
         out_trigger   : out std_logic;
         out_bits_sbox : out std_logic_vector(7 downto 0);
         out_data_aes  : out std_logic 
         );
 end component;
 
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
  
   
   signal rd_request   : std_logic;
   signal wr_request   : std_logic;
   signal rd_acknowl   : std_logic;
   signal wr_acknowl   : std_logic;
   signal datain_ctrl  : std_logic_vector(7 downto 0); -- from uart rx to ctrl
   signal dataout_ctrl : std_logic;                    -- from ctrl to uart tx
   
       
 begin
  
 p_ctrl_aes : process(i_reset)   --in_clk
  begin
      if i_reset = '0' then
         --dataout <= "11111111";
         --out_rd_req <='0';
         --out_wr_ack<= '0';
      end if;    
    
    
    end process p_ctrl_aes;
 
 i_top_ctrl_aes: top_ctrl_aes 
 
 port map
    (  
      in_clk_aes    => i_clock,
      in_rst_aes    => i_reset,
      in_read_req   => rd_request,
      in_write_ack  => wr_acknowl,
      in_data_aes   => datain_ctrl,
      in_data_sbox  => i_data_sbox,
      out_write_req => wr_request,
      out_read_ack  => rd_acknowl,
      out_trigger   => o_trigger,
      out_bits_sbox => o_bits_sbox,
      out_data_aes  => dataout_ctrl     
    );    
    
i_rx: top_ctrl_rx 
  
  port map
    (
       in_clk    => i_clock,      
       in_rst    => i_reset,    
       in_rd_ack => rd_acknowl, 
       in_data   => i_data,  
       out_data  => datain_ctrl,  
       out_rd_req=> rd_request    
     ); 
     
i_tx: top_ctrl_tx 
  
  port map
    (
       in_clock    => i_clock,   
       in_reset    => i_reset,
       in_wr_req   => wr_request,
       in_data     => dataout_ctrl ,
       out_data_tx => o_data,        --std_logic but it is std_logic_vector
       out_wr_ack  => wr_acknowl    
     );

    
     --out_data_uart <= dataout; 
    
    
 end architecture rtl;