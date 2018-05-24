%SORTBLOBS Blob Features
% sorted = sortBlobs(B) é o vetor de objetos RegionFeature B ordenados 
% conforme sua posição. Os objetos são ordenados do mais próximo do eixo u
% até o mais distante. Objetos com aproximadamente a mesma distância do
% eixo u são ordenados conforme sua distância ao eixo v, do maix próximo
% ao mais distante.
function sorted = sortBlobs(blobs)

    j = 1;
    vmin = blobs(1).vmin;
    temp{1} = [];
    
%     Organiza blobs em linhas
    for i = 1:numel(blobs)
    
        if abs(blobs(i).vmin - vmin) < 10
            temp{j} = [temp{j} blobs(i)];
        else
            j = j+1;
            vmin = blobs(i).vmin;
            temp = {temp{:} []};
            temp{j} = [temp{j} blobs(i)];
        end
        
    end
    
%     Ordena os blobs
    for i=1:numel(temp)
        
        if numel(temp{i}) > 0
            [~, I] = sort(temp{i}(:).umin);
            temp{i} = temp{i}(I);
        end
        
    end

sorted = [temp{1:end}];

end
