function col_indexes = getColumnIndexes(modNeighbourlist, NP)

maxval = max(modNeighbourlist(5,:)); %Getting maximum value in neighbourlist

%Getting the column index of the values with value=maxval
col_indexes = find(modNeighbourlist == maxval);
col_indexes = col_indexes / NP;

end