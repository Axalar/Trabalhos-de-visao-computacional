%%---------------------------------
% Copyright (C) 2017-2018, by Marcelo R. Petry
% This file is distributed under the MIT license
% 
% Copyright (C) 2017-2018, by Marcelo R. Petry
% Este arquivo é distribuido sob a licença MIT
%%---------------------------------

%%---------------------------------
% BLU3040 - Visao Computacional em Robotica
% Avaliacao 2 - Deteccao de placas
% Requisitos:
%   MATLAB
%   Machine Vision Toolbox 
%       P.I. Corke, “Robotics, Vision & Control”, Springer 2011, ISBN 978-3-642-20143-1.
%       http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox
%%---------------------------------

%%---------------------------------
% Objetivo 
% O reconhecimento de caracteres em arquivos de imagens é uma tarefa
% extremamente útil dada a diversificada gama de aplicações. O
% reconhecimento de placas veiculares, por exemplo, tem se demonstrado
% fundamental para o controle automático de entrada e saída de veículos em
% portos, aeroportos, terminais ferroviários, industrias e centros
% comerciais. Na robótica o reconhecimento de placas é empregado em robôs
% de vigilância e, mais recentemente, como ferramenta auxiliarem veículos
% autômonos. 
%
% O objetivo deste trabalho consiste em desenvolver uma função que receba
% imagens com placas de veículos e seja capaz de reconhecer e retornar os
% caracteres alfanuméricos utilizando template matching e features de região. 
%
%%---------------------------------

%%---------------------------------
% Dataset 
% O dataset padrão para testes contém duas imagens coloridas, uma
% placa de automovel e uma placa de motocicleta, e esta disponivel na pasta /dataset/
%%---------------------------------


%%---------------------------------
% Entregas
% Cada grupo deverá descrever a sua funcao sob a forma de relatório técnico. 
% No relatório deverá ser apresentado:
% * Contextualização
% * Breve explicação sobre as metodologias utilizas
% * Descrição da lógica 
% * Testes e resultados
% * Conclusão
% 
% Além do relatório, cada um dos grupos deverá criar um projeto público no
% GitHub e fazer upload do código desenvolvido. O link para o projeto do
% GitHub deverá constar no relatório entregue. O projeto no GitHub deverá
% conter um arquivo README explicando brevemente o algoritmo e como
% executá-lo. Cada grupo também deverá realizar uma demonstração do seu
% algoritmo durante a aula.

%%---------------------------------
% Avaliação 
% A pontuacao do trabalho será atribuida de acordo com os
% criterios estabaleceidos a seguir: 
% *Até 7.0: A funcao recebe como argumento uma imagem, e retorna um vetor com
% dois elementos contendo os três caracteres alfabeticos e os quatro
% caracteres numericos referentes ao número da placa do veículo. O
% algoritmo devera reconhecer os caracteres em pelo menos 3 imagens
% diferentes.
% *Até 8.0: Alem dos requesitos estabelecidos anteriormente, a funcao
% devera retornar os caracteres numericos referentes ao estado e a cidade.
% *Até 10.0: Alem dos requesitos estabelecidos anteriormente, as imagens
% passadas para a funcao deverao ter outros elementos alem da placa do
% veiculo, tais como parachoque, pavimento, pessoas, etc. Esta deverá
% primeiramente identificar, extrair e orientar a placa. Devem ser
% utilizadas tecnicas de conversao do espaco de cor, operacoes monadicas e
% homografia.
% *Até 12.0: Alem dos requesitos estabelecidos anteriormente, a funcao
% devera receber video, de arquivo ou da webcam, e retornar os
% caracteres da placa.
%%---------------------------------


%Desenvolva seu codigo aqui
% function out = plateRead(im)
%% clear & close all - remover depois
clear all
close all

%% inicializacao

placa = iread('dataset/placa_carro1.jpg','double'); % removar depois

% imgs = findPlate(im);

imgs = rgb2gray(placa);
tamanhoim = size(imgs);
hb = tamanhoim(1)/tamanhoim(2);
areaim = tamanhoim(1)*tamanhoim(2);

if hb > 0.5882

    vmincd = floor((75/310)*tamanhoim(1));
    vmaxcd = floor((290/310)*tamanhoim(1));
    umincd = floor((40/364)*tamanhoim(2));
    umaxcd = floor((320/364)*tamanhoim(2));
    
    vminst = floor((42/310)*tamanhoim(1));
    vmaxst = floor((66/310)*tamanhoim(1));
    uminst = floor((59/364)*tamanhoim(2));
    umaxst = floor((314/364)*tamanhoim(2));
    
else
    
    vmincd = floor((75/241)*tamanhoim(1));
    vmaxcd = floor((214/241)*tamanhoim(1));
    umincd = floor((37/742)*tamanhoim(2));
    umaxcd = floor((704/742)*tamanhoim(2));
    
    vminst = floor((39/241)*tamanhoim(1));
    vmaxst = floor((67/241)*tamanhoim(1));
    uminst = floor((100/742)*tamanhoim(2));
    umaxst = floor((646/742)*tamanhoim(2));
    
end

%% segmenting

imgscd = imgs(vmincd:vmaxcd, umincd:umaxcd);
imgsst = imgs(vminst:vmaxst, uminst:umaxst);
idisp({imgscd, imgsst})

%% thresholding

imtholdcd = imgscd < multithresh(imgscd);
imtholdst = imgsst < multithresh(imgsst);


%% extracting blobs

blobsst = iblobs(imtholdst, 'class', 1, 'area', [75/140000*areaim, areaim], 'connect', 8);
blobscd = iblobs(imtholdcd, 'class', 1, 'area', [550/140000*areaim, areaim]);

%% sorting blobs

blobscd = sortBlobs(blobscd);
blobsst = sortBlobs(blobsst);

%%
for i=1:numel(blobscd)
    
    crctcd{i} = imtholdcd(blobscd(i).vmin:blobscd(i).vmax,blobscd(i).umin:blobscd(i).umax);
        
end
idisp({crctcd{:}})

for i=1:numel(blobsst)
    
    t = multithresh(imgs(blobsst(i).vmin:blobsst(i).vmax,blobsst(i).umin:blobsst(i).umax));
    crctst{i} = imtholdst(blobsst(i).vmin:blobsst(i).vmax,blobsst(i).umin:blobsst(i).umax) > t;
    
end
idisp({crctst{:}})

%% templates

thold = rgb2gray(iread('templates/templateA.png')) == 0;
btpa = iblobs(thold, 'class', 1);
[~,I] = sort(btpa(:).uc);
btpa = btpa(I);

for i=1:26
    
    if i == 9
        tmpA{i} = thold(btpa(i).vmin:btpa(i).vmax,btpa(i).umin-2:btpa(i).umax+2);
    else
        tmpA{i} = thold(btpa(i).vmin:btpa(i).vmax,btpa(i).umin:btpa(i).umax);
    end
    
end

thold = rgb2gray(iread('templates/templateN.png')) == 0;
btpn = iblobs(thold, 'class', 1);
[~,I] = sort(btpn(:).uc);
btpn = btpn(I);

for i=1:10
    
    tmpN{i} = thold(btpn(i).vmin:btpn(i).vmax, btpn(i).umin:btpn(i).umax);
    
end

%% Comparar letras

m = [];
for k=1:3
    
    for i=1:26
        
        tamanho = size(tmpA{i});
        temp = imresize(crctcd{k}, tamanho);
        m(i) = zncc(temp, tmpA{i});
        
    end
    
    [~, I] = max(m);
    index(k) = I;
    
end

out{1} = index2string(index(1:3), 'a');

%% Comparar Numeros

m = [];
for k =1:4
    
    for i=1:10
        tamanho = size(tmpN{i});
        temp = imresize(crctcd{3+k}, tamanho);
        m(i) = zncc(temp, tmpN{i});
    end
    
    [~,I] = max(m);
    index(3+k) = I;
    
end

out{2} = index2string(index(4:end), 'n');
idisp({tmpA{index(1:3)}, tmpN{index(4:end)}})

%% Comparar letras (estado, municipio)

m = [];
index = [];
for k=1:numel(crctst)
    
    for i=1:26
        
        tamanho = size(tmpA{i});
        temp = imresize(crctst{k}, tamanho);
        m(i) = zncc(temp, tmpA{i});
        
    end
    
    [~,I] = max(m);
    index(k) = I;
    
end

out{3} = index2string(index(1:2), 'a');
out{4} = index2string(index(3:end), 'a')
idisp({tmpA{index}})
