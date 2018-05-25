
clear all
clc
%%Ler A Placa e Pegar as Letras Separadas
placa = iread('Placa2.jpg','double');
imgs = rgb2gray(placa);
imthold = imgs < 0.2;
imgBlobs = iblobs(imthold, 'class', 1);
%%idisp(imthold);
%%imgBlobs.plot_box;
[i,kmax] = size(imgBlobs);
for i=1:kmax    
    VetordePais(i) = imgBlobs(i).parent;    
end
edges = unique(VetordePais);

[iedg, jedg] = size(edges);
for j=1:jedg
    cont = 0;
for i=1:kmax 
    if(edges(j) == VetordePais(i))
       cont = cont + 1;     
    end
      
end
VetorQuantidade(j) = cont;
end

i = 1;
for j=1:jedg
if (VetorQuantidade(j) > 7)
    Vetormaiores(i) = edges(j);
    i = i+1;
end
end 

[i,kmax] = size(imgBlobs);
n = 1;
[i,lmax] = size(Vetormaiores);
for l=1:lmax
for i=1:kmax    
   if (imgBlobs(i).parent == Vetormaiores(l))
       FilhosdeInteresse(n) = imgBlobs(i);
       n = 1 + n;
   end
end
end

[i,lmax] = size(FilhosdeInteresse);
p = 1;
for l=1:lmax
   if (FilhosdeInteresse(l).area >100) 
            FilhosdeInteresse1(p) = FilhosdeInteresse(l);
            p = p +1;
   end         
end

[i,lmax] = size(Vetormaiores);
[i,pmax] = size(FilhosdeInteresse1);
count = 0;
j = 1;
for l=1:lmax
for p=1:pmax    
   if (FilhosdeInteresse1(p).parent == Vetormaiores(l))
        count = count  +1;
       p = 1 + p;
   end
end
if (count >= 7)
     PaisdeInteresse(j) = Vetormaiores(l);
     j = j+1;
end
    
cont = 0;
l = l +1;
end

[i,jmax] = size(PaisdeInteresse);
[i,pmax] = size(FilhosdeInteresse1);
count = 0;
m = 1;
for j=1:jmax
for p=1:pmax    
   if (FilhosdeInteresse1(p).parent ==  PaisdeInteresse(j))
        IBLOBSdaPlaca(m) = FilhosdeInteresse1(p);
       m = m +1;
   end
end
end


%%Pegar as 7 maiores areas da placa
 AreaIBLOBSdaPlacaGreater = IBLOBSdaPlaca.area;
 AreaIBLOBSdaPlacaGreater = sort(AreaIBLOBSdaPlacaGreater);
 
 [i,pmax] = size(AreaIBLOBSdaPlacaGreater);
 k =1;
 for p=pmax:-1:pmax-6
     SevenGreater(k) = AreaIBLOBSdaPlacaGreater(p);
     k = k+1;

 end 
 
for m=1:7
 for p=1:pmax
       if(IBLOBSdaPlaca(p).area == SevenGreater(m));
           SevenGreaterBlobs(m) = IBLOBSdaPlaca(p);
       end
 end
end

umin = SevenGreaterBlobs(1).umin;
for m=1:7
       if(SevenGreaterBlobs(m).umin < umin);
           umin = SevenGreaterBlobs(m).umin;
       end
end

for m=1:7
       if(SevenGreaterBlobs(m).umin == umin);
           BlobPlacaMaisaEsquerda = SevenGreaterBlobs(m);
       end
end

umax = SevenGreaterBlobs(1).umax;
for m=1:7
       if(SevenGreaterBlobs(m).umax > umax);
           umax = SevenGreaterBlobs(m).umax;
       end
end

for m=1:7
       if(SevenGreaterBlobs(m).umax == umax);
           BlobPlacaMaisaDireita = SevenGreaterBlobs(m);
       end
end



%%BlobPlacaMaisaEsquerda.plot_box;
%BlobPlacaMaisaDireita.plot_box;

LarguraoLetra = BlobPlacaMaisaDireita.umax - BlobPlacaMaisaDireita.umin;
xmax = BlobPlacaMaisaDireita.umax + LarguraoLetra;
xmin = BlobPlacaMaisaEsquerda.umin - LarguraoLetra;
if(xmin < 0)
    xmin = 0
end

if(BlobPlacaMaisaDireita.vc > BlobPlacaMaisaEsquerda.vc)
    ymin = BlobPlacaMaisaDireita.vc;
    ymax =  BlobPlacaMaisaEsquerda.vc;
  x= 'Caso 1'
else
    ymin = BlobPlacaMaisaEsquerda.vc;
    ymax = BlobPlacaMaisaDireita.vc;
     x= 'Caso 2'
end   
%ymax = ymax + 5*LarguraoLetra;
%ymin = ymin - 5*LarguraoLetra;

%idisp(imthold);
%rectangle('Position',[xmin,ymin,BlobPlacaMaisaDireita.uc - xmin,ymax-ymin],'LineWidth',2,'LineStyle','--','EdgeColor','r');
%x0=xmin;
%y0=ymin;
%xf=BlobPlacaMaisaDireita.uc - xmin + 50;
%yf = ymax-ymin;
%rect = [x0,y0,xf,yf];
%PlacaIsolada = imcrop(imthold,rect);
%%idisp(PlacaIsolada);
for k=1:7
    xretas(k) = SevenGreaterBlobs(k).uc;
   yretas(k) = SevenGreaterBlobs(k).vc;
end
x=xretas;
y=yretas;

P = polyfit(x,y,1);
yfit = P(1)*x+P(2);
[i,j]= size(x);
idisp(imthold);
[Largura, Altura] = size(imgs)

[i,jmax] = size(yfit);
for j=1:jmax
     if(x(j) == max(x))
        y1 = yfit(j)
     end 
end 
for j=1:jmax
     if((x(j) == min(x)))
        y2 = yfit(j)
     end 
end 

%% Os valores que multiplicam a variavel LarguraoLetra servem para estas placas, e sao variaveis qe dependem do tamanho da foto. 
 if(BlobPlacaMaisaDireita.vc > BlobPlacaMaisaEsquerda.vc)
    x0 = min(x) -LarguraoLetra;
    xf = max(x) +LarguraoLetra;
    y0 = min(yfit)-3*LarguraoLetra;
    yf = max(yfit)+2*LarguraoLetra;
    y1 = y1 -3*LarguraoLetra;
    y2 = y2 + 2*LarguraoLetra;
 else
    xf = min(x) -LarguraoLetra;
    x0 = max(x) +LarguraoLetra;
    y0 = min(yfit)-3*LarguraoLetra/1.5;
    yf = max(yfit)+2*LarguraoLetra/1.5;
    y2 = y2 -3*LarguraoLetra/1.5;
    y1 = y1 +2*LarguraoLetra/1.5;
  end 

hold on; 
plot(x0,y0,'g*');
hold on;
plot(xf,yf,'g*');
hold on; 
plot(xf,y1,'g*');
hold on; 
plot(x0,y2,'g*');
hold on; 
plot(x,yfit,'r-');
