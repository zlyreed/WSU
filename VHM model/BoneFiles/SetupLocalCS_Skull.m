clear all
close all
clc


%% Setup local (anatomical) CS for skull and mandible (jaw)
% In CT CS (unit: m)
% get skull CT bone
% Skullct_file=importdata('Skull_meter.obj');
% Skullct_file_text=Skullct_file.textdata(3:end,1); % start from the number line
% kv=find(strcmp(Skullct_file_text(:,1),'v')==1);
% Skullct_points=Skullct_file.data(kv,:);

Skull_obj='Skull_meter.obj';
vName='v';
fName='f';
[Skullct_points,Skullct_face]=readObj_vf(Skull_obj,vName,fName);

% get jaw CT bone
% Mandiblect_file=importdata('Mandible_meter.obj');
% Mandiblect_file_text=Mandiblect_file.textdata(3:end,1); % remove the first line
% kv=find(strcmp(Mandiblect_file_text(:,1),'v')==1);
% Mandiblect_points=Mandiblect_file.data(kv,:);

Mandible_obj='Mandible_meter.obj';
[Mandiblect_points,Mandiblect_face]=readObj_vf(Mandible_obj,vName,fName);

Xaxis=[0,0,0;0.2,0,0];
Yaxis=[0,0,0;0, 0.2,0];
Zaxis=[0,0,0;0,0,0.2];

figure (1)
scatter3(Skullct_points(:,1),Skullct_points(:,2),Skullct_points(:,3),'rx')
hold on
g0(1)=plot3(Xaxis(:,1),Xaxis(:,2),Xaxis(:,3),'r','linewidth',3);
g0(2)=plot3(Yaxis(:,1),Yaxis(:,2),Yaxis(:,3),'y','linewidth',3);
g0(3)=plot3(Zaxis(:,1),Zaxis(:,2),Zaxis(:,3),'g','linewidth',3);
legend(g0,'X axis','Y axis', 'Z axis')
title('The original skull (CT CS)')

axis equal


basion=[-0.000782793 -0.0331215 -0.327689 ];
opithion=[-0.00108851 0.00562938 -0.323186 ];
Skull_origin=mean([basion;opithion]);

ROrbit=[0.0448885 -0.106377 -0.348729 ];
LOrbit=[-0.0433662 -0.106077 -0.353744 ];
Orbit=mean([ROrbit;LOrbit]);

RTragion=[0.0513224 -0.0284215 -0.338214 ];
LTragion=[-0.0539197 -0.0308705 -0.345742 ];
Tragion=mean([RTragion;LTragion]);
OrbitTragionAngle=atan((Orbit(1,3)-Tragion(1,3))/(Orbit(1,2)-Tragion(1,2)));
OrbitTragionAngle_deg=OrbitTragionAngle/pi*180  % the Frankfort plane in CT CS

% Bony Landmarks
Lamdmarks_ct_points=[basion;opithion;ROrbit;LOrbit;RTragion;LTragion];


% Transform to the local (anatomical) Skull CS
SkullLocal_points_T=bsxfun(@minus,Skullct_points,[0,Skull_origin(1,2),Skull_origin(1,3)]); % move to the origin to the midpoint of basion and opithion
SkullLocal_points_RxRy=(roty(-pi/2)*rotx(-OrbitTragionAngle)*SkullLocal_points_T')'; % rotate about X and Y axis 
SkullLocal_points=(rotz(pi/2)*roty(-pi/2)*rotx(-OrbitTragionAngle)*SkullLocal_points_T')';  % rotate about Z axis  as well

% Transform to the local (anatomical) Skull CS
MandibleLocal_points_T=bsxfun(@minus,Mandiblect_points,[0,Skull_origin(1,2),Skull_origin(1,3)]); % move to the origin to the midpoint of basion and opithion
MandibleLocal_points=(rotz(pi/2)*roty(-pi/2)*rotx(-OrbitTragionAngle)*MandibleLocal_points_T')';  % rotate about Z axis  as well
 
figure (2)
scatter3(SkullLocal_points_T(:,1),SkullLocal_points_T(:,2),SkullLocal_points_T(:,3),'bx') %tranlstion only
hold on
g1(1)=plot3(Xaxis(:,1),Xaxis(:,2),Xaxis(:,3),'r','linewidth',3);
g1(2)=plot3(Yaxis(:,1),Yaxis(:,2),Yaxis(:,3),'y','linewidth',3);
g1(3)=plot3(Zaxis(:,1),Zaxis(:,2),Zaxis(:,3),'g','linewidth',3);
legend(g1,'X axis','Y axis', 'Z axis')
title('Translated (only) skull (origin is at the midpoint of basion and opithion')
axis equal

figure (3)
scatter3(SkullLocal_points(:,1),SkullLocal_points(:,2),SkullLocal_points(:,3),'rx') % skull in the local CS
hold on
scatter3(MandibleLocal_points(:,1),MandibleLocal_points(:,2),MandibleLocal_points(:,3),'gx')
g2(1)=plot3(Xaxis(:,1),Xaxis(:,2),Xaxis(:,3),'r','linewidth',3);
g2(2)=plot3(Yaxis(:,1),Yaxis(:,2),Yaxis(:,3),'y','linewidth',3);
g2(3)=plot3(Zaxis(:,1),Zaxis(:,2),Zaxis(:,3),'g','linewidth',3);
legend(g2,'X axis','Y axis', 'Z axis')
title('Translated and Rotated skull (origin is at the midpoint of basion and opithion')
axis equal

Tragion_LocalT=bsxfun(@minus,Tragion,[0,Skull_origin(1,2),Skull_origin(1,3)]);
Tragion_Local=(rotz(pi/2)*roty(-pi/2)*rotx(-OrbitTragionAngle)*Tragion_LocalT')';

Orbit_LocalT=bsxfun(@minus,Orbit,[0,Skull_origin(1,2),Skull_origin(1,3)]);
Orbit_Local=(rotz(pi/2)*roty(-pi/2)*rotx(-OrbitTragionAngle)*Orbit_LocalT')';


% check the Frankfort plane
OrbitTragionAngle_Local=-atan((Orbit_Local(1,2)-Tragion_Local(1,2))/(Orbit_Local(1,1)-Tragion_Local(1,1)))/pi*180 % check the current Frankfort plane angle

%  dlmwrite('Mandible_LocalCS.txt',MandibleLocal_points)

%% bony landmarks 
SkullLandmarks_LocalCS={'','X','Y','Z'};
SkullLandmarks_LocalCS{1,1}='in SkullCS';
SkullLandmarks_LocalCS{2,1}='basion';
SkullLandmarks_LocalCS{3,1}='opithion';
SkullLandmarks_LocalCS{4,1}='ROrbit';
SkullLandmarks_LocalCS{5,1}='LOrbit';
SkullLandmarks_LocalCS{6,1}='RTragion';
SkullLandmarks_LocalCS{7,1}='LTragion';

LamdmarksLocal_points_T=bsxfun(@minus,Lamdmarks_ct_points,[0,Skull_origin(1,2),Skull_origin(1,3)]); % move to the origin to the midpoint of basion and opithion
LamdmarksLocal_points=(rotz(pi/2)*roty(-pi/2)*rotx(-OrbitTragionAngle)*LamdmarksLocal_points_T')';  % rotate about Z axis  as well
LamdmarksLocal_points_cell=num2cell(LamdmarksLocal_points);

SkullLandmarks_LocalCS(2:7,2:4)=LamdmarksLocal_points_cell;

%check
mark0_origin=mean(LamdmarksLocal_points(1:2,1:2)) % the midpoint of first two landmakrs should be (0,0)

%save
save('SkullLandmarks_LocalCS.mat','SkullLandmarks_LocalCS');

%% write into a new obj
notes='The obj. file is generated in matlab with only vertex and face data.';
Skull_obj_new='Skull_meter_LocalCS.obj';
Mandible_obj_new='Mandible_meter_LocalCS.obj';

% writeObj_vf(Skull_obj_new,SkullLocal_points,Skullct_face,notes);
% writeObj_vf(Mandible_obj_new,MandibleLocal_points,Mandiblect_face,notes);

% 
% %% write into txt files 
% % % dlmwrite('Skull_Translated.txt',SkullLocal_points_T)
% % % dlmwrite('Skull_TRxRy.txt',SkullLocal_points_RxRy)
% % 
%  dlmwrite('Skull_LocalCS.txt',SkullLocal_points)
