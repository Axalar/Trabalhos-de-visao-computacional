# Projeção de Objetos

A realidade aumentada consiste em uma experiência do mundo real em que as informações sensoriais visuais, auditivas, hapaticas e olfativa de alguns elementos são geradas computacionalmente, de forma a alterar a percepção do ambiente de forma imersiva. A vasta gama de aplicações de realidade virtual se expande desde aplicações para entretenimento, como elementos interativos em jogos, até aplicações educacionais e médicas.

A visão computacional pode ser aplicada para a geração de informações sensoriais visuais do ambiente aplicada à realidade virtual, inserindo ou removendo objetos e elementos em uma cena. Nesse contexto, a projeção tridimensional de objetos consiste em um mapeamento de pontos de um objeto em três dimensões sobre um plano bidimencional. Contudo, é necessário que exita um referencial para tais projeções e normalmente são utilizados tabuleiros de xadrez, AprilTags ou QRcodes para cumprir esta função.

Neste trabalho foi realizada a implementação de um script em linguagem Matlab com objetivo de inserção de objetos tridimensionais em imagens tomando como referência um tabuleiro de xadrez presente em tais imagens. O desenvolvimento destas funções fez uso da [*toolbox* de visão computacional](http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox) desenvolvida por Peter Corke.

# Princípio de Funcionamento

Primeiramente o *script* calcula os parâmetros intrínsecos da câmera para realizar a correção de distorções radiais que provocam a curvatura de linhas retas. Em seguida o *script* realiza iterações sobre uma imagem, um grupo de imagens ou um vídeo. Em cada iteração o tabuleiro de xadrez é localizado, seus pontos são então usados para calcular os parâmetros extrínsecos da câmera. Estes são usados junto com os parâmetros intrínsecos determinados durante a calibração para se aproximar a matriz da câmera. Esta por sua vez é usada para converter os pontos de um sólido, que se deseja inserir na imagem, em suas respectivas coordenadas no plano da imagem. Estas projeções são usadas para gerar os polígonos que formam o sólido. Com estes polígonos podem ser geradas as máscaras necessárias para composição da imagem final com o sólido inserido.

# Limitações e trabalhos futuros

Em seu estado atual os *scripts* apresentam baixo desempenho e alto tempo de execução. Isto mostra que ainda há espaço para otimização do código. Além disto, os *scripts* realizam a inserção das faces do sólido na imagem em ordem arbitrária, o que faz com que faces que não deveriam ser visíveis sobreponham-se sobre as faces que deveriam estar visíveis. Uma solução para isso é a implementação de uma função que, usando a posição da câmera e as posições das faces, determine quais as faces que devem ser inseridas na imagem. Esta função também ajudaria a reduzir o tempo de execução dos *scripts*, evitando o processamento de faces não visíveis.

# Como utilizar os *scripts*

Para fazer o uso destes *scripts* é necessário ter a [*toolbox*](http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox) mencionada anteriormente instalada. Na *toolbox* será preciso substituir as aspas duplas ```”``` por aspas simples ```’```, caso contrário algumas funções como a ```iread``` não funcionarão.
