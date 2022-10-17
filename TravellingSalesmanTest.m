clear
C = 100;
%X = randi([0,C],[1,C]);
%Y = randi([0,C],[1,C]);
load Xtest 
load Ytest
tic
kB = .1;
for kk = 1:50
X = Xtest;
Y = Ytest;
W = ones(1,C);
T = 2000;
P = [X;Y];
iter = 10000;
Etrack(iter) = 0;
Ttrack(1) = T; Ttrack(iter) = 0;
for k = 1:iter
    edges =  [0 cumsum(normalize(W, 'norm', 1))]; edges(end) = 1;
    r = discretize(rand(1,2), edges);
    Pa = P; Pa(:,[r(1) r(2)]) = Pa(:,[r(2) r(1)]);
    E = @(P) sum(sqrt(diff(P(1,:)).^2 + diff(P(2,:)).^2));
    EP = E([P P(:,1)]);
    Etrack(k) = EP;
    EPa = E([Pa Pa(:,1)]);
    dE = EPa - EP;
    if (EPa <= EP) || (exp(-dE/(kB*T))>=rand)
        P = Pa;
        W(r(1)) = (1 - (abs(dE/EPa))^(1/1.2))*W(r(1));
        W(r(2)) = (1 - (abs(dE/EPa))^(1/1.2))*W(r(2));
        T = (1 - (abs(dE/EPa)^(1/20)))*T;
    end
    if mod(k,iter/1000)==0
        T = T + Ttrack(1)*exp(-10*k/iter);
    end
    T = T*exp(-(k/iter)^(1/2));
    Ttrack(k) = T;
end
EPtrack(kk) = EP;
end
toc
plot(Etrack)
figure(2)
plot([P(1,:), P(1,1)],[P(2,:), P(2,1)])
hold on
scatter(P(1,:),P(2,:),'ro')
figure(3)
plot(Ttrack)
mean(EPtrack)
