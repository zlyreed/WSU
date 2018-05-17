## The bone files are from AV and her group 
### Work done at WSU (bone models segmented in 3D doctor)
- File types: .obj or .asc
- Unit: mm 
- Cooridinate System (CS)
  - They are in CT gobal CS originally;
  - CJ appiled a matlab code (using PCA) to make some bones (C1 to T2) into their local CS (under foler "\Corrected for local CS_byCJ") 

### Work done by LZ
- Scale the bone files into meter (use .obj files) 
  - Use a free software [MeshLab](http://www.meshlab.net/), check out the [tutorial](http://www.cse.iitd.ac.in/~mcs112609/Meshlab%20Tutorial.pdf).
    - Scale: in MeshLab, the transformations can be found under FILTERS / NORMALS, CURVATURES AND ORIENTATION / TRANSFORM… 
    - Save as new .obj files (unit: meter)
- Obtain the transformation for T1 (from the CT global CS to T1 local CS; both models are provided by CJ): 
  - Use OpenSim and Matlab (note: errors on manually picked corresponding bony landmarks)
    - In OpenSim, import both T1 bone models (in the CT CS and the local CS) and identify same bony landmarks in the same order
    - In MatLab, run "absoluteOrientationQuaternion.m" funtion to get the transformation (inputs: at least four corresponding points in two different CSs)
  - Use MeshLab (Mac 64bit v1.3.3) "Align" feature ([YouTube tutorial](https://www.youtube.com/watch?v=4g9Hap4rX0k))
    - Load two T1 models
    - Go to "Edit"--> "Align"-->  pick T1_localCS model as ""glue mesh here" to serve as a base --> pick T1_CTCS model and click "Point Based Glueing" --> double click to select corresponding points on both models --> "process" --> "File"/"Save Projec"/save as "Align Project (*.aln)": [T1_alignment.aln](T1_alignment.aln)
    - From T1_meter.obj (CT CS) to T1.obj (local CS): 
      - Transformation matrix= (-0.003448 -0.895853 0.444338 0.080804;-0.020896 -0.444179 -0.895694 -0.175250;0.999776 -0.012374 -0.017188 -0.001771; 0.000000 0.000000 0.000000 1.000000).
      - Angles (deg; X,Y,Z)=91.0993   26.3810   90.2205; Translations (m;X,Y,Z)=0.0808   -0.1752   -0.0018.
    - Test the transformation using [testTransformation_sameBone.m](testTransformation_sameBone.m)
    
- Apply the same transformation (from CT global CS to T1 local CS) to other bony structures below T1 to mantiain the original posture in CT images (we don't know their real  neutral postures)
  - T2 to T12: use the matlab code [Obj_TransformAndSave.m](Obj_TransformAndSave.m), which calls functions [readObj_vf.m](functions/readObj_vf.m), [applyTransformation.m](functions/applyTransformation.m), and [writeObj_vf.m](functions/writeObj_vf.m) --> output a new obj file in T1 local CS (T2_to_T12_meter_T1CS.obj)
  - Similarly, transformed L1_to_L5, Clavicles, Scapulas,Rib and Pelvis (such as Ribs_meter.obj, Right_Clavicle_meter.obj and etc.) into the T1 local CS (use matlabcode [Obj_TransformAndSave_multipleFiles.m](Obj_TransformAndSave_multipleFiles.m), which calls the same three functions as above)
