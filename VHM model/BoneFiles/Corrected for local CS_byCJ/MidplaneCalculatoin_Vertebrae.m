% Read the norm file (eg: c1.asc),from all the vertices coordinates, find
% the center of each vertebra
%input: norm file name (eg:c1)
%output: the X Y Z coordinates of the geometric center of each vertebra
%defined as the mean of all vertices X Y and Z coordinates.
%And the YZ plane defined from principle component analysis. Assuming
%equal point mass at each vertices.

clc
hold off
clear

fid=fopen('C7.asc','r');
%Eliminates "NORM_ASCII" String
junk=fscanf(fid,'%s',[1,1]);
number=fscanf(fid,'%g %g',[8,1]);
%number of vertices is number(1,1)
vertices=fscanf(fid,'%g %g',[6,number(1,1)]);
%First three columns are X, Y, and Z. The following columns give the normal
%vector which is not used

fclose(fid);

m=length(vertices);

centroid(1,1)=sum(vertices(1,:))/m;
centroid(1,2)=sum(vertices(2,:))/m;
centroid(1,3)=sum(vertices(3,:))/m;

%Principle component analysis
XYZ=vertices(1:3,:)';

% coeff columns define vector of principle axis
[coeff,score,eig]=princomp(XYZ);

%Finds column designating x-axis principle component by having max value
%in x direction. Saves the column location
xaxcol=find(coeff(1,:)==max(coeff(1,:)));
% finds constant for plane of the form a*x+b*y+c*z=constant

constant=dot(coeff(:,xaxcol),centroid);
%%Creates plane using the equation determined above where a b c are defined
%%by the normal vector
n=1;
for z=min(XYZ(:,3))-2:(max(XYZ(:,3))-min(XYZ(:,3)))/100:max(XYZ(:,3))+2
    for y=min(XYZ(:,2))-2:(max(XYZ(:,2))-min(XYZ(:,2)))/100:max(XYZ(:,2))+2
        x=(constant-coeff(3,xaxcol)*z-coeff(2,xaxcol)*y)/coeff(1,xaxcol);
    plane(:,n)=[x,y,z];
    n=n+1;
    end
end

%% If the principal axes are very different from the plane created by
% landmarks on the bone, a sphere is taken out of the bone, centered
% around the bone's centroid

% Determine the angle of the principle axis with respect to imported
% coordinates in the XY-plane.
yMaxInd=find(plane(2,:)==max(plane(2,:)));
yMinInd=find(plane(2,:)==min(plane(2,:)));
pcaPlane=atand((plane(1,yMaxInd)-plane(1,yMinInd))/(plane(2,yMaxInd)-plane(2,yMinInd)));

% Determine the angle of the line in the XY-plane created by the most
% anterior and posterior points, with respect to imported coordinates.
yMaxInd=find(XYZ(:,2)==max(XYZ(:,2)));
yMinInd=find(XYZ(:,2)==min(XYZ(:,2)));
locPlane=atand((XYZ(yMaxInd,1)-XYZ(yMinInd,1))/(XYZ(yMaxInd,2)-XYZ(yMinInd,2)));

% Distance between the most anterior and posterior points on the y-axis.
postAntDistance=(XYZ(yMaxInd,2)-XYZ(yMinInd,2));

% Indexes whether or not these planes are greater than 5 degrees apart.
if abs(pcaPlane - locPlane) > 5    angleDiff=1; 
else
    angleDiff=0;
end

postAntPerc=0.5; % Default percentage of posterior-anterior length used

% Iterates the percentage of the posterior-anterior distance used as the 
% radius outside of which points are discounted until the pca plane and the
% landmark plane fall within 3 degrees of one another.
while angleDiff==1
    %% Only use points in a sphere around the centroid
    k=1;
    voidIndex=[]; % Define index array
    for j=1:length(XYZ)
        % If the point lays outside the sphere, it is noted. The radius of
        % this radius is defined using the most posterior and anterior
        % points on the bone.
        sphereCreate=(XYZ(j,1)-centroid(1,1))^2 + (XYZ(j,2)-centroid(1,2))^2 + (XYZ(j,3)-centroid(1,3))^2;
        if sphereCreate>(postAntPerc*postAntDistance)^2
            voidIndex(k)=j; % Indexes points that fall outside the sphere
            k=k+1;
        end
    end
    
    % Flip indices to start with the largest first, so points' indices do
    % not change within the array.
    voidIndex=fliplr(voidIndex);
    for j=voidIndex;
        XYZ(j,:)=[]; % Removes indexed points 
%         vertices(:,j)=[]; % Only graphs points used in pca
    end
    %%
    % coeff columns define vector of principle axis
    [coeff,score,eig]=pca(XYZ);

    % Finds column designating x-axis principle component by having max value
    % in x direction. Saves the column location
    xaxcol=find(coeff(1,:)==max(coeff(1,:)));
    % finds constant for plane of the form a*x+b*y+c*z=constant

    constant=dot(coeff(:,xaxcol),centroid);
    % Create a plane using the equation determined above where a b c are defined
    % by the normal vector
    n=1;
    for z=min(XYZ(:,3))-2:(max(XYZ(:,3))-min(XYZ(:,3)))/100:max(XYZ(:,3))+2
        for y=min(XYZ(:,2))-2:(max(XYZ(:,2))-min(XYZ(:,2)))/100:max(XYZ(:,2))+2
            x=(constant-coeff(3,xaxcol)*z-coeff(2,xaxcol)*y)/coeff(1,xaxcol);
            plane(:,n)=[x,y,z];
            n=n+1;
        end
    end
    
    % Determine the new angle of the principle axis in the XY-plane.
    yMaxInd=find(plane(2,:)==max(plane(2,:)));
    yMinInd=find(plane(2,:)==min(plane(2,:)));
    pcaPlane=atand((plane(1,yMaxInd)-plane(1,yMinInd))/(plane(2,yMaxInd)-plane(2,yMinInd)));
    
    display('Axis adjustment made')
    display(['Radius percentage of posterior-anterior length: ' num2str(postAntPerc)])
    
    % Determine if the principle axis and the posterior-anterior line, both
    % in the XY-plane, fall within 3 degrees of one another.
    if abs(pcaPlane - locPlane) > 3
        angleDiff=1;
        postAntPerc=postAntPerc-0.1;
        XYZ=vertices(1:3,:)';
    else
        angleDiff=0;
    end
end

% Graphs bone with principle axis plane
scatter3(plane(1,:),plane(2,:),plane(3,:),4)
hold on
scatter3(vertices(1,:),vertices(2,:),vertices(3,:),3)
scatter3(centroid(1,1),centroid(1,2),centroid(1,3),80)
view(coeff(:,3))
view(0,90)