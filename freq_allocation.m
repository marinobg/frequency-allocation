clear all

% Number of APs
NP = 4;

% max distance between points
MC = 20;

% min distance
Size = 100;

%Channels to use
availableFreqs = [1, 6, 11];

Xmax = Size - 2*MC;
Ymax = Size - 2*MC;

[Px, Py, d, nlist] = createPointsAndDistances(NP, MC, Xmax, Ymax); 

initialPlot(Px, Py, Size, NP)


[neighbourlist,I] = sort(nlist,1,'ascend');

neighbourlist

I

%Fiding the most critical node of the nodes chosen with shortest distance
%(probably just two) (Assume it is just two for now)
invmeters = sumInverseMeters(col_indexes, neighbourlist, I);