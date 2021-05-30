prompt='Select a number of measurement cycles.'
num_of_cycles=input(prompt);
comport='com3'; % check what comport you are connected to
%baudrate=38400;

fclose(instrfind)% to close ports to be able to open, but not for the first time, 
%so if the script is turned on then this has to be comment but if it stays open and the script is turned on again this has to be uncommented

port_1 = serial(comport, 'BaudRate', 115200); % the default baudrate is set to 115200
fopen(port_1);

for i=1:num_of_cycles
    %dec_i=double(i);
    %x=['Cycle number ', dec_i];
    %disp(x)
    fprintf('Cycle number: %d\n',i)
    if i==1
        lfsr_data=255;
        lfsr_data=de2bi(lfsr_data,8);
    end
    cmd=randi([1,2],1,1);
    param=randi([1,31],1,1);
    if cmd == 1
       %set lsb 
       %cmd=de2bi(cmd,3,'left-msb');
       cmd=[0 0 0]; %cmd lsb 000
       param=de2bi(param,5, 'right-msb');
       %lfsr_data(3:0)=param(3:0)      % not rlly
       lf_1=lfsr_data(5:8);
       par_1=param(1:4);
       lfsr_data=[lf_1 par_1]; % not rlly
    elseif cmd == 2
       %set msb
       %cmd=de2bi(cmd,3,'left-msb');
       cmd=[1 0 0];% cmd msb 001
       param=de2bi(param,5, 'right-msb');
       lf_2=lfsr_data(1:4);
       par_2=param(1:4);
       lfsr_data=[par_2 lf_2];
    end
    
    data=[cmd param];
    send_serial(port_1, data);
    rec_data1=read_serial(port_1); %only for checking
    
    %cmd for setting num. of sboxes
    %cmd=3;
    %cmd=de2bi(cmd,3,'left-msb');
    cmd=[0 1 0];
    param=randi([1,31],1,1);         %either generate random num. of sboxes or define
    param=de2bi(param,5, 'right-msb'); 
    data=[cmd param];
    send_serial(port_1, data);
    rec_data2=read_serial(port_1); %only for checking
    
    %cmd for measuring
    cmd=[1 1 0];
    %cmd=4 %param not needed
    %cmd=de2bi(cmd,3,'left-msb');
    %param=[0 1 0 1 1];
    data=[cmd param];
    lfsr_data=lfsr_generator(lfsr_data); % check out what bits for sboxes were generated 
    send_serial(port_1,data);
    rec_data=read_serial(port_1);
    xor_result(rec_data, i);
end

fclose(port_1);
delete(port_1);

%%%%%%%%%%%
%fclose('new_lfsr.txt');
%fclose('xored.txt');
fclose('all');

