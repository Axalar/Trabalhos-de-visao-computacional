# Panorama

Neste projeto estaremos desenvolvendo um *script* em linguagem Matlab para a montagem de panoramas a partir de conjuntos de imagens. O *script* realizará de forma automática a extração de *features* da imagem, detecção de *matches* entre features de duas imagens, aplicação da homografia e sobreposição das imagens para construção do panorama. Para o desenvolvimento deste *script* faremos o uso da [*toolbox* de visão computacional desenvolvida por Peter Corke](http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox).

# Detecção de *feature*

Para a detecção de *features* usaremos a função ```matlab isurf()``` da toolbox, que realiza a detecção de features com o algoritmo *Speed Up Robust Features* e retorna um vetor de objetos da classe *SurfPointFeature*.

```
F1 = isurf(imagem);
```

# Comparação de *features*

O método ```F1.match()``` da classe *SurfPointFeature* será usado para encontrar os *matches* entre as *features* das imagens. Este método retorna um vetor de objetos da classe *FeatureMatch* que relaciona as duas imagens.

```
M = F1.match(F2);
```

# Matriz de homografia

Usando o método ```M.ransac()``` da classe *FeatureMatch* calcularemos as matrizes de homografia que relacionam duas imagens adjacentes, buscando um conjunto de 4 *matches* que forneçam o melhor resultado para a homografia conforme um limiar definido.

```
H = M.ransac(@homografy, 0.2);
```

# Homografia

Com a função ```homwarp()``` será aplicada a homografia das imagens, distorcendo-as e rotacionando-as para que se encaixem no panorama.

```
[H,off] = homwarp(H, imagem, ‘full’);
```

# Montagem do panorama

Usando os valores de *offset* ```off```retornados pela função ```homwarp()```, e as dimensões das imagens após a homografia será calculada as dimensões de uma matriz de zeros sobre a qual as imagens serão sobrepostas para montar o panorama. Os valores de *offset* também serão usados para determinar a posição em que cada imagem será colocada. Para inserir as imagens no panorama serão usadas máscaras e a função ```ipaste()```.

# Para utilizar o script

Para se usar este *sript* é preciso se ter instalado a [*toolbox*](http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox). Na *toolbox* será preciso substituir as aspas duplas ```”``` por aspas simples ```’```, caso contrário algumans funções como a ```iread()``` não funcionarão. As imagens que se deseja usar para montar o panorama devem ser colocadas na pasta *dataset* e devem estar em ordem.

Este *script* foi testado na versão 2016a do Matlab.
