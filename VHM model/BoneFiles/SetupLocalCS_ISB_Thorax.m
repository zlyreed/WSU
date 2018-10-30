% setup Thorax CS (ISB; Wu-2005)
clear all
close all
clc

% Thorax CS:
% The origin: coincident with IJ.
% Y: The line connecting the midpoint between PX and T8 and the midpoint between IJ and C7, pointing upward.
% Z: The line perpendicular to the plane formed by IJ, C7, and the midpoint between PX and T8,pointing to the right.
% X: The common line perpendicular to the Z- and Y-axis, pointing forwards.

% axis cooridinates
T1CS_X=[0 0 0;0.1,0,0];
T1CS_Y=[0 0 0;0,0.1,0];
T1CS_Z=[0 0 0;0,0,0.1];

T1CS=[T1CS_X;T1CS_Y;T1CS_Z];

% landmarks in T1 CS
C7=[-0.0529946 -0.011114 -0.00383815];
T8=[-0.00182668 -0.226247 0.00186527];
IJ=[0.0778201 -0.0194623 0.00461227];
PX=[0.217731 -0.168973 0.00933912];

Mid_PXT8=mean([PX;T8]);
Mid_IJC7=mean([IJ;C7]);

ThoraxPoints=[C7;T8;Mid_PXT8];
ThoraxBox=[IJ;C7;PX;T8];

% desired Y aixs
Y_line=[Mid_PXT8;Mid_IJC7];

Vector_Y=Mid_IJC7-Mid_PXT8;
Yaxis_XYangle=atan(Vector_Y(1,2)/Vector_Y(1,1))/pi()*180; % the desired angle of Y axis

coeff= princomp(ThoraxPoints);  %PCA-determined XY plane: the plane formed by IJ, C7, and the midpoint between PX and T8
RPY_L_deg = tr2rpy(coeff, 'deg');
RPY_L_rad = tr2rpy(coeff);

% Transformation (set up the XY plane based on PCA results of thorax points)
% rotate first and then translate (looks good)
ThoraxCS_alt=bsxfun(@plus,(rotz(RPY_L_rad(1,3))*roty(RPY_L_rad(1,2))*rotx(RPY_L_rad(1,1))*T1CS')',IJ);
Y_angle_RT=atan((ThoraxCS_alt(4,2)-ThoraxCS_alt(3,2))/(ThoraxCS_alt(4,1)-ThoraxCS_alt(3,1)))/pi()*180;


diff_YAngle=(Yaxis_XYangle-Y_angle_RT+180)/180*pi();
ThoraxCS_alt_final=bsxfun(@plus,(rotz(RPY_L_rad(1,3)+diff_YAngle)*roty(RPY_L_rad(1,2))*rotx(RPY_L_rad(1,1))*T1CS')',IJ);

%% RESULTS: in opensim, create aux_Thoraxjnt (in T1 parent CS)
aux_Thoraxjnt_origin_inT1CS=IJ
aux_Thoraxjnt_orientation_inT1CS_rad=[RPY_L_rad(1,1),RPY_L_rad(1,2),RPY_L_rad(1,3)+diff_YAngle]
aux_Thoraxjnt_orientation_inT1CS_deg=[RPY_L_rad(1,1),RPY_L_rad(1,2),RPY_L_rad(1,3)+diff_YAngle]/pi()*180


%%
% Check in OpenSim (Thorax CS: in T1 parent CS--> move origin to IJ--> rotation based
% on coeff(RPY_L_rad))
Y1_OP=[0.13759 0.0606872 0.00652688 ];
IJ_new=[0.0778201 -0.0194623 0.00461227 ];

Delta_OP=Y1_OP-IJ_new;
Y_angle_OpenSimT1=atan(Delta_OP(1,2)/Delta_OP(1,1))/pi()*180;

%check in spine CS (Y: vertical up)
Point1=[0.0629808 0.0423388 0.0019348 ];
Point2=[0.0560511 -0.0573849 0.00461227 ];
Delta_P12=Point1-Point2;
Y_angle_OpenSimSpine=atan(Delta_P12(1,2)/Delta_P12(1,1))/pi()*180;


%% plot
figure (1)
% T1 CS
plot3(T1CS_X(:,1),T1CS_X(:,2),T1CS_X(:,3),'r','linewidth',1)
hold on
plot3(T1CS_Y(:,1),T1CS_Y(:,2),T1CS_Y(:,3),'y','linewidth',1)
plot3(T1CS_Z(:,1),T1CS_Z(:,2),T1CS_Z(:,3),'g','linewidth',1)

plot3(ThoraxBox(:,1),ThoraxBox(:,2),ThoraxBox(:,3),'b')
plot3(Y_line(:,1),Y_line(:,2),Y_line(:,3),'y','linewidth',3)

% after transformation (auxThorax CS)
plot3(ThoraxCS_alt_final(1:2,1),ThoraxCS_alt_final(1:2,2),ThoraxCS_alt_final(1:2,3),'r','linewidth',3);
plot3(ThoraxCS_alt_final(3:4,1),ThoraxCS_alt_final(3:4,2),ThoraxCS_alt_final(3:4,3),'y','linewidth',3);
plot3(ThoraxCS_alt_final(5:6,1),ThoraxCS_alt_final(5:6,2),ThoraxCS_alt_final(5:6,3),'g','linewidth',3);

plot3(IJ(1,1),IJ(1,2),IJ(1,3),'r*')

axis equal
xlabel('X')
ylabel('Y')
zlabel('Z')


