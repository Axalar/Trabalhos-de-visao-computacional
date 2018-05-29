%INDEX2STRING STRING índice para string
% str = index2string(I, NORA) is a string in where each character is
% determined by its corresponding index provided by the array I, acording 
% to the alpha numeric templates used by the function readPlate(). The 
% string NORA is used to determine if the indexes represent numeric or 
% alphabetic characters, and it must be respectively 'n' or 'a'.

function str = index2string(index, nora)

    str = [];
    N = ['0';'1';'2';'3';'4';'5';'6';'7';'8';'9'];
    A = ['A';'B';'C';'D';'E';'F';'G';'H';'I';'J';'K';'L';'M'; ...
        'N';'O';'P';'Q';'R';'S';'T';'U';'V';'W';'X';'Y';'Z'];
    
    if nora == 'n'
        for i=1:numel(index)
            str = [str N(index(i))];
        end
    else
        if nora == 'a'
            for i=1:numel(index)
                str = [str A(index(i))];
            end
        end
    end
end