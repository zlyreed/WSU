clear all
close all
clc

%% Setup local CS for Clavicle bones
% get clavicle bone in T1 CS
ClavicleL_obj='Left_Clavicle_meter_T1CS.obj';
ClavicleR_obj='Right_Clavicle_meter_T1CS.obj';
vName='v';
fName='f';
[ClavicleL_t1_points,ClavicleL_t1_face]=readObj_vf(ClavicleL_obj,vName,fName);
[ClavicleR_t1_points,ClavicleR_t1_face]=readObj_vf(ClavicleR_obj,vName,fName);

% landmark SC in T1 CS (m)
Sternoclaviculare_L=[0.0688528 -0.0197483 -0.021618];
Sternoclaviculare_R=[0.0721 -0.013471 0.0297133];

ClavicleL_origin=Sternoclaviculare_L;
ClavicleR_origin=Sternoclaviculare_R;

T1_tilting_M020=-0.552089685566 ; % -31.6324088956378 deg

ClavicleL_Local_T=bsxfun(@minus,ClavicleL_t1_points,ClavicleL_origin); % move to the origin to the midpoint of basion and opithion
ClavicleL_Local_points=(rotz(-T1_tilting_M020)*ClavicleL_Local_T')';  %rotate wrt Z axis (not used)
 
ClavicleR_Local_T=bsxfun(@minus,ClavicleR_t1_points,ClavicleR_origin); % move to the origin to the midpoint of basion and opithion
ClavicleR_Local_points=(rotz(-T1_tilting_M020)*ClavicleR_Local_T')';  %rotate wrt Z axis (not used)


% plot to check
figure (1)
scatter3(ClavicleL_t1_points(:,1),ClavicleL_t1_points(:,2),ClavicleL_t1_points(:,3),'g')
hold on
scatter3(ClavicleL_Local_points(:,1),ClavicleL_Local_points(:,2),ClavicleL_Local_points(:,3),'r')
axis equal

scatter3(ClavicleR_t1_points(:,1),ClavicleR_t1_points(:,2),ClavicleR_t1_points(:,3),'b')
scatter3(ClavicleR_Local_points(:,1),ClavicleR_Local_points(:,2),ClavicleR_Local_points(:,3),'m')

%%  write the obj with only translation (use this one)
notes='The obj. file is generated in matlab with only vertex and face data.';
ClavicleL_objT_new='Left_Clavicle_meter_LocalCST.obj';
ClavicleR_objT_new='Right_Clavicle_meter_LocalCST.obj';

writeObj_vf(ClavicleL_objT_new,ClavicleL_Local_T,ClavicleL_t1_face,notes);
writeObj_vf(ClavicleR_objT_new,ClavicleR_Local_T,ClavicleR_t1_face,notes);



% %% write into a new obj
% 
% ClavicleL_obj_new='Left_Clavicle_meter_LocalCS.obj';
% ClavicleR_obj_new='Right_Clavicle_meter_LocalCS.obj';
% 
% % writeObj_vf(ClavicleL_obj_new,ClavicleL_Local_points,ClavicleL_t1_face,notes);
% % writeObj_vf(ClavicleR_obj_new,ClavicleR_Local_points,ClavicleR_t1_face,notes);

