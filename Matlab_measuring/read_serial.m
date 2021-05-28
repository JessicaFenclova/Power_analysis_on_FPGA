function [data]=read_serial(comport)
%val=1;
data=0;
%while val
data=fread(comport,1, 'uint8'); %read one byte
   %values =fscanf(port)
%comport.TransferStatus;
%numVal=comport.ValuesReceived;
%if number>0
    %val=0;
%end

%end
end
