library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity ctrl_rx is
  port (
    i_clk1      : in std_logic;
    i_clk2      : in std_logic;
    i_rst       : in std_logic;
    i_rd_ack    : in std_logic;
    i_start     : in std_logic;
    i_stop      : in std_logic;
    i_data      : in std_logic;
    o_data      : out std_logic_vector(7 downto 0);
    o_rd_req    : out std_logic;
    o_error     : out std_logic
    --o_cnt       : out std_logic_vector(3 downto 0) -- only for checking
    --o_cnt_slow      : out std_logic_vector(3 downto 0) -- only for checking    
  
    );
 end ctrl_rx;
 
 architecture rtl of ctrl_rx is
 
 
    signal start_en: std_logic :='0';
    signal  in_d : std_logic_vector(7 downto 0):= "11111111";
    
    signal count : integer :=0;
    --signal slow_cnt : integer :=0;
 
       
  begin
  
    p_rx: process(i_clk1, i_rst)
      begin
        if i_rst = '0' then
           o_rd_req <='0';
           o_error <= '0';
           in_d <="11111111";
           o_data <="11111111";
           count <=0;
        elsif i_clk1'event and (i_clk1='1') then
          if (i_start='1') then
             if (i_data='0') then
                 o_error<='0';
                 start_en <='1';
             else
                 o_error<='1';
             end if;
             --start_en <='1';
          elsif (i_stop='1') then
             if (i_rd_ack='0') then
              o_rd_req <= '1';
             end if; 
              start_en <='0';
          else
             o_rd_req <='0';
          end if;
          
         if (start_en='1') then
             count <= count+1;
            --if (count=0) then
               --if (i_data='0') then
                 --o_error<='0';
               --else
                 --o_error<='1';
               --end if;               
             
              if (count>0) and (count<9) then
                in_d(count-1) <= i_data;
                --if i_clk2'event and (i_clk2='1') then
                count <= (count+1);
                o_error<='0';
                --end if;
             
             elsif (count=9) then
                if (i_data='1') then
                   o_error<='0';
                   count<=0;
                else
                   o_error<='1';
                   start_en<='0'; -- added
                   o_data<= "11111111"; --added
                   
                end if;
               --start_en<='0';
               count<=0;                 
              end if;
              
              --if (i_rd_ack='1') then
                   --o_rd_req<= '0';
                   --o_error <='0';
                   --start_en<='0';
                   --o_data<= "11111111";
                   --count<=0; -- added
              --elsif (i_rd_ack='1') and (start_en='0') then
                    --o_error<='1';         
              --end if;
              --count <= (count+1);              
              
            end if;
            
            if (i_rd_ack='1') then
                   o_rd_req<= '0'; -- maybe not necessary
                   o_error <='0';
                   start_en<='0';
                   --o_data<= "11111111";
                   count<=0; -- added
                if i_clk2'event and (i_clk2='1') then  -- dont use event leave clk2 as signal                  
                    o_data<= in_d;                     
                end if;
            elsif (i_rd_ack='1') and (start_en='0') then
                    o_error<='1';
            else
                o_data<= "11111111"; -- added this else         
            end if;
            
            --if i_clk2'event and (i_clk2='1') then  -- dont use event leave clk2 as signal                  
                    --o_data<= in_d;
                    
            --end if;
          
          
          
          --o_cnt <= std_logic_vector(to_unsigned(count,o_cnt'length));           -- just to for checking
          --o_cnt_slow <= std_logic_vector(to_unsigned(slow_cnt,o_cnt_slow'length));
          
        end if;
    end process p_rx;
    
        
 end architecture rtl;