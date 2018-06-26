clear all
close all
clc

%% Camera calibration

% Selecting images for calibration
imageFileNames = {};
for k=1:38
    
    imageFileNames = {imageFileNames{:}, ['dataset/IMG' num2str(k) '.jpg']};
    
end

% Selecting video
videoFileName = 'dataset/VID.mp4';

% Checkboard square side size
squareSize = 25;

% Finding camera parameters
[cameraParams, ~, estimationErrors] = calCam(squareSize, 'image', imageFileNames);

%% Solid projection

% Load image
im = iread(imageFileNames{30}, 'double');
imgs = rgb2gray(im); % para 1 imagem


% Corrects radial distortion
[imud,newOrigin] = undistortImage(im,cameraParams,'OutputView','full');

% Finds chackerboard points
[imagePoints,boardSize,~] = detectCheckerboardPoints(imud);

% Calculates camera matrix
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams);
camMatrix = cameraMatrix(cameraParams, rotationMatrix, translationVector)';

for i=1:10 % para usar 1 imagens

    % Generate object spatial description
    [worldSolidPoints, faces] = buildSolid(2,50,'trans', [50,50,0],...
                                            'rotX', i*0, 'rotY', i*0);

    % 2-D projection of the object's vertices
    imageSolidPoints = camMatrix*worldSolidPoints;
    imageSolidPoints = [imageSolidPoints(1,:)./imageSolidPoints(end,:);...
        imageSolidPoints(2,:)./imageSolidPoints(end,:);...
        imageSolidPoints(3,:)./imageSolidPoints(end,:)];

    for j=1:size(faces,1)

        polygon.x = imageSolidPoints(1,faces(j,:));
        polygon.y = imageSolidPoints(2,faces(j,:));
        polygon.r = j/size(faces,1);
        polygon.g = 0.2;
        polygon.b = 1-j/size(faces,1);
        polygon.alpha = 1;
        polygons(j) = polygon;

    end

    totalRows = size(imud,1);
    totalCols = size(imud,2);
    background_r = 0;
    background_g = 0;
    background_b = 0;

    % Generating image of the 2-D projection of the object
    solidImage = zeros(totalRows, totalCols, 3);
    solidImage(:,:,1) = background_r;
    solidImage(:,:,2) = background_g;
    solidImage(:,:,3) = background_b;

    pane_size = totalRows * totalCols;

    for k = 1 : length(polygons)

      polygon = polygons(k);
      thismask = poly2mask(polygon.x, polygon.y, totalRows, totalCols);
      thismask_idx = find(thismask);
      solidImage(thismask_idx + 0 * pane_size) = solidImage(thismask_idx + 0 * pane_size)...
          .* (1- polygon.alpha) + polygon.r .* polygon.alpha;   %red plane
      solidImage(thismask_idx + 1 * pane_size) = solidImage(thismask_idx + 1 * pane_size)...
          .* (1- polygon.alpha) + polygon.g .* polygon.alpha;   %green plane
      solidImage(thismask_idx + 2 * pane_size) = solidImage(thismask_idx + 2 * pane_size)...
          .* (1- polygon.alpha) + polygon.b .* polygon.alpha;   %blue plane

    end

    % Creating mask
    mask = rgb2gray(solidImage) == 0;
    mask = repmat(mask,1,1,3);

    % Composing output image
    out = imud .* mask;
    out = out + solidImage;

    imshow(out)
        
end


