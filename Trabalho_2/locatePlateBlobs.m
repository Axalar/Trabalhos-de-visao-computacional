function letrasDaPlaca = locatePlateBlobs(im)

    if size(im, 3) == 3
        imgs = rgb2gray(im);
        imthold = imgs < multithresh(imgs);
    else
        imgs = im;
        imthold = im < multithresh(im);
    end

    [vim, uim] = size(imgs);
    areaim = vim*uim;

    %% Extração de blobs

    imgBlobs = iblobs(imthold, 'class', 1, 'area', [floor(areaim*100/468/823), areaim]);

    %% Identificação de pais

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

    %% Identificação de pais de interesse com pelo menos 7 filhos

    i = 1;
    for j=1:numPais

        if quantidadeFilhos(j) >= 7

            paisDeInteresse(i) = pais(j);
            i = i+1;

        end
    end

    %% Isolando blobs de interesse

    j = 1;
    for l=1:numel(paisDeInteresse)

        for i=1:numBlobs

            if imgBlobs(i).parent == paisDeInteresse(l)

                filhosDeInteresse(j) = imgBlobs(i);
                j = 1 + j;

            end
        end
    end

    %% Separando blobs de interesse por pai

    for i=1:numel(paisDeInteresse)

        k = 1;

        for j=1:numel(filhosDeInteresse)

            if filhosDeInteresse(j).parent == paisDeInteresse(i)

                possiveisLetras{i}(k) = filhosDeInteresse(j);
                k = k+1;

            end
        end
    end

    %% Ordena os blobs com area decrescente

    for i=1:numel(possiveisLetras)

        [~,I] = sort(possiveisLetras{i}.area, 'descend');
        possiveisLetras{i} = possiveisLetras{i}(I);

    end

    %%

    for i=1:numel(possiveisLetras)

        if numel(possiveisLetras{i}) < 14

            I = nchoosek([1:1:numel(possiveisLetras{i})],7);

        else

            temp = possiveisLetras{i}.area;
            temp = temp/max(temp);
            temp = temp > multithresh(temp);
            I = nchoosek([1:1:sum(temp)],7);

        end

        np = numel(possiveisLetras);
        [nit,~] = size(I);
        areastd = zeros(nit,np);
        aream = zeros(nit,np);
        hightstd = zeros(nit,np);
        ustd = zeros(nit,np);
        vstd = zeros(nit,np);

        for j=1:nit

%             areastd(j,i) = std(possiveisLetras{1}(I(j,:)).area);
%             aream(j,i) = mean(possiveisLetras{1}(I(j,:)).area);
            hightstd(j,i) = std(possiveisLetras{1}(I(j,:)).vmax-possiveisLetras{1}(I(j,:)).vmin);
%             ustd(j,i) = std(possiveisLetras{1}(I(j,:)).uc);
%             vstd(j,i) = std(possiveisLetras{1}(I(j,:)).vc);

        end
    end

    % [~,Indexa] = sort(areastd);
    [~,Indexh] = sort(hightstd);

    letrasDaPlaca = possiveisLetras{1}(I(Indexh(1),:));
    [~,I] = sort(letrasDaPlaca.umin);
    letrasDaPlaca = letrasDaPlaca(I);
end
