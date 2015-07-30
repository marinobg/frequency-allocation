function channel = bestChannel(neighbourlist, nextAP, I, freq_alloc, availableFreqs)

for i = length(neighbourlist):-1:1
    if neighbourlist(i, nextAP) == 0 %The next APs are out of range
        break
    end
    AP = I(i, nextAP);
    if freq_alloc(AP) ~= 0
        freq = freq_alloc(AP);
        index = find(availableFreqs == freq);
        availableFreqs(index) = []; %Removing channels that will interfere the most
        
        if length(availableFreqs) == 1 %If only one channel to choose left
            break
        end
    end
    
end

channel = availableFreqs(randi(numel(availableFreqs)));

end