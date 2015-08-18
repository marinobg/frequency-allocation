function dmin = smallestDistance(NP, d, freq_alloc)

dmin = ones(1, NP) * inf; %Vector with shortest distance for APs

%Finding the shortest distance for AP i to j with equal frequency from the
%smart frequency allocation
for i = 1:length(d)
    for j = 1:length(d)
        if i ~= j && d(i,j) < dmin(i) && freq_alloc(i) == freq_alloc(j)
            dmin(i) = d(i,j);
        end
    end
end

end