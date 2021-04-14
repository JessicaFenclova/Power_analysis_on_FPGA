library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity top_sbox_aes is
  port (
        i_clock    : in std_logic;
        i_reset    : in std_logic;
        i_enable   : in std_logic; --might need another enable signal for the register after the sbox, or it may be possible to generate the signal inside of this entity which would be set after the trigger signal is reset
        i_trigger  : in std_logic;    
        i_data     : in std_logic_vector(7 downto 0);
        o_data     : out std_logic_vector(7 downto 0)              
       );
  end top_sbox_aes;
  
  architecture rtl of top_sbox_aes is
  
  
  component sbox is   
                        
    port (
         input_byte  : in std_logic_vector(7 downto 0);
         output_byte : out std_logic_vector(7 downto 0)
         );
  end component;
  
  component reg_sbox is  
   port (
         input_CLK     : in std_logic;
         input_RESTART : in std_logic;
         input_ENABLE  : in std_logic;
         input_TRIG    : in std_logic;
         input_IN      : in std_logic_vector(7 downto 0); 
         output_Q      : out std_logic_vector(7 downto 0)
        );
  end component;
  
  component reg_after is
    port (
        in_CLK     : in std_logic;
        in_RESTART : in std_logic;
        in_ENABLE  : in std_logic;
        in_IN      : in std_logic_vector(7 downto 0); 
        out_Q      : out std_logic_vector(7 downto 0)
       );
       
  end component;
  
 
  
     signal trig_reset : std_logic;   -- for the enable of the reg after sbox
     signal en_two : std_logic;
     signal out_data : std_logic_vector(7 downto 0); 
     signal out_reg : std_logic_vector(7 downto 0);
     
  begin
  
   p_sbox : process(i_clock, i_reset)
    begin
        if i_reset = '0' then
           --o_data<="11111111";
           trig_reset<='0'; 
           en_two<='0';
           
        elsif i_clock'event and (i_clock='1') then
             trig_reset<=i_trigger;
             if (i_trigger='0') and (trig_reset='1') then
                en_two<='1';
             else
               en_two<='0';
             end if;
        
        
         end if;
  end process p_sbox;
  
  i_sbox: sbox
   port map
     (    
         input_byte =>out_reg,
         output_byte=> out_data
     );
  
  i_reg: reg_sbox   
  port map
    (
       input_CLK     => i_clock,      
       input_RESTART => i_reset,    
       input_ENABLE  => i_enable, 
       input_TRIG    => i_trigger,  
       input_IN      => i_data,  
       output_Q      => out_reg    
     );
     
  i_reg2: reg_after   
  port map
      (     
        in_CLK  =>i_clock,   
        in_RESTART =>i_reset,
        in_ENABLE =>en_two, 
        in_IN     =>out_data,  
        out_Q     => o_data
       );
     
      

 end architecture rtl;