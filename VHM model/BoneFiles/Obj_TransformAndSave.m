% load a obj file, apply the desired transformation matrix, and save as a
% new obj file

clear all
clc
close all

% load a obj file
filename='T2_to_T12_meter.obj';
vName='v'; % the lines starting with 'v' (vertex)
fName='f'; % the lines starting with 'f' (face)
[vertex_data,face_data]=readObj_vf(filename,vName,fName);


%% Import MeshLab .aln file (co-registration of T1 was done in MeshLab: transforamtion from T1_CTCS to T1_LocalCS)

% coregistration result file: 'T1_alignment.aln';
Transformation=[-0.003448	-0.895853	0.444338	0.080804

-0.020896	-0.444179	-0.895694	-0.175250

0.999776	-0.012374	-0.017188	-0.001771

0.000000	0.000000	0.000000	1.000000];


% apply transformation to the bone file (vertices)
vertex_data_transformed=applyTransformation(vertex_data,Transformation);

%save to a new obj file
newfilename='T2_to_T12_meter_T1CS.obj';
notes='The obj. file is generated in matlab with only vertex and face data.';

writeObj_vf(newfilename, vertex_data_transformed,face_data,notes);


