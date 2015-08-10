clear all

% Number of APs
NP =10;

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


[neighbourlist,I] = sort(neighbourlist,1,'ascend');

%distributionPlot(neighbourlist, NP) %Plot med fordeling av metrikkene

neighbourlist

I

freq_allocSelfish = selfishAllocation(NP, availableFreqs, neighbourlist, I, Px, Py, Size, d);

freq_alloc = zeros(1, NP); %Vector with the channels each AP get assigned

alone = find(neighbourlist(NP, :) == 0); %Check if some APs doesn't detect other APs
if alone
    %Since these APs doesn't interefere other APs, they can just get a
    %random channel assigned
    for i = 1:length(alone)
        AP = alone(i);
        freq_alloc(AP) = availableFreqs(randi(numel(availableFreqs))); %Select random channel
        frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
    end
end

while length(find(freq_alloc)) < NP
    maxval = max(neighbourlist(NP,:));
    AP = find(neighbourlist(NP,:) == maxval);
    
    if length(AP) == 1
        freq = chooseFrequency(AP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
        freq_alloc(AP) = freq; %Assign frequency
        neighbourlist(NP, AP) = 0; %"Remove" the APs neighbourlist, as it is not interesting anymore. Set value to zero to ignore AP
        frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
        
    else
        invmeters = sumInverseMeters(AP, neighbourlist, I); %Find most critical AP, sum of all inversemeter value for the APs
        
        
        while ~isempty(invmeters)
            [~, index] = max(invmeters); %Finds index of max value in invmeters
            critAP = AP(index); %Choose the most critical AP of the APs already chosen
            
            freq = chooseFrequency(critAP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
            freq_alloc(critAP) = freq; %Assign frequency
            neighbourlist(NP, critAP) = 0; %"Remove" the APs neighbourlist, as it is not interesting anymore
            
            %Remove value from invmeters and the AP assigned
            invmeters(index) = [];
            AP(index) = [];
            
            frequencyPlot(Px, Py, Size, NP, freq_alloc, false)
        end %while
        
    end %if
    
end %while



%Creating distance plot
distancePlot(d, freq_alloc, NP, freq_allocSelfish)