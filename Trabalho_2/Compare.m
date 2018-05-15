function Result = Compare(img)

%%Ler A Placa e Pegar as Letras Separadas
placa = iread(img,'double');
imgs = rgb2gray(placa);
imthold = imgs < 0.2;
imgBlobs = iblobs(imthold, 'class', 1, 'area', [4000,7000]);
[~,I] = sort(imgBlobs(:).uc);
imgBlobs = imgBlobs(I);

for i=1:7    
    TemplatesImg{i} = imthold(imgBlobs(i).vmin:imgBlobs(i).vmax,imgBlobs(i).umin:imgBlobs(i).umax);
end

%% Pegar template do alfabeto
thold = rgb2gray(iread('templates/templateA.png')) == 0;
btpa = iblobs(thold, 'class', 1);
[~,I] = sort(btpa(:).uc);
btpa = btpa(I);

for i=1:26    
    tmpA{i} = thold(btpa(i).vmin:btpa(i).vmax,btpa(i).umin:btpa(i).umax);    
end
%% Pegar template dos Numeros
thold = rgb2gray(iread('templates/templateN.png')) == 0;
btpn = iblobs(thold, 'class', 1);
[~,I] = sort(btpn(:).uc);
btpn = btpn(I);

for i=1:10    
    tmpN{i} = thold(btpn(i).vmin:btpn(i).vmax,btpn(i).umin:btpn(i).umax);
    
end
%% Comparar letras
for k =1:3
for i=1:26
    tamanho = size(tmpA{i});
    temp = imresize(TemplatesImg{k},tamanho);
    m(i) = zncc(temp,tmpA{i});
end 
[~,I] = max(m);
Index(k) = I
end
%% Comparar Numeros
for k =1:4
for i=1:10
    tamanho = size(tmpN{i});
    temp = imresize(TemplatesImg{3+k},tamanho);
    m(i) = zncc(temp,tmpN{i});
end 
[~,I] = max(m);
Index(3+k) = I
end


Result =  Index
end