
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
edges = unique(VetordePais)

[iedg, jedg] = size(edges)
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
count = 0
j = 1
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
    
cont = 0
l = l +1
end

[i,jmax] = size(PaisdeInteresse);
[i,pmax] = size(FilhosdeInteresse1);
count = 0
m = 1
for j=1:jmax
for p=1:pmax    
   if (FilhosdeInteresse1(p).parent ==  PaisdeInteresse(j))
        IBLOBSdaPlaca(m) = FilhosdeInteresse1(p);
       m = m +1
   end
end
end


%%Pegar as 7 maiores areas da placa
 AreaIBLOBSdaPlacaGreater = IBLOBSdaPlaca.area;
 AreaIBLOBSdaPlacaGreater = sort(AreaIBLOBSdaPlacaGreater);
 
 [i,pmax] = size(AreaIBLOBSdaPlacaGreater)
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

umin = SevenGreaterBlobs(1).umin
for m=1:7
       if(SevenGreaterBlobs(m).umin < umin);
           umin = SevenGreaterBlobs(m).umin
       end
end

for m=1:7
       if(SevenGreaterBlobs(m).umin == umin);
           BlobPlacaMaisaEsquerda = SevenGreaterBlobs(m);
       end
end

umax = SevenGreaterBlobs(1).umax
for m=1:7
       if(SevenGreaterBlobs(m).umax > umax);
           umax = SevenGreaterBlobs(m).umax
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
xmax = BlobPlacaMaisaDireita.umax + LarguraoLetra
xmin = BlobPlacaMaisaEsquerda.umin - LarguraoLetra
if(xmin < 0)
    xmin = 0
end

if(BlobPlacaMaisaDireita.vc > BlobPlacaMaisaEsquerda.vc)
    ymin = BlobPlacaMaisaDireita.vc
    ymax =  BlobPlacaMaisaEsquerda.vc
else
    ymin = BlobPlacaMaisaEsquerda.vc
    ymax = BlobPlacaMaisaDireita.vc
end   
ymax = ymax + 5*LarguraoLetra
ymin = ymin - 5*LarguraoLetra

idisp(imthold);
rectangle('Position',[xmin,ymin,xmax-0.8*xmin,ymax-ymin],'LineWidth',2,'LineStyle','--','EdgeColor','r');