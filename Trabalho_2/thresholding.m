%THRESHOLDING gera��o de imagem limiarizada
% imthold = thresholding(im) � uma imagem bin�ria gerada a partir da imagem
% im. Primeiramente � calculada uma imagem bin�ria utilizando-se
% trhesholding local. Esta imagem � somada com outra imagem gerada
% usando-se um threshold global. Aplica-se ent�o uma m�dia gaussiana no
% resultado da soma para eliminar regi�es muito pequenas e ent�o aplic�-se
% novamente um threshold global para se gerara a sa�da da fun��o.

function imthold = thresholding(im)

    if size(im,3) == 3

        im = rgb2gray(im);

    end
    
    temp = imbinarize(im, 'adaptive','ForegroundPolarity','dark','Sensitivity',0.5);
    temp = temp == 0;
    temp2 = temp+(im < multithresh(im));
    temp3 = ismooth(temp2,1);
    temp4 = temp3 > multithresh(temp3);
    imthold = temp4;
    
%     temp = imbinarize(im, 'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
%     imthold = temp == 0;
    
%     imthold = im < multithresh(im);
    
end