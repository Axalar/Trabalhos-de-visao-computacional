% Auto-generated by cameraCalibrator app on 19-Jun-2018
%-------------------------------------------------------
function CP = CameraCalibrator()
% Define images to process
imageFileNames = {'/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/1.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/2.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/3.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/4.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/5.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/6.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/7.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/8.jpeg',...
    '/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/9.jpeg',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
,
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 25;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', []);

% View reprojection errors
%h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
%h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
originalImage = imread(imageFileNames{1});
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
CP =  cameraParams;
end