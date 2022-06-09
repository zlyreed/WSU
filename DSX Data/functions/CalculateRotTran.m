
% Upper: the transformation matrice of the upper bone (1X16), e.g. L1 to
% Lab
% Lower: the transformation matrice of the lower bone (1X16): e.g., Lab to
% L2
% Rot and Trans: Rotations(Rx,Ry,Rz in deg) and Translations(Tx,Ty,Tz)of the Upper
% bone (e.g., L1) wrt the lower bone (e.g., L2) in the lower bone's coordinate system (e.g., L2 CS)


function [Rot,Trans]=CalculateRotTran(Upper,Lower)  

if isnan(Upper)==1
   Upper2Lower=reshape(Lower,4,4);
else if isnan(Lower)==1
   Upper2Lower=reshape(Upper,4,4);
    else
        Upper2Lab=reshape(Upper,4,4);
        Lab2Lower=reshape(Lower,4,4);
        Upper2Lower=Lab2Lower*Upper2Lab;
    end
end




RPY_Upper_LowerCS = tr2rpy(Upper2Lower(1:3,1:3),'deg');  % angle of Rx, Ry, Rz
Translation_Upper_LowerCS=Upper2Lower(1:3,4)'; % translation X, Y, Z

Rot=RPY_Upper_LowerCS;
Trans=Translation_Upper_LowerCS;

end


