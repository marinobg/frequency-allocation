function freq_alloc = chooseFrequency(freq_alloc, availableFreqs, col_indexes, I, neighbourlist)

if length(col_indexes) == 1 %Only one AP to assign
    for i = length(neighbourlist):-1:1
        if neighbourlist(i, col_indexes) == 0 %The next APs are out of range
            break
        end
        AP = I(i, col_indexes);
        if freq_alloc(AP) ~= 0
            freq = freq_alloc(AP);
            index = find(availableFreqs == freq);
            availableFreqs(index) = []; %Removing channels that will interfere the most
            
            if length(availableFreqs) == 1 %If only one channel to choose left
                break
            end
        end
        
    end
    
    %Choose one of the available channels
    freq_alloc(col_indexes) = availableFreqs(randi(numel(availableFreqs)));
    
end
end