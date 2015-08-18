function dminSelf = smallestDistanceSelfish(NP, d, freq_allocSelfish)

dminSelf = ones(1, NP) * inf; %Vector with shortest distance for APs

%Finding the shortest distance for AP i to j with equal frequency from the
%selfish allocation
for i = 1:length(d)
    for j = 1:length(d)
        if i ~= j && d(i,j) < dminSelf(i) && freq_allocSelfish(i) == freq_allocSelfish(j)
            dminSelf(i) = d(i,j);
        end
    end
end

end