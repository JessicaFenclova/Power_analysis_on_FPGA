function []=send_serial(seri_port,data_send)

%data_send_dec=bi2de(data_send,2)
data_send = data_send(8)+ ...
            2*data_send(7)+...
            4*data_send(6)+...
            8*data_send(5)+...
            16*data_send(4)+...
            32*data_send(3)+...
            64*data_send(2)+...
            128*data_send(1)
        
        
fwrite(seri_port,char(data_send));




end