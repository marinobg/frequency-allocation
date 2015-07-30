function [Px, Py, d, nlist] = createPointsAndDistances(NP, MC, Xmax, Ymax)
Px = zeros(1, NP);
Py = zeros(1, NP);

for i=1:NP
    Px(i)=MC+randi(Xmax);
    Py(i)=MC+randi(Ymax);
end %i

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