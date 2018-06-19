newImage = imread('/home/hzm/Área de Trabalho/Visao Computacional/Trabalho3/dataset/1.jpeg');
C = CameraMatrix(newImage);
Points3D = C*[0;0;0;1];
Points2D = [];
Points2D(1) = Points3D(1)/Points3D(3);
Points2D(2) = Points3D(2)/Points3D(3);
idisp(newImage);
hold on;
plot(Points2D(1), Points2D(2), 'r*', 'LineWidth', 2, 'MarkerSize', 5);
