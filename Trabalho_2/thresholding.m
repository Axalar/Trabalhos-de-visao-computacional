%THRESHOLDING geração de imagem limiarizada
% imthold = thresholding(im) é uma imagem binária gerada a partir da imagem
% im. Primeiramente é calculada uma imagem binária utilizando-se
% trhesholding local. Esta imagem é somada com outra imagem gerada
% usando-se um threshold global. Aplica-se então uma média gaussiana no
% resultado da soma para eliminar regiões muito pequenas e então aplic´-se
% novamente um threshold global para se gerara a saída da função.

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