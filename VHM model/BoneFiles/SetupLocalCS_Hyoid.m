clear all
close all
clc

%% Setup local CS for hyoid bone
% get hyoid CT bone
Hyoid_obj='Hyoid_meter.obj';
vName='v';
fName='f';
[Hyoidct_points,Hyoidct_face]=readObj_vf(Hyoid_obj,vName,fName);

% Hyoidct_file=importdata('Hyoid_meter.obj');
% Hyoidct_file_text=Hyoidct_file.textdata(2:end,1); % remove the first line
% kv=find(strcmp(Hyoidct_file_text(:,1),'v')==1);
% Hyoidct_points=Hyoidct_file.data(kv,:);

Hyoid_antsup=[-0.00324444 -0.0680196 -0.255097];
Hyoid_pos1=[0.0225773 -0.0391616 -0.253917 ];
Hyoid_pos2=[-0.0288699 -0.0409957 -0.251921 ];

Lamdmarks_ct_points=[Hyoid_antsup;Hyoid_pos1;Hyoid_pos2];


Hyoid_origin=Hyoid_antsup;
Hyoid_pos=mean([Hyoid_pos1;Hyoid_pos2]);
Hyoid_antposAngle=atan((Hyoid_pos(1,3)-Hyoid_antsup(1,3))/(Hyoid_pos(1,2)-Hyoid_antsup(1,2)));
Hyoid_antposAngle_deg=Hyoid_antposAngle/pi*180

% Transform to the local (anatomical) hyoid CS
HyoidLocal_points_T=bsxfun(@minus,Hyoidct_points,[Hyoid_origin(1,1),Hyoid_origin(1,2),Hyoid_origin(1,3)]); % move to the origin to Hyoid_antsup
HyoidLocal_points=(rotz(pi/2)*roty(-pi/2)*rotx(-Hyoid_antposAngle)*HyoidLocal_points_T')';  % rotate about X,Y and Z axis  as well

%% bony landmarks

HyoidLandmarks_LocalCS={'','X','Y','Z'};
HyoidLandmarks_LocalCS{1,1}='in HyoidCS';
HyoidLandmarks_LocalCS{2,1}='Hyoid_antsup';
HyoidLandmarks_LocalCS{3,1}='Hyoid_pos1';
HyoidLandmarks_LocalCS{4,1}='Hyoid_pos2';


LamdmarksLocal_points_T=bsxfun(@minus,Lamdmarks_ct_points,[Hyoid_origin(1,1),Hyoid_origin(1,2),Hyoid_origin(1,3)]); % move to the origin to the midpoint of basion and opithion
LamdmarksLocal_points=(rotz(pi/2)*roty(-pi/2)*rotx(-Hyoid_antposAngle)*LamdmarksLocal_points_T')';  % rotate about Z axis  as well
LamdmarksLocal_points_cell=num2cell(LamdmarksLocal_points);

HyoidLandmarks_LocalCS(2:4,2:4)=LamdmarksLocal_points_cell;

%save
save('HyoidLandmarks_LocalCS.mat','HyoidLandmarks_LocalCS');
%% write into a new obj file
notes='The obj. file is generated in matlab with only vertex and face data.';
Hyoid_obj_new='Hyoid_meter_LocalCS3.obj';

%writeObj_vf(Hyoid_obj_new,HyoidLocal_points,Hyoidct_face,notes);

% dlmwrite('Hyoid_LocalCS.txt',HyoidLocal_points)