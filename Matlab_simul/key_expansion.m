function [new_keys] = key_expansion(inputkey)
%new_keys=ones(11,16);
%four_bytes=inputkey(1,1:4);
four_bytes=ones(1,4);
rcon_index=1;
new_keys=inputkey;

bytes_generated=16; %to know when all 176 bytes have been generated, 16 from original key copied
%rcon iteration index
%temp for 4 bytes

while bytes_generated < 176
    %for i=1:10
    for i=1:4
        %temp_four(i)=expandedkeys(i+bytes_generated-4)
        four_bytes(1,i)=new_keys(1,(i+bytes_generated-4));
    end
    remainder=mod(bytes_generated,16);
    if remainder==0
        new_exp=expan_core(four_bytes,rcon_index);
        %new_keys=cat(2,new_keys, new_exp);
        % now take the new_exp 4 bytes and XOR with the first 4 bytes in
        % new_keys
        rcon_index=rcon_index+1;
    end
    expandedkey16=new_keys(1,((bytes_generated-16+1):(bytes_generated-16+1+3)));% the first 4 bytes
    new_four=bitxor(new_exp,expandedkey16);
    %
    new_keys=cat(2,new_keys, new_four);
    bytes_generated=bytes_generated+4;
    %end
    
end
end

