function invmeters = sumInverseMeters(AP, neighbourlist, I)

%Fiding the most critical node of the nodes chosen with shortest distance
%(probably just two)
invmeters = zeros(1, length(AP));
for i = 1:length(neighbourlist)
    for j = 1:length(neighbourlist)
        if any(I(i,j) == AP)
            index = find(I(i,j) == AP);
            invmeters(index) = invmeters(index) + neighbourlist(i,j);
        end
    end
end

end