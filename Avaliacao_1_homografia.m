%%---------------------------------
% Copyright (C) 2017-2018, by Marcelo R. Petry
% This file is distributed under the MIT license
% 
% Copyright (C) 2017-2018, by Marcelo R. Petry
% Este arquivo √© distribuido sob a licen√ßa MIT
%%---------------------------------

%%---------------------------------
% BLU3040 - Visao Computacional em Robotica
% Avaliacao 1 - Homografia: Imagens panoramicas
% Requisitos:
%   MATLAB
%   Machine Vision Toolbox 
%       P.I. Corke, ‚ÄúRobotics, Vision & Control‚Ä?, Springer 2011, ISBN 978-3-642-20143-1.
%       http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox
%%---------------------------------

%%---------------------------------
%Objetivo 
%Nas aulas anteriores aprendemos que se a homografia entre duas
%imagens e conhecida podemos projetar uma das imagens no mesmo referencial
%que a outra. As imagens continham um plano, e somente a parte planar era
%alinhada de maneira correta. Acontece que se capturarmos uma imagem de uma
%cena, rotacionarmos a c√¢mera e tirarmos uma segunda imagem da mesma cena
%as duas imagens tamb√©m estar√£o relacionadas por uma matriz de homografia.
%Desta forma, voce pode instalar sua c√¢mera em um e tirar uma fotografia.
%Girar a c√¢mera sob o eixo vertical e tirar outra fotografia. Estas duas
%imagens completamente arbitrarias est√£o relacionadas por homografia, e por
%isso compartilham regi√µes que podem ser alinhadas e combinadas para criar
%uma fotografia panoramica. Neste trabalho o objetivo √© desenvolver um
%algoritmo em MATLAB que seja capaz de ler as imagens do dataset fornecido,
%corrigir a perspectiva destas imagens e criar uma imagem panor√¢mica.
%%---------------------------------

%%---------------------------------
% Dataset
% O dataset padr√£o para testes cont√©m cinco imagens coloridas (640x480) de
% um edif√≠cio e esta disponivel na pasta /dataset/
%%---------------------------------


%Desenvolva seu codigo aqui
%% Notas

% H = ransac(@homography,T) onde T È o threshold
% Usar cÈlulas para agrupar imagens e iterar Im{n}
% consultar documentaÁ„o de SurfPointFeature.match
% consultar documentaÁ„o de FeatureMatch.ransac
% consultar documentaÁ„o de ransac

%% Load images.
buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);

% Display images to be stitched
% montage(buildingScene.Files)

%% Leitura de imagens
I = readimage(buildingScene, 1);

% Im{1} = iread('path');
% Im{2} = iread('path');
% Im{3} = iread('path');
% Im{4} = iread('path');
% Im{5} = iread('path');

% numIm = numel(Im);
%% Initialize features for I(1) - teste
grayImage = rgb2gray(I);
points = detectSURFFeatures(grayImage);
% pointsPK = isurf(grayImage, 'extended'); % FunÁ„o que extrai features da
% imagem. Retorna um vetor de objetos SurfPointFeature que contem
% informacoes sobre os features como o vetor descritor e a posicao.

imshow(grayImage); hold on;
plot(points);
%pointsPK.plot_scale();



%% LaÁo de repetiÁ„o para detecÁaı de features e matches

Imgs = rgb2gray(Im{1});
% Identificacao de features da primeira imagem
pointsPK = isurf(Imgs, 'extended');

% Armazenando tamanho das imagens
ImSize = zeros(numIm,2);
ImSize(1,:) = size(Imgs);

% Laco de iteracao sobre as outras imagens
for i=2:numIm
    
    Imgs = rgb2gray(Im{i});
    prevPointsPK = pointsPK;
    pointsPK = isurf(Imgs, 'extended');
    
    % Salvando tamanho da imagem
    ImSize(i,:) = size(Imgs);
    
    % Deteccao de matches entre features de duas imagens
    matches = prevPointsPK.match(pointsPK);
    
    % Aplica a funcao ransac no conjunto de matches
    matches.ransac(@homography, 1e-1,'maxTrials', 1e4);
    
end

