%%---------------------------------
% Copyright (C) 2017-2018, by Marcelo R. Petry
% This file is distributed under the MIT license
% 
% Copyright (C) 2017-2018, by Marcelo R. Petry
% Este arquivo é distribuido sob a licença MIT
%%---------------------------------

%%---------------------------------
% BLU3040 - Visao Computacional em Robotica
% Avaliacao 1 - Homografia: Imagens panoramicas
% Requisitos:
%   MATLAB
%   Machine Vision Toolbox 
%       P.I. Corke, “Robotics, Vision & Control”, Springer 2011, ISBN 978-3-642-20143-1.
%       http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox
%%---------------------------------

%%---------------------------------
%Objetivo 
%Nas aulas anteriores aprendemos que se a homografia entre duas
%imagens e conhecida podemos projetar uma das imagens no mesmo referencial
%que a outra. As imagens continham um plano, e somente a parte planar era
%alinhada de maneira correta. Acontece que se capturarmos uma imagem de uma
%cena, rotacionarmos a câmera e tirarmos uma segunda imagem da mesma cena
%as duas imagens também estarão relacionadas por uma matriz de homografia.
%Desta forma, voce pode instalar sua câmera em um e tirar uma fotografia.
%Girar a câmera sob o eixo vertical e tirar outra fotografia. Estas duas
%imagens completamente arbitrarias estão relacionadas por homografia, e por
%isso compartilham regiões que podem ser alinhadas e combinadas para criar
%uma fotografia panoramica. Neste trabalho o objetivo é desenvolver um
%algoritmo em MATLAB que seja capaz de ler as imagens do dataset fornecido,
%corrigir a perspectiva destas imagens e criar uma imagem panorâmica.
%%---------------------------------

%%---------------------------------
% Dataset
% O dataset padrão para testes contém cinco imagens coloridas (640x480) de
% um edifício e esta disponivel na pasta /dataset/
%%---------------------------------


%Desenvolva seu codigo aqui
%% Notas

% H = ransac(@homography,T) onde T é o threshold
% Usar células para agrupar imagens e iterar Im{n}
% consultar documentação de SurfPointFeature.match
% consultar documentação de FeatureMatch.ransac
% consultar documentação de ransac

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

Im{1} = readimage(buildingScene, 1);
Im{2} = readimage(buildingScene, 2);
Im{3} = readimage(buildingScene, 3);
Im{4} = readimage(buildingScene, 4);
Im{5} = readimage(buildingScene, 5);

numIm = numel(Im);

%% Initialize features for I(1) - teste
grayImage = rgb2gray(I);
points = detectSURFFeatures(grayImage);
% pointsPK = isurf(grayImage, 'extended'); % Função que extrai features da
% imagem. Retorna um vetor de objetos SurfPointFeature que contem
% informacoes sobre os features como o vetor descritor e a posicao.

imshow(grayImage); hold on;
plot(points);
%pointsPK.plot_scale();


%% Laço de repetição para detecçaõ de features e matches

Imgs = rgb2gray(Im{1});
% Identificacao de features da primeira imagem
pointsPK = isurf(Imgs, 'extended');

% Armazenando tamanho das imagens
ImSize = zeros(numIm,2);
ImSize(1,:) = size(Imgs);

% Inicializando primeira matriz da celula de matrizes de homografia
H{1} = eye(3);

% Laco de iteracao para geração de matrizes de homografia
for i=2:numIm
    
    Imgs = rgb2gray(Im{i});
    prevPointsPK = pointsPK;
    pointsPK = isurf(Imgs, 'extended');
    
    % Salvando tamanho da imagem
    ImSize(i,:) = size(Imgs);
    
    % Deteccao de matches entre features de duas imagens
    matches = prevPointsPK.match(pointsPK);
    
    % Aplica a funcao ransac no conjunto de matches
    H{i} = matches.ransac(@homography, 4e-1,'maxTrials', 1e5);
    
end

