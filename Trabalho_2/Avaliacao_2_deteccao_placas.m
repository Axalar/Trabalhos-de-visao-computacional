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
% function strings = carPlateRead
%% clear & close all - remover depois
clear all
close all

%% inicializacao

placa = iread('dataset/placa_carro1.jpg','double'); % removar depois
imgs = rgb2gray(placa);
imthold = imgs < 0.2; %otsu(imgs);
imtholdst = imthold(35:70,:);

tamanhoim = size(imgs);
bh = tamanhoim(1)/tamanhoim(2);
areaim = tamanhoim(1)*tamanhoim(2);

blobsst = iblobs(imtholdst, 'class', 1, 'area', [35,1000], 'connect', 8);
blobscd = iblobs(imthold, 'class', 1, 'area', [500,10000]);


%% sorting

blobscd = sortBlobs(blobscd);
blobsst = sortBlobs(blobsst);

%%

for i=1:numel(blobscd)
    
    crctcd{i} = imthold(blobscd(i).vmin:blobscd(i).vmax,blobscd(i).umin:blobscd(i).umax);
        
end

for i=1:numel(blobsst)
    
    crctst{i} = imtholdst(blobsst(i).vmin:blobsst(i).vmax,blobsst(i).umin:blobsst(i).umax);

end
%% templates

thold = rgb2gray(iread('templates/templateA.png')) == 0;
btpa = iblobs(thold, 'class', 1);
[~,I] = sort(btpa(:).uc);
btpa = btpa(I);

for i=1:26
    
    tmpA{i} = thold(btpa(i).vmin:btpa(i).vmax,btpa(i).umin:btpa(i).umax);
    
end

thold = rgb2gray(iread('templates/templateN.png')) == 0;
btpn = iblobs(thold, 'class', 1);
[~,I] = sort(btpn(:).uc);
btpn = btpn(I);

for i=1:10
    
    tmpN{i} = thold(btpn(i).vmin:btpn(i).vmax,btpn(i).umin:btpn(i).umax);
    
end

%% Comparar letras

m = [];
for k =1:3
    
    for i=1:26
        
        tamanho = size(tmpA{i});
        temp = imresize(crctcd{k},tamanho);
        m(i) = zncc(temp,tmpA{i});
        
    end
    
    [~,I] = max(m);
    index(k) = I;
    
end
%% Comparar Numeros

m = [];
for k =1:4
    
    for i=1:10
        tamanho = size(tmpN{i});
        temp = imresize(crctcd{3+k},tamanho);
        m(i) = zncc(temp,tmpN{i});
    end
    
    [~,I] = max(m);
    index(3+k) = I;
    
end

idisp({tmpA{index(1:3)},tmpN{index(4:end)}})

%% Comparar letras (estado, municipio)

m = [];
index = [];
for k =1:numel(crctst)
    
    for i=1:26
        
        tamanho = size(tmpA{i});
        temp = imresize(crctst{k},tamanho);
        m(i) = zncc(temp,tmpA{i});
        
    end
    
    [~,I] = max(m);
    index(k) = I;
    
end

idisp({tmpA{index}})

%%

% for i=1:26
%     tamanho = size(tmpA{i});
%     temp = imresize(crctcd{1},tamanho);
%     m(i) = zncc(tmpA{i},temp);
% end
% 
% [~,I] = max(m)

% batata = compare(crctcd);


%%
% idisp(imthold(35:70,:))
% for i=1:numel(blobsst)
%     plot_box(blobsst(i).umin, blobsst(i).vmin, blobsst(i).umax, blobsst(i).vmax, 'g');
% end
% 
% for i=1:numel(blobsst)
%     
%     crctst{i} = placast(blobsst(i).vmin:blobsst(i).vmax,blobsst(i).umin:blobsst(i).umax);
%     
% end
% idisp({crctst{:}})
% 
% for i=1:26
%     tamanho = size(tmpA{i});
%     temp = imresize(crctst{5},tamanho);
%     m(i) = zncc(tmpA{i},temp);
% end
% 
% [~,I] = max(m)
% 
% T = niblack(imgs(35:70,:), -0.2, 3);