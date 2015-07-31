clear all

% Number of APs
NP = 5;

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

neighbourlist

I

freq_alloc = zeros(1, NP); %Vector with the channels each AP get assigned

alone = find(neighbourlist(NP, :) == 0); %Check if some APs doesn't detect other APs
if alone
    %Since these APs doesn't interefere other APs, they can just get a
    %random channel assigned
    for i = 1:length(alone)
        AP = alone(i);
        freq_alloc(AP) = availableFreqs(randi(numel(availableFreqs))); %Select random channel
        neighbourlist(:, AP) = []; %Remove the APs neighbourlist, as it is not interesting anymore
    end
end


while length(find(freq_alloc)) < NP
    maxval = max(neighbourlist(NP,:));
    AP = find(neighbourlist(NP,:) == maxval);
    
    if length(AP) == 1
        freq = chooseFrequency(AP, neighbourlist, I, availableFreqs, freq_alloc); %Finds optimal frequency for AP
        freq_alloc(AP) = freq; %Assign frequency
        neighbourlist(:, AP) = []; %Remove the APs neighbourlist, as it is not interesting anymore
        
    else %Skriver for at den virker for 2. Kan oppstå flere enn to (liten sjans). MÅ DA SKRIVE OM!
        invmeters = sumInverseMeters(AP, neighbourlist, I); %Find most critical AP, sum of all inversemeter value for the APs
    end
    
end

        
    

%TODO: FINN EN MÅTE Å LØSE PROBLEMET MED FREKVENSALLOKERINGEN. ANTAR EN HAR
%OVERORDNET OVERSIKT. FINN MEST KRITISKE PAR, GI DEM EN FREKVENS. DETTE
%RAPPORTERES INN OG SÅ FJERNES DISSE NODENE FRA NABOLISTENE TIL DE ANDRE
%NODENE. EVT. SÅ KAN NABOLISTENE TIL DE SOM HAR FÅTT FREKVENS FJERNES

%Fiding the most critical node of the nodes chosen with shortest distance
%(probably just two) (Assume it is just two for now)
%invmeters = sumInverseMeters(col_indexes, neighbourlist, I);