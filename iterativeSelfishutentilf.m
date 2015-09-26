clear all
clf
clf(figure(3))
clf(figure(2))
%clf(figure(4))
%clf(figure(5))
%clf(figure(6))


% Number of APs
NP = 25;
density=NP/5;

% max distance between points
%MC = 20;
MC=round(NP/density);

% min distance
Size = 100 * density;

%Channels to use
availableFreqs = [1, 6, 11];

Xmax = Size - 2*MC;
Ymax = Size - 2*MC;

[Px, Py, d, neighbourlist] = createPointsAndDistances(NP, MC, Xmax, Ymax);
%upper=upperbounddistance(d)

[dminste, V, Ex]=dminst(d);

%ix


%figure(6)
%grafplot(V,Ex,Px,Py,Size)


[neighbourlist,I] = sort(neighbourlist,1,'descend');

%initialPlot(Px, Py, Size, NP)

%Number of iterations
iterations = 10 * NP + 1;

%Array with shortest distance for each selfish iteration
dmin = zeros(1, iterations);

%Array with frequencies for the nodes
freq_allocSelf = zeros(1, NP);

nodes = 1:NP; %Array with nodes

% Give all nodes a random frequency, not thinking about neighbours or
% anything
while ~isempty(nodes)
    node = nodes(randi(numel(nodes))); %Selecting random node
    nodes(find(nodes == node)) = []; %Removing node selected, preventing from selecting that node again
    freq_allocSelf(node) = availableFreqs(randi(numel(availableFreqs)));
end

freq_allocRemember = freq_allocSelf; %Start point for FIRE too

distances = smallestDistance(NP, d, freq_allocSelf); %Get shortest distances for each node to an interfering node
dmin(1) = min(distances); %Inserting smallest distance between interfering nodes into dmin

nodes = 1:NP; %Get the nodes array with the node numbers again

for i = 2:iterations
    node = nodes(randi(numel(nodes))); %Selecting random node
    freq = chooseFrequency(node, neighbourlist, I, availableFreqs, freq_allocSelf); %Choose best frequency based on neighbour list
    freq_allocSelf(node) = freq;
    
    distances = smallestDistance(NP, d, freq_allocSelf); %Get shortest distances for each node to an interfering node
    dmin(i) = min(distances); %Inserting smallest distance between interfering nodes into dmin
end

frequencyPlot(Px, Py, Size, NP, freq_allocSelf, true)
n=length(V);
e=length(Ex(:,1));


x=zeros(2,1);
y=zeros(2,1);
hold on
for i=1:e
    x(1)=Px(Ex(i,1));
    x(2)=Px(Ex(i,2));
    y(1)=Py(Ex(i,1));
    y(2)=Py(Ex(i,2));
    plot(x,y);
end

hold off

figure(1)
plot(1:iterations, dmin)
hold on


%Running 100 simulations on topology to get optimal shortest distance
maxDmin = 0;
freq_allocSelfish = zeros(1, NP);
for it = 1:10 * NP
    freq_allocSelfish = selfishAllocation(NP, availableFreqs, neighbourlist, I, Px, Py, Size, d);
    dminSelf = smallestDistance(NP, d, freq_allocSelfish);
    if min(dminSelf) > maxDmin
        maxDmin = min(dminSelf);
    end
end

plot(1:iterations, repmat(maxDmin, 1, iterations), 'k')























%%%%%%%%%%%%%%%%%%%%%%%%%FIRE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_alloc = zeros(1, NP);
%freq_alloc = freq_allocRemember;
dminFire = zeros(1, iterations);
dminFire(1) = dmin(1); %Same start


radius = 2 * (NP / ((max(Px) - min(Px)) * (max(Py) - min(Py))))* ((Xmax*Ymax)/2) ; %Detection radius, use node denisty to calculate
nNodes = ceil(NP / 2); %Number of nodes required to be inside the radius
nodes = 1:NP;
mindist = inf; %Minimum distance in a neighbour list that fulfill the criteria for radius and nNodes

newAssignedNodes = [];
j = 2;

while j < iterations
    
    while isempty(find(newAssignedNodes))
        
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
                newAssignedNodes(end + 1) = AP;
                freq = freq_alloc(AP);
                freqs = availableFreqs;
                freqs(find(freqs == freq)) = []; %Removing channel node had
                
                freq = chooseFrequency(AP, neighbourlist, I, availableFreqs, freq_alloc); %Make AP choose another channel
                freq_alloc(AP) = freq; %Assign frequency
                %frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
                
                dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
                dminFire(j) = min(dminNew);
                j = j + 1;
                
            end
            break
        end
        
        
        %If all nodes are checked and none of them fulfill the criteria
        if isempty(nodes)
            nodes = 1:NP;
            nNodes = nNodes - 1; %Required number of nodes to be detected is one less
            if nNodes <= 1 %If no neighbour list can find two or more nodes inside the radius criteria
                %Back to start with nNodes, but with larger radius
                radius = radius + 10; %Radius extended
                nNodes = ceil(NP / 2); %Back to start
            end
        end
        
        %Kanskje fjerne noden som er valgt hvis den ikke tilfredstiller?
        
    end
    
    
    
    while length(newAssignedNodes) < NP
        nodes = sort(newAssignedNodes); %Find nodes assigned to a frequency for second time
        
        %Calculate center of mass from nodes assigned to frequency
        masscenterX = sum(Px(nodes)) / length(nodes);
        masscenterY = sum(Py(nodes)) / length(nodes);
        dist = zeros(1, NP-length(nodes));
        
        freeNodes = setdiff(1:NP, nodes); %Nodes not assigned to a frequency for second time
        
        for i = 1:length(dist) %Distances from nodes without frequency to center of mass
             %dist(i) = ((Px(freeNodes(i)) - masscenterX) +(Py(freeNodes(i)) - masscenterY) );
            dist(i) = sqrt( (Px(freeNodes(i)) - masscenterX)^2 + (Py(freeNodes(i)) - masscenterY)^2 );
        end
        
        [~, index] = min(dist);
        nextAP = freeNodes(index); %Node with smallest distance to center of mass
        newAssignedNodes(end + 1) = nextAP;
        
        freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
        freq_alloc(nextAP) = freq; %Assign frequency
        
        dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
        dminFire(j) = min(dminNew);
        j = j + 1;
        %frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
    end
    
    %dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
    %dminFire(j) = min(dminNew);
    
    newAssignedNodes = [];
    radius = 2 * (NP / ((max(Px) - min(Px)) * (max(Py) - min(Py))))* ((Xmax*Ymax)/2) ; %Detection radius, use node denisty to calculate
    nNodes = ceil(NP / 2); %Number of nodes required to be inside the radius
    
end
plot(5)
plot(1:iterations, dminFire, 'r')
legend('SELFISH', 'Best smallest distance', 'FIRE', 'Location', 'southeast')
hold off

dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances

frequencyPlot(Px, Py, Size, NP, freq_alloc, false)

x=zeros(2,1);
y=zeros(2,1);
hold on
for i=1:e
    x(1)=Px(Ex(i,1));
    x(2)=Px(Ex(i,2));
    y(1)=Py(Ex(i,1));
    y(2)=Py(Ex(i,2));
    plot(x,y);
end


%%%%%%%%%%%%%%%%%%%%%%%%%FIRE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% consecutive = 0;
% newAssignedNodes = [];
% 
% dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
% mindist = min(dminNew);
% limit = min(distances);
%
% while mindist < maxDmin
%     
%     dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
%     mindist = min(dminNew);
%     
%     %All nodes changed, start from beginning
%     if length(newAssignedNodes) == NP
%         consecutive = consecutive + 1;
%         newAssignedNodes = [];
%     end
%     
%     %If same distance is achieved 5 times, might be best distance
%     if consecutive == 10
%         break;
%     end
%     
%     critNode = find(dminNew == mindist);
%     if isempty(find(newAssignedNodes ==  critNode(1))) %If not in newAssignedNodes array
%         critNode = critNode(1);
%     elseif ~isempty(find(newAssignedNodes ==  critNode(2))) %If in newAssignedNodes array
%         %Nodes with shortest distances has both got a new channel
%         %assignment. Making sure they get different channels
%         index1 = find(newAssignedNodes == critNode(1));
%         index2 = find(newAssignedNodes == critNode(2));
%         
%         freqs = availableFreqs;
%         if index1 < index2
%             freq = freq_alloc(critNode(1));
%             freqs(find(freqs == freq)) = []; %Removing channel first node assigned of the two had
%             freq_alloc(critNode(2)) = chooseFrequency(critNode(2), neighbourlist, I, freqs, freq_alloc); %Assigning a new channel
%         else
%             freq = freq_alloc(critNode(2));
%             freqs(find(freqs == freq)) = []; %Removing channel first node assigned of the two had
%             freq_alloc(critNode(1)) = chooseFrequency(critNode(1), neighbourlist, I, freqs, freq_alloc); %Assigning a new channel
%         end
%         
%         continue
%     else
%         critNode = critNode(2);
%     end
%     
%     newAssignedNodes(end+1) = critNode;
%     
%     if length(newAssignedNodes) == 1
%         freq = freq_alloc(critNode);
%         freqs = availableFreqs;
%         freqs(find(freqs == freq)) = []; %Removing channel node had
%         freq_alloc(critNode) = chooseFrequency(critNode, neighbourlist, I, freqs, freq_alloc); %Assigning a new channel
%     else
%         freq_alloc(critNode) = chooseFrequency(critNode, neighbourlist, I, availableFreqs, freq_alloc);
%     end
%     
%     dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
%     mindist = min(dminNew);
% %     
% %     if mindist > limit
% %         limit = mindist;
% %         consecutive = 0;
% %     end
%     
%     
% end





[value, index] = min(distances)
[valueFire, indexFire] = min(dminNew)
maxDmin

