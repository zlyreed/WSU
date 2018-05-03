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
    - save as a new .obj file
- Obtain the transformation for T1 (from the CT global CS to the T1 local CS; both models are provided by CJ): the same transformation will be applied to other skeletal structure below T1 to mantiain the orignal posture in CT images (we don't know the real their neutral postures)
  - In OpenSim, import both T1 bone models (in the CT CS and the local CS) and identify same bony landmarks in the same order
  - In MatLab, run "absoluteOrientationQuaternion.m" funtion to get the transformation (inputs: at least four corresponding points in two different CSs)
