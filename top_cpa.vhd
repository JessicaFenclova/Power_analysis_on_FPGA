library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_cpa is
  generic (num_sbox : integer range 1 to 32 := 1);       -- default value is 1 sbox
  port (
         i_cloc    : in std_logic;
         i_res     : in std_logic;
         i_data_rx : in std_logic;
         o_trigger : out std_logic;
         o_data_tx : out std_logic           
  
       );
 end top_cpa;
 -- for SBOX use generic and then in port map have a for loop from i=1 to i=31 and the port map with happen ix
 
architecture rtl of top_cpa is
 
 component top_uart_aes is
  port (
         in_clk_uart      : in std_logic;
         in_rst_uart      : in std_logic;
         in_read_ack      : in std_logic;
         in_write_req     : in std_logic;
         in_data_uart     : in std_logic;
         in_aes           : in std_logic_vector(7 downto 0);     -- in from ctrl aes
         out_aes          : out std_logic_vector(7 downto 0);    -- out to ctrl aes
         out_write_ack    : out std_logic;
         out_data_uart    : out std_logic;
         out_read_req     : out std_logic           
  
       );
 end component;
 
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
         out_en_sbox   : out std_logic_vector(31 downto 0);
         out_bits_sbox : out std_logic_vector(7 downto 0);
         out_data_aes  : out std_logic_vector(7 downto 0) 
         );
 end component;
 
 component xor_sbox is   
   generic (groups : integer range 1 to 32);    -- groups value given by num of sboxes
            
    port (
         input_byte  : in std_logic_vector((8*groups)-1 downto 0);
         output_byte : out std_logic_vector(7 downto 0)    
         );
 end component;
 
 component top_sbox_aes is
  --generic(num_of_sbox : integer); -- num of sbox given by signal out_en_sbox from top_ctrl_aes, integer :=1   : positive then generic map (N)
 
  port (
        i_clock    : in std_logic;
        i_reset    : in std_logic;
        i_enable   : in std_logic; --might need another enable signal for the register after the sbox, or it may be possible to generate the signal inside of this entity which would be set after the trigger signal is reset
        i_trigger  : in std_logic;    
        i_data     : in std_logic_vector(7 downto 0);
        o_data     : out std_logic_vector(7 downto 0)              
       );
  end component;
  
     --constant num_of_sbox : integer;
     --signal xor_input : std_logic_vector((8*groups)-1 downto 0);
     signal rd_req       : std_logic;
     signal wr_req       : std_logic;
     signal rd_ack       : std_logic;
     signal wr_ack       : std_logic;
     signal trig         : std_logic;
     --signal dat_rx       : std_logic;
     signal dat_tx       : std_logic;
     signal dat_out_aes  : std_logic_vector(7 downto 0) :="11111111";
     signal dat_in_aes   : std_logic_vector(7 downto 0):="11111111";
     signal sbox_bits    : std_logic_vector(7 downto 0) :="11111111";
     signal sbox_out     : std_logic_vector((8*num_sbox)-1 downto 0);  --????  it works in modelsim but not sure it is correct, need to be the size of input_byte, so also 8*num_sbox downto 0                            --std_logic_vector((8*groups)-1 downto 0)
     signal out_sbox_xor : std_logic_vector(7 downto 0) :="11111111";
     signal en_sbox      : std_logic_vector(31 downto 0);
      
  
  begin
    p_dif : process(i_res)   --in_clk
      begin
         if i_res = '0' then
            --o_data_tx<= '0';
            --o_trigger<='0';
         end if;
    end process p_dif;
  
  
  gen_sbox: for i in 1 to num_sbox generate
  
  i_sbox: top_sbox_aes  --num of sbox given by signal out_en_sbox, so can it be like this?    generic map (num_sbox)
                port map 
                (
                  i_clock   => i_cloc,
                  i_reset   => i_res,
                  i_enable  => en_sbox(i-1),    -- or just enable with one, because i am saying the i sbox is enabled
                  i_trigger => trig,    --?
                  i_data    => sbox_bits,
                  o_data    => sbox_out((8*i)-1 downto (8*i)-8)  -- input_byte((8*i)-1 downto (8*i)-8)                 
                
                 );
    end generate;
    
  i_xor: xor_sbox generic map (num_sbox) --num of sbox given by signal out_en_sbox, so can it be like this?
              port map 
                (
                 input_byte  => sbox_out,
                 output_byte => out_sbox_xor           
                 );
                 
     
  i_ctrl: top_ctrl_aes 
                port map 
                (
                  in_clk_aes    => i_cloc, 
                  in_rst_aes    => i_res,   
                  in_read_req   => rd_req,                                  
                  in_write_ack  => wr_ack,
                  in_data_aes   => dat_out_aes,   
                  in_data_sbox  => out_sbox_xor,  
                  out_write_req => wr_req, 
                  out_read_ack  => rd_ack,
                  out_trigger   => trig,   
                  out_en_sbox   => en_sbox,
                  out_bits_sbox => sbox_bits,
                  out_data_aes  => dat_in_aes             
                
                 );
  i_uart:  top_uart_aes
                port map 
                (
                  in_clk_uart   => i_cloc,      
                  in_rst_uart   => i_res,     
                  in_read_ack   => rd_ack,   
                  in_write_req  => wr_req,    
                  in_data_uart  => i_data_rx,    
                  in_aes        => dat_in_aes,              -- in from ctrl aes
                  out_aes       => dat_out_aes,      -- out to ctrl aes
                  out_write_ack => wr_ack,  
                  out_data_uart => dat_tx,   
                  out_read_req  => rd_req
                           
                 );
 
 -- make generate staments and have the number of sboxes and xor inputs instantiated with the generate statement (generic)
    o_trigger<=trig;
    o_data_tx<=dat_tx;
 
 end architecture rtl;