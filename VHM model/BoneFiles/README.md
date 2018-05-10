## The bone files are from AV and her group 
### Work done at WSU (bone models segmented in 3D doctor)
- File types: .obj or .asc
- Unit: mm 
- Cooridinate System (CS)
  - They are in CT gobal CS originally;
  - CJ appiled a matlab code (PCA related?) to make some bones into their local CS (folder "Corrected for local CS"): C1-T2

### Work done by LZ
- Scale the bone files into meter (use .obj files) 
  - Use a free software [MeshLab](http://www.meshlab.net/), check out the [tutorial](http://www.cse.iitd.ac.in/~mcs112609/Meshlab%20Tutorial.pdf).
    - Scale: in MeshLab, the transformations can be found under FILTERS / NORMALS, CURVATURES AND ORIENTATION / TRANSFORM… 
    - Save as new .obj files (unit: meter)
- Obtain the transformation for T1 (from the CT global CS to T1 local CS; both models are provided by CJ): 
  - Use OpenSim and Matlab (note: errors on manually picked corresponding bony landmarks)
    - In OpenSim, import both T1 bone models (in the CT CS and the local CS) and identify same bony landmarks in the same order
    - In MatLab, run "absoluteOrientationQuaternion.m" funtion to get the transformation (inputs: at least four corresponding points in two different CSs)
  - Use MeshLab Align feature
    - Load two T1 models
    - Go to "Edit"--> "Align"-->  pick T1_localCS model as ""glue mesh here" to serve as a base --> pick T1_CTCS model and click "Point Based Glueing" --> double click to select corresponding points on both models --> "process" --> "File"/"Save Projec"/save as "Align Project (*.aln)"
    - From T1_meter.obj (CT CS) to T1.obj (local CS); transformation matrix:
         [-0.003448 -0.895853 0.444338 0.080804;
         -0.020896 -0.444179 -0.895694 -0.175250;
         0.999776 -0.012374 -0.017188 -0.001771; 
         0.000000 0.000000 0.000000 1.000000] 
- Apply the same transformation (from CT global CS to T1 local CS) to other bony structures below T1 to mantiain the original posture in CT images (we don't know their real  neutral postures)
