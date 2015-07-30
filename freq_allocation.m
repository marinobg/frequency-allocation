clear all

% Number of APs
NP = 5;

% max distance between points
MC = 20;

% min distance
Size = 100;

Xmax = Size - 2*MC;
Ymax = Size - 2*MC;

[Px, Py, d, nlist] = createPointsAndDistances(NP, MC, Xmax, Ymax); 

initialPlot(Px, Py, Size, NP)


[neighbourlist,I] = sort(nlist,1,'ascend');

modNeighbourlist = neighbourlist; %Neighbour list to be modified

neighbourlist

I

col_indexes = getColumnIndexes(modNeighbourlist, NP); %Get columnindexes for values with biggest value for inverse distance

for i = col_indexes' %Removing indexes that are going to be used
    modNeighbourlist(NP, i) = 0;
end

%Fiding the most critical node of the nodes chosen with shortest distance
%(probably just two)
revmeters = zeros(1, length(col_indexes));
for i = 1:length(neighbourlist)
    for j = 1:length(neighbourlist)
        if any(I(i,j) == col_indexes)
            index = find(I(i,j) == col_indexes);
            revmeters(index) = revmeters(index) + neighbourlist(i,j);
        end
    end
end


index = find(revmeters == max(revmeters));
AP = col_indexes(index);
col_indexes(index) = []; %Removing element

availableFreqs = [1, 6, 11]; %This will not be changed
modAvailableFreqs = availableFreqs; %This will change

freq_alloc = zeros(1, NP);

freq_alloc(AP) = modAvailableFreqs(randi(numel(modAvailableFreqs))); %Giving channel to most critical node
modAvailableFreqs(modAvailableFreqs == freq_alloc(AP)) = []; %Remove channel picked

if length(col_indexes) == 1
   AP = col_indexes;
   freq_alloc(AP) = modAvailableFreqs(randi(numel(modAvailableFreqs)));
   modAvailableFreqs(modAvailableFreqs == freq_alloc(AP)) = [];
end


while length(find(freq_alloc)) < NP
    modNeighbourlist = sort(modNeighbourlist,1,'ascend');
    
    col_indexes = getColumnIndexes(modNeighbourlist, NP);
    
    break;
    
end

%TODO: Finn neste nodepar og velg frekvenser for alle sammen.