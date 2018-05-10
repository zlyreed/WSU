%%obtain the tranformation matrix between the same bone in two different
%%coordinate system (e.g., from the CT CS to the local CS): 
% ---1. directly align two obj models using "absoluteOrientationQuaternion":  it didnt work well with the T1 bone models (two models have the same amount of points,
%%but maybe the order of points are not consistent).
% ---2. could use OpenSim (pick corresponding bony marks) and Matlab: seems too much work;
% ---3. Use MeshLab "Align" feature to get the transformation matrix (here): check by plotting them out, and the transformation works well.

clear all
close all
clc

%% get the file in CT CS (unit: m)
BoneCT_file=importdata('T1_meter.obj');
BoneCT_file_text=BoneCT_file.textdata(3:end,1); % remove the first line
kv=find(strcmp(BoneCT_file_text(:,1),'v')==1);
BoneCT_points=BoneCT_file.data(kv,:);

% define axis lines
Xaxis=[0,0,0;0.05,0,0];
Yaxis=[0,0,0;0, 0.05,0];
Zaxis=[0,0,0;0,0,0.05];

figure (1)
hold on
g0(1)=plot3(Xaxis(:,1),Xaxis(:,2),Xaxis(:,3),'r','linewidth',3);
g0(2)=plot3(Yaxis(:,1),Yaxis(:,2),Yaxis(:,3),'y','linewidth',3);
g0(3)=plot3(Zaxis(:,1),Zaxis(:,2),Zaxis(:,3),'g','linewidth',3);
g0(4)=scatter3(BoneCT_points(:,1),BoneCT_points(:,2),BoneCT_points(:,3),'rx');


%% get the bone file in local CS
BoneLocal_file=importdata('T1_localCS.obj');
BoneLocal_file_text=BoneLocal_file.textdata(6:end,1); % remove the first line
kv=find(strcmp(BoneLocal_file_text(:,1),'v')==1);
BoneLocal_points=BoneLocal_file.data(kv,:);

% define axis lines
Xaxis=[0,0,0;0.05,0,0];
Yaxis=[0,0,0;0, 0.05,0];
Zaxis=[0,0,0;0,0,0.05];

figure (1)
g0(5)=scatter3(BoneLocal_points(:,1),BoneLocal_points(:,2),BoneLocal_points(:,3),'bx');
view(3)

legend(g0,'X axis','Y axis', 'Z axis','BoneInCTCS','BoneInLocalCS')
title('The bone point cloud in CT and Local CS)')
axis equal

%% Import MeshLab .aln file
filename = 'T1_alignment.aln';
Transformation=[-0.003448	-0.895853	0.444338	0.080804
-0.020896	-0.444179	-0.895694	-0.175250
0.999776	-0.012374	-0.017188	-0.001771
0.000000	0.000000	0.000000	1.000000];

BoneCT_4xn=[BoneCT_points';ones(1,length(BoneCT_points))];
BoneDesiredCS_4xn=Transformation*BoneCT_4xn;

Bone_DesiredCS=BoneDesiredCS_4xn(1:3,:)';

figure (1)
scatter3(Bone_DesiredCS(:,1),Bone_DesiredCS(:,2),Bone_DesiredCS(:,3),'gx');

    


