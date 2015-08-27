clear all

% Number of APs
NP = 10;
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

[neighbourlist,I] = sort(neighbourlist,1,'descend');

initialPlot(Px, Py, Size, NP)

%Number of iterations
iterations = 10 * NP;

%Array with shortest distance for each selfish iteration
dmin = zeros(1, iterations);

%Array with frequencies for the nodes
freq_alloc = zeros(1, NP);

nodes = 1:NP; %Array with nodes

% Give all nodes a random frequency, not thinking about neighbours or
% anything
while ~isempty(nodes)
    node = nodes(randi(numel(nodes))); %Selecting random node
    nodes(find(nodes == node)) = []; %Removing node selected, preventing from selecting that node again
    freq_alloc(node) = availableFreqs(randi(numel(availableFreqs)));
end

distances = smallestDistanceSelfish(NP, d, freq_alloc); %Get shortest distances for each node to an interfering node
dmin(1) = min(distances); %Inserting smallest distance between interfering nodes into dmin

nodes = 1:NP; %Get the nodes array with the node numbers again

for i = 2:iterations
    node = nodes(randi(numel(nodes))); %Selecting random node
    freq = chooseFrequency(node, neighbourlist, I, availableFreqs, freq_alloc); %Choose best frequency based on neighbour list
    freq_alloc(node) = freq;
    
    distances = smallestDistanceSelfish(NP, d, freq_alloc); %Get shortest distances for each node to an interfering node
    dmin(i) = min(distances); %Inserting smallest distance between interfering nodes into dmin
end

frequencyPlot(Px, Py, Size, NP, freq_alloc, true)

figure()
plot(1:iterations, dmin)
hold on


%Running 100 simulations on topology to get optimal shortest distance
maxDmin = 0;
freq_allocSelfish = zeros(1, NP);
for it = 1:100
    freq_allocSelfish = selfishAllocation(NP, availableFreqs, neighbourlist, I, Px, Py, Size, d);
    dminSelf = smallestDistanceSelfish(NP, d, freq_allocSelfish);
    if min(dminSelf) > maxDmin
        maxDmin = min(dminSelf);
    end
end

plot(1:iterations, repmat(maxDmin, 1, iterations), 'k')
legend('with special start', 'Best smallest distance', 'Location', 'southeast')



consecutive = 0;
newAssignedNodes = [];

dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
mindist = min(dminNew);
limit = min(distances);
while mindist < maxDmin
    
    dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
    mindist = min(dminNew);
    
    %All nodes changed, start from beginning
    if length(newAssignedNodes) == NP
        consecutive = consecutive + 1;
        newAssignedNodes = [];
    end
    
    %If same distance is achieved 5 times, might be best distance
    if consecutive == 10
        break;
    end
    
    critNode = find(dminNew == mindist);
    if isempty(find(newAssignedNodes ==  critNode(1))) %If not in newAssignedNodes array
        critNode = critNode(1);
    elseif ~isempty(find(newAssignedNodes ==  critNode(2))) %If in newAssignedNodes array
        %Nodes with shortest distances has both got a new channel
        %assignment. Making sure they get different channels
        index1 = find(newAssignedNodes == critNode(1));
        index2 = find(newAssignedNodes == critNode(2));
        
        freqs = availableFreqs;
        if index1 < index2
            freq = freq_alloc(critNode(1));
            freqs(find(freqs == freq)) = []; %Removing channel first node assigned of the two had
            freq_alloc(critNode(2)) = chooseFrequency(critNode(2), neighbourlist, I, freqs, freq_alloc); %Assigning a new channel
        else
            freq = freq_alloc(critNode(2));
            freqs(find(freqs == freq)) = []; %Removing channel first node assigned of the two had
            freq_alloc(critNode(1)) = chooseFrequency(critNode(1), neighbourlist, I, freqs, freq_alloc); %Assigning a new channel
        end
        
        continue
    else
        critNode = critNode(2);
    end
    
    newAssignedNodes(end+1) = critNode;
    
    if length(newAssignedNodes) == 1
        freq = freq_alloc(critNode);
        freqs = availableFreqs;
        freqs(find(freqs == freq)) = []; %Removing channel node had
        freq_alloc(critNode) = chooseFrequency(critNode, neighbourlist, I, freqs, freq_alloc); %Assigning a new channel
    else
        freq_alloc(critNode) = chooseFrequency(critNode, neighbourlist, I, availableFreqs, freq_alloc);
    end
    
    dminNew = smallestDistance(NP, d, freq_alloc); %Calculating new smallest distances
    mindist = min(dminNew);
%     
%     if mindist > limit
%         limit = mindist;
%         consecutive = 0;
%     end
    
    
end





min(distances)
min(dminNew)
maxDmin