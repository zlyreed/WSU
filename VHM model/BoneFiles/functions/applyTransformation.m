function points_transformed=applyTransformation(points,Transformation)
% %output
% points_transformed: nX3;

% % Input 
% % 4X4 homogeneous transformation matrix
% Transformation=[-0.003448	-0.895853	0.444338	0.080804
% 
% -0.020896	-0.444179	-0.895694	-0.175250
% 
% 0.999776	-0.012374	-0.017188	-0.001771
% 
% 0.000000	0.000000	0.000000	1.000000];  % 4X4 transformation
% 
% % original points:nX3
% BoneCT_file=importdata('T1_meter.obj');
% T2T12CT_file_text=BoneCT_file.textdata(3:end,1); % remove the first two lines
% kv=find(strcmp(T2T12CT_file_text(:,1),'v')==1);
% points=BoneCT_file.data(kv,:);  % nX3 point cloud


% apply transformation to the bone point file
BoneCT_4xn=[points';ones(1,length(points))];  % matrix 4xn
BoneDesiredCS_4xn=Transformation*BoneCT_4xn;
points_transformed=BoneDesiredCS_4xn(1:3,:)';  % nX3


