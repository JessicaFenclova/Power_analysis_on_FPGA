library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_ctrl_aes is
  port (
         in_clk_aes    : in std_logic;
         in_rst_aes    : in std_logic;
         in_read_req   : in std_logic;
         in_write_ack  : in std_logic;
         in_data_aes   : in std_logic_vector(7 downto 0);
         in_data_sbox  : in std_logic_vector(7 downto 0);
         out_write_req : out std_logic;
         out_read_ack  : out std_logic;
         out_trigger   : out std_logic;
         out_en_sbox   : out std_logic_vector(31 downto 0);
         out_bits_sbox : out std_logic_vector(7 downto 0);
         out_data_aes  : out std_logic_vector(7 downto 0)           
  
       );
 end top_ctrl_aes;
 
architecture rtl of top_ctrl_aes is
 
 component ctrl_aes is   
                        
    port
        (
          i_clk         : in std_logic;
          i_rst         : in std_logic;
          i_rd_req      : in std_logic;
          i_data        : in std_logic_vector(7 downto 0);
          i_xor_result  : in std_logic_vector(7 downto 0);    --the sbox outputs put through xor, the state machine measure will use to tell the main state machine maybe the eval_result signal a 0 or 1, correct incorrect
          i_wr_ack      : in std_logic;
          o_rd_ack      : out std_logic; 
          o_wr_req      : out std_logic;
          o_param       : out std_logic_vector(4 downto 0); -- cmd tells if this will be the lsb or msb or param for enabling sboxes
    --o_lsb         : out std_logic_vector(4 downto 0);     --leave only one output, make it generic, o_param
    --o_msb         : out std_logic_vector(4 downto 0);
          o_lsb_en      : out std_logic;
          o_msb_en      : out std_logic;
          o_en_sbox     : out std_logic; -- state machine sbox will enable the decoder to take param reg bits and decode them to know which sboxes to enable
          o_gener_data  : out std_logic; -- the state machine measure will let the lfsr know to generate new data or leave the data as they are
          o_trigger     : out std_logic; -- the state machine measure will set and reset this
          o_data        : out std_logic_vector(7 downto 0)
         );
 end component;
 
 component sbox_decoder is  
                      
    port
        (
         i_clock    : in std_logic;
         i_reset    : in std_logic;
         i_enable   : in std_logic;    
         i_param    : in std_logic_vector(4 downto 0);
         o_en_sbox  : out std_logic_vector(31 downto 0) --31 optional sboxes, param 5 bits 2^5 -> 31
         );
 end component;
 
 component lfsr is  
                      
    port
        (
         in_clk       : in std_logic;
         in_rst       : in std_logic;
         i_gener_data : in std_logic;    -- from the state machine measure, -- input from the state machine for measruing that says generate data here in lfsr
         i_lsb_en     : in std_logic;
         i_msb_en     : in std_logic;
         i_param_bits : in std_logic_vector(4 downto 0);
         o_gener_bits : out std_logic_vector(7 downto 0) 
         );
 end component;
 
   
   --signal dataout   : std_logic;
   --signal datain    : std_logic_vector(7 downto 0);
   signal decoder_en   : std_logic;
   signal lfsr_en     : std_logic;
   signal lsb_en   : std_logic;
   signal msb_en   : std_logic;
   signal param    : std_logic_vector(4 downto 0);
   --signal sbox_enable  : std_logic_vector(30 downto 0);
       
 begin
  
 p_ctrl_aes : process(in_rst_aes)   --in_clk
  begin
      if in_rst_aes = '0' then
         --dataout <= "11111111";
         --out_rd_req <='0';
         --out_wr_ack<= '0';
      end if;    
    
    
    end process p_ctrl_aes;
 
 i_ctrl_aes: ctrl_aes 
 
 port map
    (  
      i_clk        => in_clk_aes,    
      i_rst        => in_rst_aes,     
      i_rd_req     => in_read_req,    
      i_data       => in_data_aes,    
      i_xor_result => in_data_sbox, 
      i_wr_ack     => in_write_ack,     
      o_rd_ack     => out_read_ack,     
      o_wr_req     => out_write_req,    
      o_param      => param,   
      o_lsb_en     => lsb_en,
      o_msb_en     => msb_en,    
      o_en_sbox    => decoder_en,  
      o_gener_data => lfsr_en, 
      o_trigger    => out_trigger,    
      o_data       => out_data_aes      
    );
    
 i_sbox: sbox_decoder 
  
   port map
     (
       i_clock   => in_clk_aes,
       i_reset   => in_rst_aes,
       i_enable  => decoder_en,
       i_param   => param,
       o_en_sbox => out_en_sbox    
     );     
    
i_lfsr: lfsr 
  
  port map
    (
       in_clk       => in_clk_aes,
       in_rst       => in_rst_aes,
       i_gener_data => lfsr_en,
       i_lsb_en     => lsb_en,
       i_msb_en     => msb_en,
       i_param_bits => param,
       o_gener_bits => out_bits_sbox     
     ); 

    
     --out_data_uart <= dataout; 
    
    
 end architecture rtl;