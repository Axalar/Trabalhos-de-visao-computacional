%READPLATE leitura de placas veículares
% out = readPlate(im) é uma célula com quatro campos, cada um contendo uma
% string que são respectivamente a leitura das letras da identificação da
% placa, a leitura dos números da identificação da placa, leitura da sigla
% do estado da placa e a leitura da município da placa.

function out = readPlate(im)
    
    % Se a imagem estiver no formato uint8 este IF converte ela para double
    if isa(im,'uint8')
        
        im = im2double(im);
        
    end
    
    % Caso a imagem seja muito grande, sua escala é reduzida para diminuir
    % o custo de memória da função
    if size(im,1)*size(im,2) > 3.0233e+06
        
        im = imresize(im, 0.6);
        
    end
    
    % Isola a placa usando a função findPlate
    imgs = findPlate(im);

    tamanhoim = size(imgs);
    hb = tamanhoim(1)/tamanhoim(2);
    areaim = tamanhoim(1)*tamanhoim(2);

    % Baseando se na proporção altura/base escolhe os parâmetros para placa de
    % carro ou moto
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
        vmaxst = floor((72/241)*tamanhoim(1));
        uminst = floor((125/742)*tamanhoim(2));
        umaxst = floor((635/742)*tamanhoim(2));

    end

    %% Segmentação

    % Isola as áreas de interesse da placa
    imgscd = imgs(vmincd:vmaxcd, umincd:umaxcd);
    imgsst = imgs(vminst:vmaxst, uminst:umaxst);

    % ----------
    % idisp({imgscd, imgsst})
    % ----------

    %% Limiarização

    imtholdcd = imgscd < multithresh(imgscd);
    imtholdst = imgsst < multithresh(imgsst);
    
    % ----------
    % idisp({imtholdcd, imtholdst})
    % ----------

    %% Extração de features de região (blobs)

    blobsst = iblobs(imtholdst, 'class', 1, 'area', [65/140000*areaim, areaim], 'connect', 8);
    blobscd = iblobs(imtholdcd, 'class', 1, 'area', [550/140000*areaim, areaim]);

    %% Ordenação dos blobs

    blobscd = sortBlobs(blobscd);
    blobsst = sortBlobs(blobsst);

    %% Isolamento dos blobs para comparação com templates

    for i=1:numel(blobscd)

        crctcd{i} = imtholdcd(blobscd(i).vmin:blobscd(i).vmax,blobscd(i).umin:blobscd(i).umax);

    end

    % ----------
    % idisp({crctcd{:}})
    % ----------

    for i=1:numel(blobsst)

        t = multithresh(imgs(blobsst(i).vmin:blobsst(i).vmax,blobsst(i).umin:blobsst(i).umax));
        crctst{i} = imtholdst(blobsst(i).vmin:blobsst(i).vmax,blobsst(i).umin:blobsst(i).umax) > t;

    end
    % ----------
    % idisp({crctst{:}})
    % ----------

    %% Preparo dos templates

    % tmpA são os templates alfabéticos
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

    % tmpN são os templates numéricos
    thold = rgb2gray(iread('templates/templateN.png')) == 0;
    btpn = iblobs(thold, 'class', 1);
    [~,I] = sort(btpn(:).uc);
    btpn = btpn(I);

    for i=1:10

        if i == 2
            tmpN{i} = thold(btpn(i).vmin:btpn(i).vmax, btpn(i).umin-2:btpn(i).umax+2);
        else
            tmpN{i} = thold(btpn(i).vmin:btpn(i).vmax, btpn(i).umin:btpn(i).umax);
        end

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

    % ----------
    % idisp({tmpA{index(1:3)}, tmpN{index(4:end)}})
    % ----------

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
    out{4} = index2string(index(3:end), 'a');

    % ----------
    % idisp({tmpA{index}})
    % ----------

end
