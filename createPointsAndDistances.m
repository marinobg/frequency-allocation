function [Px, Py, d, nlist] = createPointsAndDistances(NP, MC, Xmax, Ymax)
Px = zeros(1, NP);
Py = zeros(1, NP);

% for i=1:NP
%     Px(i)=MC+randi(Xmax);
%     Py(i)=MC+randi(Ymax);
% end %i

% Px(1) = 39;
% Py(1) = 70;
% Px(2) = 54;
% Py(2) = 24;
% Px(3) = 36;
% Py(3) = 56;
% Px(4) = 49;
% Py(4) = 32;
% Px(5) = 35;
% Py(5) = 67;
% Px(6) = 58;
% Py(6) = 29;
% Px(7) = 63;
% Py(7) = 45;
% Px(8) = 48;
% Py(8) = 63;
% Px(9) = 45;
% Py(9) = 21;
% Px(10) = 25;
% Py(10) = 56;

Px(1) = 41;
Py(1) = 72;
Px(2) = 51;
Py(2) = 72;
Px(3) = 44;
Py(3) = 62;
Px(4) = 49;
Py(4) = 77;
Px(5) = 47;
Py(5) = 65;

% assign neighbour lists to points
%d = zeros(NP);
d = ones(NP) * inf;
nlist = d;
for i = 1:NP
    for j = 1:NP
        d(i,j) = sqrt((Px(i)-Px(j))^2 + (Py(i)-Py(j))^2);
        if d(i,j) < MC*2 && i ~= j
            %nlist(i,j) = 1 / d(i,j);
            nlist(i,j) = d(i,j);
        end
    end %j
end %i

end %function