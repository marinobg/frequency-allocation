% Number of APs
NP = 5;

iterations = 1; %Number of topologies
selfiterations = 1; %Number of selfish test for each topology
best = zeros(1, 3);
PxMat = zeros(iterations, NP); %Matrix with all topologies' x-coordinates. Same topology row wise
PyMat = zeros(iterations, NP); %Matrix with all topologies' y-coordinates. Same topology row wise

%Matrices with shortest distances
dminMat = zeros(1, iterations);
dminSelfMat = zeros(iterations, selfiterations); %All columns in same row is for same topology

for count = 1:iterations
    count
    best
    
    clearvars -except best count iterations dminMat dminSelfMat selfiterations PxMat PyMat NP %Clear all variables except for the ones after '-except'
    
    % max distance between points
    MC = 20;
    
    % min distance
    Size = 100;
    
    %Channels to use
    availableFreqs = [1, 6, 11];
    
    Xmax = Size - 2*MC;
    Ymax = 1%Size - 2*MC;
    
    [Px, Py, d, neighbourlist] = createPointsAndDistances(NP, MC, Xmax, Ymax);
    PxMat(count, :) = Px;
    PyMat(count, :) = Py;
    
    initialPlot(Px, Py, Size, NP) %Creates a plot of the topology before assignment
    
    
    [neighbourlist,I] = sort(neighbourlist,1,'descend');
    
    %distributionPlot(neighbourlist, NP) %Plot med fordeling av metrikkene
    
    %     neighbourlist
    %
    %     I
    
    for it = 1:selfiterations
        freq_allocSelfish = selfishAllocation(NP, availableFreqs, neighbourlist, I, Px, Py, Size, d);
        %freq_allocSelfish = [11 1 11 1 6 6];
        dminSelf = smallestDistance(NP, d, freq_allocSelfish);
        dminSelfMat(count, it) = min(dminSelf);
        it
        dminSelfMat
    end
    
    freq_alloc = zeros(1, NP); %Vector with the channels each AP get assigned
    
    
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
        if detected >= nNodes && mindist == inf % neighbourlist(NP, node) < mindist
            mindist = neighbourlist(NP, node);
            nextAP = node;
        elseif detected >= nNodes %&& neighbourlist(NP, node) == mindist
            
            %If true, node does not have other nodes in its neighbour list that are allowed to choose a frequency
            if checkNeighbourlist(nlist, I, node, nextAP)
                nextAP(end + 1) = node; %Append to nextAP list
            elseif neighbourlist(NP, node) < neighbourlist(NP, nextAP)
                nextAP = node;
            end
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
                radius = radius + 5; %Radius extended
                nNodes = ceil(NP / 2); %Back to start
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
    
    
    dmin = smallestDistance(NP, d, freq_alloc);
    
    
    %Creating distance plot
    distancePlot(d, freq_alloc, NP, freq_allocSelfish)
    
    dminMat(count) = min(dmin);
    %dminSelfMat(count) = min(dminSelf);
    
    if min(dmin) > min(dminSelf)
        best(1) = best(1) + 1; %Maximize shortest distance best
    elseif min(dminSelf) > min(dmin)
        best(2) = best(2) + 1; %Selfish best
    else
        best(3) = best(3) + 1; %Equally good
    end
    
    %Histogramfunksjon
%     figure()
%     [a, b] = hist(dminSelfMat(count,:), unique(dminSelfMat(count, :))); %Get values on x- and y-axis
%     hBar = bar(b, a); 
%     
%     index = find(b == dminMat(count));
%     x = b(index);
%     y = a(index);
%     hold on
%     bar([x-0.05, x, x+0.05], [0, y, 0], 1, 'r')
    
end
best