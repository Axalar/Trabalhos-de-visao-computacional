%FINDPLATE isola a placa veícular presente na imagem
% placa = findPlate(im) é uma imagem contendo a placa veícular presente na
% imagem im isolada e com perspectiva corrigida.

function placa = findPlate(im)


if size(im, 3) == 3
    imgs = rgb2gray(im);
else
    imgs = im;
end

%% Localização das letras da placa

% Usa a função locatePlateBlobs para encontrar os caracteres da placa
letrasDaPlaca = locatePlateBlobs(imgs);

% ----------
% idisp(im)
% letrasDaPlaca.plot_box
% ----------

%% Determinação da orientação da placa a partir das letras

% Usa a função abaixo para determinar as retas de orientação da placa
[L, P] = plateOrientation(letrasDaPlaca);

% Linhas do topo, meio e baixo das letras
Lt = L{1};
Lm = L{2};
Lb = L{3};

% Polinômios que descrevem as respectivas linhas acima
polt = P(1,:);
polm = P(2,:);
polb = P(3,:);

thetam = atan(polm(1));
axang = [0 0 1 -thetam];
rotm = axang2rotm(axang); % rotação do referêncial global para referêncial de Lm

% Determina o método de cálculo da inclinação das laterais da placa
% baseando-se na inclinação de Lm
if abs(thetam) < 0.02 
    boy = 'y';
else
    boy = 'b';
end 

% Rotação da imagem para o referêncial de Lm
hom = homwarp(rotm, imgs);

% Caso a placa esteja muito inclinada, a imagem é rotacionada e os
% processos anteriores são refeitos para se obter melhores resultados
if abs(thetam*180/pi) > 14.3
    
    imgs = homwarp(rotm, imgs);
    
    letrasDaPlaca = locatePlateBlobs(imgs);
    
    % ----------
    % idisp(hom)
    % letrasDaPlaca.plot_box
    % ----------

    [L, P] = plateOrientation(letrasDaPlaca);

    polt = P(1,:);
    polm = P(2,:);
    polb = P(3,:);

    Lt = L{1};
    Lm = L{2};
    Lb = L{3};
    
    % ----------
    % idisp(hom)
    % letrasDaPlaca.plot_box
    % hold on
    % plot(Lt(1,:),Lt(2,:), 'r')
    % plot(Lm(1,:),Lm(2,:), 'r')
    % plot(Lb(1,:),Lb(2,:), 'r')
    % ----------
    
    thetam = atan(polm(1));
    axang = [0 0 1 -thetam];
    rotm = axang2rotm(axang); % rotação do referêncial global para referêncial de Lm

    hom = homwarp(rotm, imgs);
    
end

%% Rotação para o sistema de coordenadas de Lm (da placa)

% Rotação das linhas Lt, Lm e Lb para o referêncial de Lm
for i=1:size(Lt,2)
    
    Ltr(:,i) = rotm * Lt(:,i);
    Lmr(:,i) = rotm * Lm(:,i);
    Lbr(:,i) = rotm * Lb(:,i);
    
end

% Cálculo dos polinômios das retas rotacionadas
poltr = polyfit(Ltr(1,:), Ltr(2,:), 1);
polmr = polyfit(Lmr(1,:), Lmr(2,:), 1);
polbr = polyfit(Lbr(1,:), Lbr(2,:), 1);

% ----------
% idisp(hom);
% hold on
% plot(Ltr(1,:),Ltr(2,:))
% plot(Lmr(1,:),Lmr(2,:))
% plot(Lbr(1,:),Lbr(2,:))
% ----------

%% Recalculando retas sobre um espaço do eixo x uniformizado

if poltr(1) < polbr(1)
    
    Lmr(1,:) = linspace(Lmr(1,1), Lmr(1,end));
    Ltr(1,:) = linspace(Lmr(1,1), Lmr(1,end)+0.3*(Lmr(1,end)-Lmr(1,1)));
    Lbr(1,:) = Ltr(1,:);
    
    Ltr(2,:) = polyval(poltr,Ltr(1,:));
    Lmr(2,:) = polyval(polmr,Lmr(1,:));
    Lbr(2,:) = polyval(polbr,Lbr(1,:));
    
else
    
    Lmr(1,:) = linspace(Lmr(1,end), Lmr(1,1));
    Ltr(1,:) = linspace(Lmr(1,1), (Lmr(1,end)-0.3*(Lmr(1,1)-Lmr(1,end))));
    Lbr(1,:) = Ltr(1,:);
    
    Ltr(2,:) = polyval(poltr,Ltr(1,:));
    Lmr(2,:) = polyval(polmr,Lmr(1,:));
    Lbr(2,:) = polyval(polbr,Lbr(1,:));
    
end

% ----------
% idisp(hom)
% hold on
% plot(Ltr(1,:),Ltr(2,:));
% plot(Lmr(1,:),Lmr(2,:));
% plot(Lbr(1,:),Lbr(2,:));
% ----------

%% Registro de parâmetros para cálculo das laterais da placa

Ltri = Ltr(2,1);
Ltre = Ltr(2,end);
Lbri = Lbr(2,1);
Lbre = Lbr(2,end);
r = (Ltri - Lbri)/(Ltre - Lbre);
deltax = 0.21*abs(Lmr(1,end)-Lmr(1,1));
deltae = r*deltax/2;
deltad = deltax-deltae;

if poltr(1) < polbr(1)
    deltae = -deltae;
    deltad = deltad;
else
    deltae = deltae;
    deltad = -deltad;
end


%% Cálculo do ponto de fuga da perspectiva da imagem

% Encontrando o ponto de fuga da perspectiva da imagem
distOrigint = (Ltr(2,1) - Lmr(2,1)) / poltr(1);
distOriginb = (Lbr(2,1) - Lmr(2,1)) / polbr(1);
origin = Ltr(1,1) - mean([distOrigint, distOriginb]);

% Calculando retas a partir do ponto de fuga
Ltr(1,:) = linspace(origin, Ltr(1,end));
Lbr(1,:) = Ltr(1,:);

Ltr(2,:) = polyval(poltr,Ltr(1,:));
Lbr(2,:) = polyval(polbr,Lbr(1,:));

% ----------
% idisp(hom)
% hold on
% plot(Ltr(1,:),Ltr(2,:));
% plot(Lmr(1,:),Lmr(2,:));
% plot(Lbr(1,:),Lbr(2,:));
% ----------

%% Cálculo da reta do topo da placa partindo do ponto de fuga

Ltemp(1,:) = Ltr(1,:) - origin;
Ltemp(2,:) = Ltr(2,:);
poltemp = polyfit(Ltemp(1,:), Ltemp(2,:), 1);

alpha = 1.6; % topo
poltemp = [poltemp(1)+alpha*poltemp(1)  poltemp(2)];
Ltpr(2,:) = polyval(poltemp, Ltemp(1,:));
Ltpr(1,:) = Ltr(1,:);
Ltpr(3,:) = zeros(size(Ltpr(1,:)));
poltpr = polyfit(Ltpr(1,:), Ltpr(2,:),1);

% ----------
% idisp(hom)
% hold on
% plot(Ltpr(1,:),[polyval(poltpr, Ltpr(1,:))]);
% plot(Ltpr(1,:),Ltpr(2,:));
% ----------

%% Cálculo da reta de baixo da placa partindo do ponto de fuga

Ltemp(1,:) = Lbr(1,:) - origin;
Ltemp(2,:) = Lbr(2,:);
poltemp = polyfit(Ltemp(1,:), Ltemp(2,:), 1);

alpha = 0.6; % baixo
poltemp = [poltemp(1)+alpha*poltemp(1)  poltemp(2)];
Lbpr(2,:) = polyval(poltemp, Ltemp(1,:));
Lbpr(1,:) = Lbr(1,:);
Lbpr(3,:) = zeros(size(Lbpr(1,:)));
polbpr = polyfit(Lbpr(1,:), Lbpr(2,:), 1);

% ----------
% idisp(hom)
% hold on
% plot(Lbpr(1,:),[polyval(polbpr, Lbpr(1,:))]);
% plot(Ltpr(1,:),Ltpr(2,:));
% ----------

%% Cálculo dos lados da placa

x1 = Lmr(1,1)+deltae;
y1 = polyval(polmr,x1);

x2 = Lmr(1,end)+deltad;
y2 = polyval(polmr,x2);

deltay = max([abs(polyval(polbpr,x2) + polyval(poltpr,x2)),...
    abs(polyval(polbpr,x1) + polyval(poltpr,x1))]);

%% Cálculo da inclinação dos lados (método amarelo)

if boy == 'y'
    
    thetatr = abs(atan(poltpr(1)));
    thetabr = abs(atan(polbpr(1)));
    beta = (pi-thetatr-thetabr)/2;
    phi = pi/2-thetatr;
    alpha = beta-phi;
    vertical = [0 0 0; +deltay 0 -deltay; 0 0 0];
    angle = [0 0 1 alpha];
    rot = axang2rotm(angle);

    for i=1:3
        vertical(:,i) = rot*vertical(:,i);
    end

    ladoer(1,:) = vertical(1,:) + x1;
    ladoer(2,:) = vertical(2,:) + y1;
    ladoer(3,:) = zeros(1,size(ladoer,2));

    ladodr(1,:) = vertical(1,:) + x2;
    ladodr(2,:) = vertical(2,:) + y2;
    ladodr(3,:) = zeros(1,size(ladodr,2));
    
    for i=1:size(ladodr,2)
    
    Ldp(:,i) = rotm \ ladodr(:,i);
    Lep(:,i) = rotm \ ladoer(:,i);
    
    end
    
    % ----------
%     idisp(hom);
%     hold on
%     plot(Ltpr(1,:),Ltpr(2,:),'g')
%     plot(Lbpr(1,:),Lbpr(2,:),'g')
%     plot(Lmr(1,:),Lmr(2,:),'r')
%     plot(x1,y1,'rx')
%     plot(x2,y2,'rx')
%     plot(ladodr(1,:),ladodr(2,:))
%     plot(ladoer(1,:),ladoer(2,:))
    % ----------

end

%% Rotação de volta para referêncial global

for i=1:size(Lt,2)
    
    Lt(:,i) = rotm \ Ltr(:,i);
    Lb(:,i) = rotm \ Lbr(:,i);
    Ltp(:,i) = rotm \ Ltpr(:,i);
    Lbp(:,i) = rotm \ Lbpr(:,i);
    
end

lime = rotm\[x1;y1;0];
limd = rotm\[x2;y2;0];

% ----------
% idisp(imgs)
% hold on
% plot(Lt(1,:),Lt(2,:),'r')
% plot(Ltp(1,:),Ltp(2,:),'g')
% plot(Lb(1,:),Lb(2,:),'r')
% plot(Lbp(1,:),Lbp(2,:),'g')
% plot(Lm(1,:),Lm(2,:),'r')
% plot(ladod(1,:),ladod(2,:))
% plot(ladoe(1,:),ladoe(2,:))
% ----------

%% Cálculo da inclinação dos lados (método azul)

if boy == 'b'
    
    thetal = letrasDaPlaca.theta;
    thetal = mean(thetal);
    
    if abs(thetal) < 0.7857
        if thetal < 0
            thetal = mean(abs(letrasDaPlaca.theta));
        else
            thetal = -mean(abs(letrasDaPlaca.theta));
        end
    end
        
    line = [-deltay, 0, deltay; 0, 0, 0; 0, 0, 0];    
    rotml = axang2rotm([0 0 1 thetal]);

    for i=1:3

        line(:,i) = rotml * line(:,i);
        Lep(:,i) = line(:,i) + lime;
        Ldp(:,i) = line(:,i) + limd;

    end

end

% ----------
% idisp(imgs)
% hold on
% plot(Lt(1,:),Lt(2,:),'r')
% plot(Ltp(1,:),Ltp(2,:),'r')
% plot(Lb(1,:),Lb(2,:),'r')
% plot(Lbp(1,:),Lbp(2,:),'g')
% plot(Lm(1,:),Lm(2,:),'r')
% plot(lime(1),lime(2),'rx')
% plot(limd(1),limd(2),'rx')
% plot(Ldp(1,:),Ldp(2,:), 'b')
% plot(Lep(1,:),Lep(2,:), 'y')
% letrasDaPlaca.plot_ellipse
% ----------

%% Cálculo da homografia da placa

% Encontrando as quinas da placa pela intersecção das linhas
p(:,1) = InterX(Ltp, Ldp);
p(:,2) = InterX(Ltp, Lep);
p(:,3) = InterX(Lbp, Ldp);
p(:,4) = InterX(Lbp, Lep);

% No caso da imagem conter apenas a placa, os pontos das quinas da placa
% serão calculados fora da imagem, o que causa problemas. Esse laço de
% repetição corrige isso
for i=1:2
    for j=1:4
        if p(i,j) < 1
            p(i,j) = 1;
        else if p(i,j) > size(imgs,3-i)
                p(i,j) = size(imgs,3-i);
            end
        end
    end
end

umax = 742;
vmax = 241;

% Dependendo de que lado da placa se encontra o ponto de fuga da
% perspectiva, o algoritmo troca direita e esquerda. Este IF garante que a
% relação dos pontos da homografia estão corretos
if p(1,1) > p(1,2)
    H = homography([p(:,1), p(:,2), p(:,3), p(:,4)], [[umax;1],[1;1],[umax;vmax],[1;vmax]]);
else
    H = homography([p(:,2), p(:,1), p(:,4), p(:,3)], [[umax;1],[1;1],[umax;vmax],[1;vmax]]);
end

% ----------
% idisp(imgs)
% hold on
% plot(p(1,1),p(2,1),'rx')
% plot(p(1,2),p(2,2),'gx')
% plot(p(1,3),p(2,3),'bx')
% plot(p(1,4),p(2,4),'yx')
% ----------

% Aplicação da homografia
[placa, offset] = homwarp(H, imgs, 'full');

% ----------
% idisp(placa)
% ----------

placa = placa(1-offset(2):vmax-offset(2),1-offset(1):umax-offset(1));

%  ----------
% idisp({placa(1-offset(2):vmax-offset(2),1-offset(1):umax-offset(1))})
% ----------

end