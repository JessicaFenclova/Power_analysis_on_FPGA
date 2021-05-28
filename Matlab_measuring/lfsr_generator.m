function [data_out]=lfsr_generator(data)

old_data=data;
new_data(2:8)= old_data(1:7);
new_data(1)= (((old_data(1)==old_data(3))==(old_data(4))==old_data(5)));

outputFile=fopen('new_lfsr.txt','a+');
fwrite(outputFile, new_data)
data_out=new_data;
end