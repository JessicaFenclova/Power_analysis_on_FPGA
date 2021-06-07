library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_uart is
  port (
         in_clk_uart      : in std_logic;
         in_rst_uart      : in std_logic;
         --in_read_ack      : in std_logic;
         in_write_req     : in std_logic;
         in_data_uart     : in std_logic;
         out_write_ack    : out std_logic;
         out_data_uart    : out std_logic;
         out_read_req     : out std_logic;
         output_SEGMENT_0_3 : OUT STD_LOGIC_VECTOR(6 downto 0);
         output_SEGMENT_4_7 : OUT STD_LOGIC_VECTOR(6 downto 0);
         output_segment_test : out std_logic_vector(6 downto 0)            
  
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
          out_rd_req  : out std_logic;
          out_cnt     : out std_logic_vector(3 downto 0)
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
 
   
   --signal dataout   : std_logic;
   signal datain    : std_logic_vector(7 downto 0);
   signal in_read_ack : std_logic;
   signal input_seg   : std_logic_vector(7 downto 0);
   signal out_segment : std_logic_vector(3 downto 0);
   signal output_segh : std_logic_vector(6 downto 0);
   signal output_segl: std_logic_vector(6 downto 0);
       
 begin
  
 p_uart : process(in_rst_uart)   --in_clk
  begin
      if in_rst_uart = '0' then
         --dataout <= "11111111";
         --out_rd_req <='0';
         --out_wr_ack<= '0';
      
      end if;    
    
    
    end process p_uart;
 p_cnt : process(out_segment)   -- or out_segment?
  begin
      if out_segment = "1000" then
         in_read_ack<='1';
      
      end if;    
    
    
    end process p_cnt;
 
 i_ctrl_rx: top_ctrl_rx 
 
 port map
    (  
     in_clk       => in_clk_uart,
     in_rst       => in_rst_uart,
     in_rd_ack    => in_read_ack,
     in_data      => in_data_uart,
     out_data     => datain,
     out_rd_req   => out_read_req,
     out_cnt      => out_segment
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
     
i_reg: registr_8bit_async 
  port map
   (
     input_IN      => datain, --8bit
     input_CLK     => in_clk_uart,
     input_RESTART => in_rst_uart,      
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
  
 i_segment: sedmi_segment_async 
  port map
  (
   input_IN => out_segment,
   output_SEGMENT => output_segment_test  
  );

output_SEGMENT_0_3<= not output_segl;
output_SEGMENT_4_7<= not output_segh;
  

    
     --out_data_uart <= dataout; 
    
    
 end architecture rtl;