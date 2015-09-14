function [Px, Py, d, nlist] = createPointsAndDistances(NP, MC, Xmax, Ymax)
Px = zeros(1, NP);
Py = zeros(1, NP);

%Creating random points
for i=1:NP
    Px(i)=MC+randi(Xmax);
    Py(i)=MC+randi(Ymax);
end %i

% Px = [95 91 45 72 10];
% Py = [6 6 6 6 6];
% 
% Px(1) = 21;
% Py(1) = 24;
% Px(2) = 76;
% Py(2) = 75;
% Px(3) = 50;
% Py(3) = 38;
% Px(4) = 39;
% Py(4) = 53;
% Px(5) = 31;
% Py(5) = 35;
% Px(6) = 28;
% Py(6) = 76;
% Px(7) = 28;
% Py(7) = 70;
% Px(8) = 51;
% Py(8) = 51;
% Px(9) = 68;
% Py(9) = 29;
% Px(10) = 31;
% Py(10) = 71;

% Px(1) = 58;
% Py(1) = 60;
% Px(2) = 25;
% Py(2) = 33;
% Px(3) = 46;
% Py(3) = 24;
% Px(4) = 40;
% Py(4) = 55;
% Px(5) = 55;
% Py(5) = 48;


% assign neighbour lists to points
d = ones(NP) * inf;
nlist = d;
for i = 1:NP
    for j = 1:NP
        d(i,j) = sqrt((Px(i)-Px(j))^2 + (Py(i)-Py(j))^2);
        if i ~= j %&& d(i,j) < 120 %MC*2 %Add d(i,j)<MC*2 to put limit on how big the radius of detection for each node should be
            nlist(i,j) = d(i,j);
        end
    end %j
end %i

end %function