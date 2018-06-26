function [cameraParams, imagesUsed, estimationErrors] = calCam(squareSize, varargin)

opt.image = {};
opt.video = {};
opt = tb_optparse(opt, varargin);

if numel(opt.image) > 0
    
    % Detect checkerboards in images
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(opt.image);
    
elseif numel(opt.video) > 0
    
    % Detect checkerboard in first frames of video
    vid = VideoReader(opt.video{1});
    
    for k = 1:40
        f(:,:,:,k) = read(vid,k);
%         im1 = im2double(f(:,:,:,k));
%         imshow(im1)
    end
    
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(f);
    
end

% Generate world coordinates of the corners of the squares
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints,...
    worldPoints, 'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', []);

end