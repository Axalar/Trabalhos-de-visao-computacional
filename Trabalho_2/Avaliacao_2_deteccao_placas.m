%%---------------------------------
% Copyright (C) 2017-2018, by Marcelo R. Petry
% This file is distributed under the MIT license
% 
% Copyright (C) 2017-2018, by Marcelo R. Petry
% Este arquivo � distribuido sob a licen�a MIT
%%---------------------------------

%%---------------------------------
% BLU3040 - Visao Computacional em Robotica
% Avaliacao 2 - Deteccao de placas
% Requisitos:
%   MATLAB
%   Machine Vision Toolbox 
%       P.I. Corke, �Robotics, Vision & Control�, Springer 2011, ISBN 978-3-642-20143-1.
%       http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox
%%---------------------------------

%%---------------------------------
% Objetivo 
% O reconhecimento de caracteres em arquivos de imagens � uma tarefa
% extremamente �til dada a diversificada gama de aplica��es. O
% reconhecimento de placas veiculares, por exemplo, tem se demonstrado
% fundamental para o controle autom�tico de entrada e sa�da de ve�culos em
% portos, aeroportos, terminais ferrovi�rios, industrias e centros
% comerciais. Na rob�tica o reconhecimento de placas � empregado em rob�s
% de vigil�ncia e, mais recentemente, como ferramenta auxiliarem ve�culos
% aut�monos. 
%
% O objetivo deste trabalho consiste em desenvolver uma fun��o que receba
% imagens com placas de ve�culos e seja capaz de reconhecer e retornar os
% caracteres alfanum�ricos utilizando template matching e features de regi�o. 
%
%%---------------------------------

%%---------------------------------
% Dataset 
% O dataset padr�o para testes cont�m duas imagens coloridas, uma
% placa de automovel e uma placa de motocicleta, e esta disponivel na pasta /dataset/
%%---------------------------------


%%---------------------------------
% Entregas
% Cada grupo dever� descrever a sua funcao sob a forma de relat�rio t�cnico. 
% No relat�rio dever� ser apresentado:
% * Contextualiza��o
% * Breve explica��o sobre as metodologias utilizas
% * Descri��o da l�gica 
% * Testes e resultados
% * Conclus�o
% 
% Al�m do relat�rio, cada um dos grupos dever� criar um projeto p�blico no
% GitHub e fazer upload do c�digo desenvolvido. O link para o projeto do
% GitHub dever� constar no relat�rio entregue. O projeto no GitHub dever�
% conter um arquivo README explicando brevemente o algoritmo e como
% execut�-lo. Cada grupo tamb�m dever� realizar uma demonstra��o do seu
% algoritmo durante a aula.

%%---------------------------------
% Avalia��o 
% A pontuacao do trabalho ser� atribuida de acordo com os
% criterios estabaleceidos a seguir: 
% *At� 7.0: A funcao recebe como argumento uma imagem, e retorna um vetor com
% dois elementos contendo os tr�s caracteres alfabeticos e os quatro
% caracteres numericos referentes ao n�mero da placa do ve�culo. O
% algoritmo devera reconhecer os caracteres em pelo menos 3 imagens
% diferentes.
% *At� 8.0: Alem dos requesitos estabelecidos anteriormente, a funcao
% devera retornar os caracteres numericos referentes ao estado e a cidade.
% *At� 10.0: Alem dos requesitos estabelecidos anteriormente, as imagens
% passadas para a funcao deverao ter outros elementos alem da placa do
% veiculo, tais como parachoque, pavimento, pessoas, etc. Esta dever�
% primeiramente identificar, extrair e orientar a placa. Devem ser
% utilizadas tecnicas de conversao do espaco de cor, operacoes monadicas e
% homografia.
% *At� 12.0: Alem dos requesitos estabelecidos anteriormente, a funcao
% devera receber video, de arquivo ou da webcam, e retornar os
% caracteres da placa.
%%---------------------------------


im = iread('dataset/placa_carro2.jpg', 'double');

% A fun��o readPlate foi desenvolvida para realizar os requesitos do
% trabalho at� 10.0 pontos.
readPlate(im)
