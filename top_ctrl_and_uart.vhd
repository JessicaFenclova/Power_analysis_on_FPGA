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
         output_SEGMENT_0_3 : OUT STD_LOGIC_VECTOR(6 downto 0);
         output_SEGMENT_4_7 : OUT STD_LOGIC_VECTOR(6 downto 0);
         o_trigger   : out std_logic;
         o_bits_sbox : out std_logic_vector(7 downto 0);
         o_test_bit  : out std_logic;
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
         out_data_aes  : out std_logic_vector(7 downto 0) 
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
 
 component registr_8bit_async is -- neco trida v C# (nekde je napsaná t?ída a já jí tady chci pou?ít, tak ud?lám instanci), instanci delam v t?lu architektury (begin)  
                        -- jméno "first_test" asi musi byt stejne jako je v .vhd, nebo spí? ne
   port
     (
      input_IN      : in std_logic_vector(7 downto 0); -- (10 downto 0)
      input_CLK     : in std_logic;
      input_RESTART : in std_logic;
      output_Q      : OUT STD_LOGIC_VECTOR(7 downto 0)
     );

END COMPONENT;
 
 component sedmi_segment_async is --for testing if the bits correspond  
                        
      port
         (
          input_IN : IN STD_LOGIC_VECTOR(3 downto 0); 
          output_SEGMENT : OUT STD_LOGIC_VECTOR(6 downto 0)
         );

end component;
 
  
   --signal safe_reset   : std_logic :='1';  --double flip flop
   --signal reset2       : std_logic :='1';  --double flip flop
   signal rd_request   : std_logic;
   signal wr_request   : std_logic;
   signal rd_acknowl   : std_logic;
   signal wr_acknowl   : std_logic;
   signal datain_ctrl  : std_logic_vector(7 downto 0); -- from uart rx to ctrl
   signal dataout_ctrl : std_logic_vector(7 downto 0);                    -- from ctrl to uart tx
   --signal data_outtx   : std_logic_vector(7 downto 0);
   signal input_seg   : std_logic_vector(7 downto 0);
   signal output_segh : std_logic_vector(6 downto 0);
	signal output_segl: std_logic_vector(6 downto 0); 
   
       
 begin
  
 p_ctrl_aes : process( i_reset)   --i_reset
  begin
      --if i_clock'event and (i_clock='1') then
         --reset2<= i_reset;
         --safe_reset<=reset2;
      --end if;
      if i_reset = '0' then   --safe_reset
         --dataout <= "11111111";
         --out_rd_req <='0';
         --out_wr_ack<= '0';
         --o_data<='1';
         o_test_bit<='0';
      else
         o_test_bit <= '1';
         --o_data<='1';
         
      end if;    
    
    
    end process p_ctrl_aes;
    
 --p_ctrl_reset : process(i_clock)   --i_reset
  --begin
      --if i_clock'event and (i_clock='1') then
        
         --reset2<= i_reset;
         --safe_reset<=reset2;
        
         
      --end if;
  
    --end process p_ctrl_reset;   
 
 i_top_ctrl_aes: top_ctrl_aes 
 
 port map
    (  
      in_clk_aes    => i_clock,
      in_rst_aes    => i_reset,   --safe_reset
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
       in_rst    => i_reset,    --safe_reset
       in_rd_ack => rd_acknowl, 
       in_data   => i_data,  
       out_data  => datain_ctrl,  
       out_rd_req=> rd_request    
     ); 
     
i_tx: top_ctrl_tx 
  
  port map
    (
       in_clock    => i_clock,   
       in_reset    => i_reset,    --safe_reset
       in_wr_req   => wr_request,
       in_data     => dataout_ctrl,    --dataout_ctrl,  data_outtx ,  std_logic but it is std_logic_vector
       out_data_tx => o_data,         
       out_wr_ack  => wr_acknowl    
     );
     
i_reg: registr_8bit_async 
  port map
   (
     input_IN      => dataout_ctrl, --8bit
     input_CLK     => i_clock,
     input_RESTART => i_reset,      --safe_reset
     output_Q      => input_seg     -- out 8 bits!  
   );
     
i_segment_0_3: sedmi_segment_async 
 port map
  (
   input_IN => input_seg(3 downto 0),
   output_SEGMENT => output_segl      -- out 7 bits for 7 segment
  );

i_segment_4_7: sedmi_segment_async 
  port map
  (
   input_IN => input_seg(7 downto 4),
   output_SEGMENT => output_segh  
  );

output_SEGMENT_0_3<= not output_segl;
output_SEGMENT_4_7<= not output_segh;    

     --data_outtx <= "0000000" & dataout_ctrl; -- nechat bud 1 bit nebo 8 bitu, je to spatne
     --out_data_uart <= dataout; 
    
    
 end architecture rtl;