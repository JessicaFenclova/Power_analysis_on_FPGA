function [state] = addroundkey(state,roundkey)

state=bitxor(state,roundkey);
end

