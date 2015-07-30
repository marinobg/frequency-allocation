function invmeters = sumInverseMeters(col_indexes, neighbourlist, I)

%Fiding the most critical node of the nodes chosen with shortest distance
%(probably just two)
invmeters = zeros(1, length(col_indexes));
for i = 1:length(neighbourlist)
    for j = 1:length(neighbourlist)
        if any(I(i,j) == col_indexes)
            index = find(I(i,j) == col_indexes);
            invmeters(index) = invmeters(index) + neighbourlist(i,j);
        end
    end
end

end