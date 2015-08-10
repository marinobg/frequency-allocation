function [Px, Py, d, nlist] = createPointsAndDistances(NP, MC, Xmax, Ymax)
Px = zeros(1, NP);
Py = zeros(1, NP);

for i=1:NP
    Px(i)=MC+randi(Xmax);
    Py(i)=MC+randi(Ymax);
end %i

% Px(1) = 25;
% Py(1) = 41;
% Px(2) = 55;
% Py(2) = 49;
% Px(3) = 69;
% Py(3) = 52;
% Px(4) = 34;
% Py(4) = 63;
% Px(5) = 29;
% Py(5) = 60;
% Px(6) = 59;
% Py(6) = 34;
% Px(7) = 31;
% Py(7) = 30;
% Px(8) = 29;
% Py(8) = 33;
% Px(9) = 78;
% Py(9) = 21;
% Px(10) = 78;
% Py(10) = 22;

% assign neighbour lists to points
d = zeros(NP);
nlist = d;
for i = 1:NP
    for j = 1:NP
        d(i,j) = sqrt((Px(i)-Px(j))^2 + (Py(i)-Py(j))^2);
        if d(i,j) < MC*2 && i ~= j
            nlist(i,j) = 1 / d(i,j);
        end
    end %j
end %i

end %function