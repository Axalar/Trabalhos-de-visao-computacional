%LOCATEPLATEBLOBS localiza��o dos caracteres de placas ve�culares
% letrasDaPlaca = locatePlateBlobs(im) � um vetor de objetos do tipo
% RegionFeature correspondentes aos caracteres da placa ve�cular presente
% na imagem.

function letrasDaPlaca = locatePlateBlobs(im)

    if size(im, 3) == 3
        imgs = rgb2gray(im);
        imthold = thresholding(imgs);
    else
        imgs = im;
        imthold = thresholding(imgs);
    end

    [vim, uim] = size(imgs);
    areaim = vim*uim;

    %% Extra��o de blobs

    imgBlobs = iblobs(imthold, 'class', 1, 'area', [floor(areaim*100/468/823), areaim*0.038], 'touch', 0);

    %% Identifica��o de pais

    numBlobs = numel(imgBlobs);
    for i=1:numBlobs

        vetorDePais(i) = imgBlobs(i).parent;

    end

    pais = unique(vetorDePais);

    %% Contagem de filhos de cada pai

    numPais = numel(pais);
    for j=1:numPais

        cont = 0;

        for i=1:numBlobs

            if pais(j) == vetorDePais(i)
                cont = cont + 1;
            end
        end

        quantidadeFilhos(j) = cont;

    end

    %% Identifica��o de pais de interesse com pelo menos 7 filhos

    i = 1;
    paisDeInteresse = [];
    for j=1:numPais

        if quantidadeFilhos(j) >= 7

            paisDeInteresse(i) = pais(j);
            i = i+1;

        end
    end
    
    % Caso n�o sejam encontrados blobs suficientes, � feita uma nova
    % tentativa usando threshold local
    if numel(paisDeInteresse) < 1
        
        imthold = imbinarize(imgs, 'adaptive','ForegroundPolarity','dark','Sensitivity',0.3);
        imthold = imthold == 0;
        imgBlobs = iblobs(imthold, 'class', 1, 'area', [floor(areaim*100/468/823), areaim*0.038], 'touch', 0);
        numBlobs = numel(imgBlobs);
        
        for i=1:numBlobs

            vetorDePais(i) = imgBlobs(i).parent;

        end
        
        pais = unique(vetorDePais);
 
        for j=1:numel(pais);

            cont = 0;

            for i=1:numBlobs

                if pais(j) == vetorDePais(i)
                    cont = cont + 1;
                end
            end
            
            quantidadeFilhos(j) = cont;

        end

        i = 1;
        for j=1:numel(pais);

            if quantidadeFilhos(j) >= 7

                paisDeInteresse(i) = pais(j);
                i = i+1;

            end
        end
    end

    %% Isolando blobs de interesse

    j = 1;
    for l=1:numel(paisDeInteresse)

        for i=1:numBlobs

            if imgBlobs(i).parent == paisDeInteresse(l)

                possiveisLetras(j) = imgBlobs(i);
                j = 1 + j;

            end
        end
    end

    %% Ordena os blobs com area decrescente

    [~,I] = sort(possiveisLetras.area, 'descend');
    possiveisLetras = possiveisLetras(I);
        
    %% Compara��o dos 14 maiores blobs pelo desvio padr�o da altura

    % Calcula o desvio padr�o da altura das combina��es de at� 14 blobs com
    % maior �rea em grupos de 7
    if numel(possiveisLetras) < 14

        I = nchoosek(1:1:numel(possiveisLetras),7);

    else

        I = nchoosek(1:1:14,7);

    end

    [nit,~] = size(I);
    hightstd = zeros(nit,1);

    for j=1:nit

        hightstd(j) = std(possiveisLetras(I(j,:)).vmax-possiveisLetras(I(j,:)).vmin);
        
    end

    [~,Indexh] = sort(hightstd);
    letrasDaPlaca = possiveisLetras(I(Indexh(1),:));
    [~,It] = sort(letrasDaPlaca.umin);
    letrasDaPlaca = letrasDaPlaca(It);
    
end
