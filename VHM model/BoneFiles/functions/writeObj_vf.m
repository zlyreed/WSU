function writeObj_vf(newfilename, v_data,f_data,notes)
% clear all
% close all
% clc
% 
% output: save a new obj file with only vertex and face information 
%
% %Inputs:
% newfilename='writeobjfile_vf_test.obj';
% notes='The obj. file is generated in matlab with only vertex and face data.';
% 
% filename='T1_meter.obj'; %the obj file only have vertex and face information
% vName='v';
% fName='f';
% [v_data,f_data]=readObj_vf(filename,vName,fName);

%% write a obj file with only 'v' and 'f' lines
fid = fopen(newfilename,'w');
fprintf(fid,'%s\n\n',notes);  % put desired notes in the first line

for nvk=1:1:length(v_data)
fprintf(fid,'%s %5.5f %5.5f %5.5f\n', 'v', v_data(nvk,1), v_data(nvk,2),v_data(nvk,3));
end

for nfk=1:1:length(f_data)
fprintf(fid,'%s %5.5f %5.5f %5.5f\n', 'f', f_data(nfk,1), f_data(nfk,2),f_data(nfk,3));
end

fclose(fid);