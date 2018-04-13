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


