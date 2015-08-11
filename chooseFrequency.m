function freq = chooseFrequency(AP, neighbourlist, I, availableFreqs, freq_alloc)

nlistAP = neighbourlist(:, AP); %Get neighbourlist of the specific AP
detectedAPs = I(:, AP); %Get list of interfering APs

for i = length(nlistAP):-1:1 %Starts with the closest (most critical) AP first
    if nlistAP(i) == Inf
        break
    end
    
    interferingAP = detectedAPs(i);
    if freq_alloc(interferingAP)
        frequency = freq_alloc(interferingAP); %Channel to be removed
        availableFreqs(find(availableFreqs == frequency)) = []; %Remove (most) interfering channels
    end
    
    if length(availableFreqs) == 1 %The best channel to choose is left
        break
    end
end

freq = availableFreqs(randi(numel(availableFreqs))); %Select random channel of those channels left

end