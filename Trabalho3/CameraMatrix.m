function C = CameraMatrix(newImage)
CP =  CameraCalibrator();
%Undistort image.
img = undistortImage(newImage, CP);
squareSize = 25;
% Find reference object in new image.
[ImagePoints, BoardSize] = detectCheckerboardPoints(img);
% Compute new extrinsics.
WorldPointsNW=generateCheckerboardPoints(BoardSize,squareSize);

[R, t] = extrinsics(ImagePoints,WorldPointsNW,CP);
%focalMatrix = [CP.FocalLength(1) zeros(1,3); 0 CP.FocalLength(1) 0 0; 0 0 1 0];
%ksi = ([R t';zeros(1,3) 1])^1; 
%K = CP.IntrinsicMatrix * focalMatrix;

C = cameraMatrix(CP,R,t)
C=C';


%C = K * ksi;
end