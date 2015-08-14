clear all

% Number of APs
NP = 10;

% max distance between points
MC = 20;

% min distance
Size = 100;

%Channels to use
availableFreqs = [1, 6, 11];

Xmax = Size - 2*MC;
Ymax = Size - 2*MC;

[Px, Py, d, neighbourlist] = createPointsAndDistances(NP, MC, Xmax, Ymax);

initialPlot(Px, Py, Size, NP)


[neighbourlist,I] = sort(neighbourlist,1,'descend');

%distributionPlot(neighbourlist, NP) %Plot med fordeling av metrikkene

neighbourlist

I

freq_allocSelfish = selfishAllocation(NP, availableFreqs, neighbourlist, I, Px, Py, Size, d);
%freq_allocSelfish = [6 11 1 11 6];

freq_alloc = zeros(1, NP); %Vector with the channels each AP get assigned

%%Version 2 of frequency allocation with neighbourlists

%First finds closest pair of nodes
% minval = min(neighbourlist(NP,:)); %Minimum distance
% AP = find(neighbourlist(NP,:) == minval); %Closest APs in the topology
% 
% for nextAP = AP %Assign the nodes in the closest pair to a channel
%     freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
%     freq_alloc(nextAP) = freq; %Assign frequency
%     frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Nodes to begin with are the ones that detect a certain number of nodes
%inside a certain radius. E.g. 3 nodes inside 20m
radius = (NP / ((max(Px) - min(Px)) * (max(Py) - min(Py))))* ((Xmax*Ymax)/2) ; %Detection radius, use node denisty to calculate
nNodes = ceil(NP / 2); %Number of nodes required to be inside the radius
nodes = 1:NP;
mindist = inf; %Minimum distance in a neighbour list that fulfill the criteria for radius and nNodes

while isempty(find(freq_alloc)) %As long as no node have assigned a frequency
    node = nodes(randi(numel(nodes))); %Pick random node
    
    nlist = neighbourlist(:, node); %Get that node's neighbour list
    detected = length(find(nlist < radius)); %Find number of nodes inside the radius
    if detected >= nNodes && neighbourlist(NP, node) < mindist
        mindist = neighbourlist(NP, node);
        nextAP = node;
    elseif detected >= nNodes && neighbourlist(NP, node) == mindist
        nextAP(end + 1) = node; %Append to nextAP list
    end
    
    nodes(find(nodes == node)) = []; %Remove node being checked as it does not fulfill the criteria
    
    %If all nodes are checked and at least one fulfill the criteria
    if isempty(nodes) && mindist < inf
        for AP = nextAP
            freq = chooseFrequency(AP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
            freq_alloc(AP) = freq; %Assign frequency
            frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
        end
        break
    end
        
    
    %If all nodes are checked and none of them fulfill the criteria
    if isempty(nodes)
        nodes = 1:NP;
        nNodes = nNodes - 1; %Required number of nodes to be detected is one less
        if nNodes <= 1 %If no neighbour list can find two or more nodes inside the radius criteria
            %Back to start with nNodes, but with larger radius
            radius = radius + 5;
            nNodes = ceil(NP / 2);
        end
    end
    
    %Kanskje fjerne noden som er valgt hvis den ikke tilfredstiller?
end
   



while length(find(freq_alloc)) < NP
    nodes = find(freq_alloc); %Find nodes assigned to a frequency
    
    %Calculate center of mass from nodes assigned to frequency
    masscenterX = sum(Px(nodes)) / length(nodes);
    masscenterY = sum(Py(nodes)) / length(nodes);
    dist = zeros(1, NP-length(nodes));
    
    freeNodes = find(freq_alloc == 0); %Nodes not assigned to a frequency
    
    for i = 1:length(dist) %Distances from nodes without frequency to center of mass
        dist(i) = sqrt( (Px(freeNodes(i)) - masscenterX)^2 + (Py(freeNodes(i)) - masscenterY)^2 );
    end
    
    [~, index] = min(dist);
    nextAP = freeNodes(index); %Node with smallest distance to center of mass
    
    freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
    freq_alloc(nextAP) = freq; %Assign frequency
    frequencyPlot(Px, Py, Size, NP, freq_alloc, false) 
end



alone = find(neighbourlist(NP, :) == Inf); %Check if some APs doesn't detect other APs
if alone
    %Since these APs doesn't interefere other APs, they can just get a
    %random channel assigned
    for i = 1:length(alone)
        AP = alone(i);
        freq_alloc(AP) = availableFreqs(randi(numel(availableFreqs))); %Select random channel
        frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
    end
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% while length(find((freq_alloc))) < NP %Assign the other APs to a channel
%     indexes = find(freq_alloc); %Find links that are assigned to a frequency
%     nextAP = findSmallestDist(d, indexes); %Finds next link to be assigned to a frequency
%     
%     freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
%     freq_alloc(nextAP) = freq; %Assign frequency
%     frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
% end



%Creating distance plot
distancePlot(d, freq_alloc, NP, freq_allocSelfish)