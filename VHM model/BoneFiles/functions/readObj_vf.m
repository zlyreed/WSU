function [vertex_data,face_data]=readObj_vf(filename,vName,fName)

%output: vertex_data=nX3 matrix; face_data=nX3 matrix

% clear all 
% close all
% 
% %inputs:
% filename='T1_meter.obj'; %the obj file only have vertex and face information
% vName='v';
% fName='f';


% read a file into a cell
fid=fopen(filename,'r');
file_text=fread(fid, inf, 'uint8=>char')';
fclose(fid);
file_lines = regexp(file_text, '\n+', 'split');
file_words = regexp(file_lines, '\s+', 'split');

% get data from the desired lines
file_words2=file_words';
ftype=cell(length(file_words2),1);
i=0;
j=0;
v_data0=zeros(length(file_words2),3);
f_data0=zeros(length(file_words2),3);
for nf=1:length(file_words2)
    ftype=file_words2{nf,1}(1,1);   % collect first column
    
    if strcmp(ftype,vName)==1
        i=i+1;
        v_data0(i,:)=[str2num(file_words2{nf,1}{1,2}),str2num(file_words2{nf,1}{1,3}),str2num(file_words2{nf,1}{1,4})];
    end
    
    if strcmp(ftype,fName)==1
        j=j+1;
        f_data0(j,:)=[str2num(file_words2{nf,1}{1,2}),str2num(file_words2{nf,1}{1,3}),str2num(file_words2{nf,1}{1,4})];
    end

end

% remove all the empty cells
vertex_data=v_data0(1:i,:);
face_data=f_data0(1:j,:);


