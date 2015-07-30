function freq_alloc = chooseFrequency(freq_alloc, availableFreqs, col_indexes, I, neighbourlist)

if length(col_indexes) == 1 %Only one AP to assign
    col_indexes = nextAP;
    %Choose one of the available channels
    freq_alloc(nextAP) = bestChannel(neighbourlist, nextAP, I, freq_alloc, availableFreqs);
    
else
    invmeters = sumInverseMeters(col_indexes, neighbourlist, I);
    
    while length(invmeters) > 0
        index = find(invmeters == max(invmeters));
        invmeters(index) = [];
        nextAP = col_indexes(index); %AP to get channel assigned
        col_indexes(index) = []; %Removing element
        
        %Choose one of the available channels
        freq_alloc(nextAP) = bestChannel(neighbourlist, nextAP, I, freq_alloc, availableFreqs);
    end
end
end