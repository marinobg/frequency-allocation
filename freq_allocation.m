clear all

% Number of APs
NP = 5;

% max dista5ce between points
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
freq_allocSelfish = [11 6 6 1 1];

freq_alloc = zeros(1, NP); %Vector with the channels each AP get assigned

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

%%Version 2 of frequency allocation with neighbourlists

%First finds closest pair of nodes
minval = min(neighbourlist(NP,:)); %Minimum distance
AP = find(neighbourlist(NP,:) == minval); %Closest APs in the topology

for nextAP = AP %Assign the nodes in the closest pair to a channel
    freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
    freq_alloc(nextAP) = freq; %Assign frequency
    frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
end

%%%
%Test to see5 if the node that are closest to both of the nodes in the most
%critical pair (sum of distances) should be chosen next
% minsum = inf;
% for col = 1:NP
%     if sum(neighbourlist(AP,:)) < minsum
%         nextAP = col;
%         minsum = sum(neighbourlist(AP,:));
%     end
% end
% 
% freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc);
% freq_alloc(nextAP) = freq;
% frequencyPlot(Px, Py, Size, NP, freq_alloc, false)

%%%

while length(find((freq_alloc))) < NP %Assign the other APs to a channel
    indexes = find(freq_alloc); %Find links that are assigned to a frequency
    nextAP = findSmallestDist(d, indexes); %Finds next link to be assigned to a frequency
    
    freq = chooseFrequency(nextAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
    freq_alloc(nextAP) = freq; %Assign frequency
    frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
end






%%Version 1 of frequency allocation with neighbourlists

% while length(find(freq_alloc)) < NP
%     maxval = max(neighbourlist(NP,:));
%     AP = find(neighbourlist(NP,:) == maxval);
%     
%     if length(AP) == 1
%         freq = chooseFrequency(AP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
%         freq_alloc(AP) = freq; %Assign frequency
%         neighbourlist(NP, AP) = 0; %"Remove" the APs neighbourlist, as it is not interesting anymore. Set value to zero to ignore AP
%         frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
%         
%     else
%         invmeters = sumInverseMeters(AP, neighbourlist, I); %Find most critical AP, sum of all inversemeter value for the APs
%         
%         
%         while ~isempty(invmeters)
%             [~, index] = max(invmeters); %Finds index of max value in invmeters
%             critAP = AP(index); %Choose the most critical AP of the APs already chosen
%             
%             freq = chooseFrequency(critAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
%             freq_alloc(critAP) = freq; %Assign frequency
%             neighbourlist(NP, critAP) = 0; %"Remove" the APs neighbourlist, as it is not interesting anymore
%             
%             %Remove value from invmeters and the AP assigned
%             invmeters(index) = [];
%             AP(index) = [];
%             
%             frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
%         end %while
%         
%     end %if
%     
% end %while



%Creating distance plot
distancePlot(d, freq_alloc, NP, freq_allocSelfish)