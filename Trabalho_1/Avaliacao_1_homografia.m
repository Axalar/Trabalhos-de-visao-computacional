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
%% Leitura de imagens

Im{1} = iread('dataset/building1.jpg');
Im{2} = iread('dataset/building2.jpg');
Im{3} = iread('dataset/building3.jpg');
Im{4} = iread('dataset/building4.jpg');
Im{5} = iread('dataset/building5.jpg');

% Im{1} = iread('dataset/PIC_0373.JPG');
% Im{2} = iread('dataset/PIC_0374.JPG');
% Im{3} = iread('dataset/PIC_0375.JPG');
% Im{4} = iread('dataset/PIC_0376.JPG');
% Im{5} = iread('dataset/PIC_0377.JPG');
% Im{6} = iread('dataset/PIC_0378.JPG');

numIm = numel(Im);
midIm = floor((numIm+1)/2);

%% Lacos de repeticao para deteccao de features, matches e encontrar matrizes de homografias

% Inicialização do primeiro laco de repeticao
Imgs = rgb2gray(Im{1});
% Identificacao de features da primeira imagem
pointsPK = isurf(Imgs, 'extended');

for i=1:midIm-1

    Imgs = rgb2gray(Im{i+1});
    prevPointsPK = pointsPK;
    pointsPK = isurf(Imgs, 'extended');
    
    % Deteccao de matches entre features de duas imagens (im(i-1) -> im(i))
    matches{i} = prevPointsPK.match(pointsPK, 'top', 50);
    
    % Aplica a funcao ransac no conjunto de matches
    [Hom{i}] = matches{i}.ransac(@homography, 0.2,'maxTrials', 2.5e4);

end

for i=midIm+1:numIm
    
    Imgs = rgb2gray(Im{i});
    prevPointsPK = pointsPK;
    pointsPK = isurf(Imgs, 'extended');
    
    % Deteccao de matches entre features de duas imagens (im(i) -> im(i-1))
    matches{i} = pointsPK.match(prevPointsPK, 'top', 50);
    
    % Aplica a funcao ransac no conjunto de matches
    [Hom{i}] = matches{i}.ransac(@homography, 0.2,'maxTrials', 2.5e4);
    
end

%% Aplicacao da homografia

% Matriz de homografia da imagem central
Hom{midIm} = eye(3);
% Aplicacao da homografia da imagem central
[distort{midIm},off(midIm,:)] = homwarp(Hom{midIm},Im{midIm},'full','extrapval', 0);

for n=1:midIm-1
    
    % Calculo das matrizes de homografia em relacao a imagem central
    Hom{midIm-n} = Hom{midIm-n+1}*Hom{midIm-n};
    Hom{midIm+n} = Hom{midIm+n-1}*Hom{midIm+n};
    
    % Aplicacao da homografia as demais imagens
    [distort{midIm-n},off(midIm-n,:)] = homwarp(Hom{midIm-n},Im{midIm-n},'full','extrapval', 0);
    [distort{midIm+n},off(midIm+n,:)] = homwarp(Hom{midIm+n},Im{midIm+n},'full','extrapval', 0);
    
end

% Caso o dataset tem um numero par de imagens este if aplica a homografia
% na ultima imagem
if floor(numIm/2) == numIm/2
    Hom{numIm} = Hom{numIm-1}*Hom{numIm};
    [distort{numIm},off(numIm,:)] = homwarp(Hom{numIm},Im{numIm},'full','extrapval', 0);
end

% Plot das imagens apos aplicacao da homografia
% figure
% idisp(distort);

%% Montagem do panorama

for i=1:numIm
    % Variavel para salvar o tamanho das imagens apos a homografia
    temp =  size(distort{i});
    distSize(i,:) = [temp(1,1),temp(1,2)]; % distSize(i) = [vi,ui]
    
    % Criacao de mascaras
    mask{i} = rgb2gray(distort{i}) == 0;
    
    distgs{i} = rgb2gray(distort{i});
end

% Calculo da posicao da imagem central no panorama
midu = abs(min(off(:,1)));
midv = abs(min(off(:,2)))+1;

% Definicao das dimensoes do panorama
u = midu + off(numIm,1) + max(distSize(:,2)) +1;
v = max(distSize(:,1)) + max(abs(off(:,2)));

% Montagem do panorama
panorama = zeros(v,u,3);
for i=numIm:-1:1
    mastermask = ones(v,u,3);
    mastermask = ipaste(mastermask,mask{i},[midu+off(i,1)+1,midv+off(i,2)]);
    panorama = panorama.*mastermask;
    panorama = ipaste(panorama,distort{i},[midu+off(i,1)+1,midv+off(i,2)],'add');
end

% Plot do panorama
figure
idisp(panorama);
