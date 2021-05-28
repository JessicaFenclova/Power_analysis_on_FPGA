function [data]=xor_result(rec_data, j)
if rec_data ==0
   result='\ncorrect\n';
else
    result='incorrect\n';
end
outputFile=fopen('xored.txt','a+');
fprintf(outputFile,result, j);
fclose(outputFile);

%rec_data=de2bi(rec_data);
%data=bitxor(rec_data, rec_data)
%xor(rec_data())


end