%PLATEORIENTATION oreienta��o de plca ve�cular
% [L, P] = plateOrientation(letrasDaPlaca) s�o respectivamente uma c�lula
% contendo vetores de pontos que formam 3 retas e uma matriz contendo os
% polin�mios que descrevem estas retas. L{1} s�o os pontos da reta que
% passam por cima das RegionFeatures letrasDaPlaca e esta reta � descrita
% pelo polin�mio contido em P(1,:). L{2} s�o os pontos da reta que passa
% pelo meio dos RegionFeatures e � descrita por P(2,:). E por fim L{3} s�o
% os pontos da reta que passa por baixo dos RegionFeatures e � descrita
% pelo polin�mio contido em P(3,:).

function [L, P] = plateOrientation(letrasDaPlaca)

    r1 = [letrasDaPlaca.umin; letrasDaPlaca.vmin];
    r2 = [letrasDaPlaca.umax; letrasDaPlaca.vmin];
    r3 = [letrasDaPlaca.umin; letrasDaPlaca.vmax];
    r4 = [letrasDaPlaca.umax; letrasDaPlaca.vmax];

    pol1 = polyfit(r1(1,:), r1(2,:), 1);
    pol2 = polyfit(r2(1,:), r2(2,:), 1);
    pol3 = polyfit(r3(1,:), r3(2,:), 1);
    pol4 = polyfit(r4(1,:), r4(2,:), 1);

    x1 = linspace(min(r1(1,:)), max(r1(1,:)));
    y1 = polyval(pol1,x1);
    x2 = linspace(min(r2(1,:)), max(r2(1,:)));
    y2 = polyval(pol2,x2);
    x3 = linspace(min(r3(1,:)), max(r3(1,:)));
    y3 = polyval(pol3,x3);
    x4 = linspace(min(r4(1,:)), max(r4(1,:)));
    y4 = polyval(pol4,x4);

    polt = polyfit([x1,x2], [y1,y2], 1);
    xt = linspace(min([x1,x2]), max([x1,x2]));
    yt = polyval(polt,xt);

    polm = polyfit([x1,x2,x3,x4], [y1,y2,y3,y4], 1);
    xm = linspace(min([x1,x2,x3,x4]), max([x1,x2,x3,x4]));
    ym = polyval(polm,xm);

    polb = polyfit([x3,x4], [y3,y4], 1);
    xb = linspace(min([x3,x4]), max([x3,x4]));
    yb = polyval(polb,xb);

    Lt = [xt; yt; zeros(size(xt))];
    Lm = [xm; ym; zeros(size(xm))];
    Lb = [xb; yb; zeros(size(xb))];
    
    L = {Lt, Lm, Lb};
    P = [polt; polm; polb];
    
end