function [shifted_state] = shiftrows(state)
state=reshape(state.',4,4).';% pozor bez transpozice dela ale do sloupcu ne radku

%shift to left
% for (i = 0; i < Nk; ++i)
%   {
%     RoundKey[(i * 4) + 0] = Key[(i * 4) + 0];
%     RoundKey[(i * 4) + 1] = Key[(i * 4) + 1];
%     RoundKey[(i * 4) + 2] = Key[(i * 4) + 2];
%     RoundKey[(i * 4) + 3] = Key[(i * 4) + 3];
%   }
%state=circshift(state,1);%shift left by 1 byte, then next row by 2, 3 and so on
% nebo zdlouhavy
%tmp[0]=state[0];
%tmp[1]=state[5];
temp=state(2,1);
for i=1:3
    state(2,i)=state(2,i+1);
end
state(2,4)=temp;

temp=state(3,1);
temp2=state(3,2);
for i=1:2
    state(3,i)=state(3,i+2);
end
state(3,3)=temp;
state(3,4)=temp2;

temp=state(4,1);
temp2=state(4,2);
temp3=state(4,3);

state(4,1)=state(4,4);
state(4,2)=temp;
state(4,3)=temp2;
state(4,4)=temp3;

shifted_state=state;


end

