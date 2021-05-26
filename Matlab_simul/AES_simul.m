%num_rounds;
%char message;  % 128 bits 16 bytes plaintext
%char key;% 128 bits
key_size=16;


% message = 'Encrypt this one';
% message=sprintf('%0.2X',message);
% message=num2cell(message);

% key=1:15;
% key(16)=1;
% key=sprintf('%0.2X',key);
% key=num2cell(key);
% for n = 1 : 16
%    key(n)=hex2dec(key(n));
% end

%%%% either use a predefined key or a key with random numbers%%%%%%%%%%%%%%
rand_key=randi([1 255],16,1)
%key = {'01','02','03','04','05','06','07','08','09','0a','0b','0c','0d','0e','0f','10'};
%key=hex2dec(key)
%key_bin=dec2bin(key,8);
%key_bin=reshape(key_bin,1,128);
key=rand_key';

%State
message = {'00','11','22','33','44','55','66','77','88','99','aa','bb','cc','dd','ee','ff'};
message=hex2dec(message);
message=message';

encrypted=AES_encrypt(message,key); % return encrypted message

%power model for sbox
%pow_sbox=plot_powermodel();
%bar(pow_sbox)

%now power model for one key and one round, make power models for the
%possible keys so from like 0 to 16 for example so only the frist byte will
%be changed
%real power model for given key and plaintext
model=real_pow_mod(message,key);

%now the power models for 100 different messages and one key
num_of_test_vectors=100;
plaintext=ones(num_of_test_vectors, 16);
measured_model=ones(num_of_test_vectors,key_size);
for x=1:num_of_test_vectors
        plaintext(x,:)=randi([1 255],1,16);
        measured_model(x,:)=real_pow_mod(plaintext(x,:),key);
end
%for prediction
% test_key={'01','02','03','04','05','06','07','08','09','0a','0b','0c','0d','0e','0f','10'};
% test_key=hex2dec(test_key);
% test_key=test_key';
%i don't know the key so without the test_key
predicted_model=ones(255,num_of_test_vectors);
%predicted models for 255 different keys, only 1st byte
for k=1:255
    %test_key(1,1)=k;
    for x=1:num_of_test_vectors
        %plaintext(x,:)=randi([1 255],1,16);
        %measured_model(x,:)=real_pow_mod(plaintext(x,:),key);
        
        predicted_model(k,x)=prediction(plaintext(x,1),k);
        %pred_model(k,:)=real_pow_mod(message,test_key);
    end
end

%compare the real power model with the predicted one and the one with the
%most matches is the key (so we can crack the cipher) and also plot the
%matches so it can be visible

match=ones(255,1);
for k=1:255
    matches=0;
for x=1:num_of_test_vectors
    % if measured_model(x,:)==predicted_model(x,:,k)
    if measured_model(x,1)==predicted_model(k,x)
        matches=matches+1;
        %match(k,:)=matches;
    end
        
end
match(k,1)=matches;
end

%cracking the cipher by finding the key
[index1,index2]=max(match)
key_position=index2;    

figure
b=bar(match)
title('The power models and correct key.','Fontsize', 22)
xlabel('255 different keys','Fontsize', 20) 
ylabel('Num. of matching power models','Fontsize', 20) 
b.FaceColor = 'flat';
b.CData(key_position,:) = [0.8 0.4 0];


