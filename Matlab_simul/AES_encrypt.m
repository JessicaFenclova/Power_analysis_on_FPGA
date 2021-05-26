function [encrypted_mess] = AES_encrypt(message,key)
%num_of_rounds=10;
%char state;
%expandedkeys=ones(16,11); % 176 bytes, 16 byte key expanded because we want 11 other keys, 11*16=176
num_of_rounds=9;
state=message;
%results=ones(4,9);
% functions
%first keyexpansion
expandedkeys = key_expansion(key);% fce returns the 176 bytes of expanded keys

% then init round, so just addroundkey

state=addroundkey(state,key); %xor with key


%sbox;% table copy from wikipedia


for i=1:num_of_rounds
    state=subbytes(state);
    results=state;
    state=shiftrows(state);
    results2=state;
    state=mixcolumns(state);
    results3=state;
    expanded_key=expandedkeys(1,((16*i+1):(16*i+16)));% watch out it went 16+1 then 16+2, no i want 16+1 then 16+16
    state=reshape(state,1,16);
    state=addroundkey(state,expanded_key); %input is an expanded key, correct later, to expandedkeys (16 *(i+1)) i is
    results4=state;
    %the number of rounds
end

%last part just subbytes, shiftrows, addroundkey

%final_round; another fce or not %expanded key + 160
% subbytes
state=subbytes(state);
%shiftrows
state=shiftrows(state);
%addroundkey  (but call with expanded key + 160)
expanded_key=expandedkeys(1,(161:176));
state=reshape(state,1,16);
state=addroundkey(state,expanded_key);
encrypted_mess=state %to show encrypted mess
end

