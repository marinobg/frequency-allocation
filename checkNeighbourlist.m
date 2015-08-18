function nodeAssigned = checkNeighbourlist(nlist, I, node, nextAP)
%Funtion that check if a node have a node in its neighbour list that
%already is allowed to choose a frequency


interfering = I(:, node);
for i = 1:length(nlist)
    if nlist(i) == inf
        interfering(i) = 0; %Mark which APs to remove, not detected in neighbour list
    end
end

interfering = interfering(find(interfering)); %Removing APs that are not detected

for AP = nextAP
    for i = 1:length(interfering)
        if interfering(i) == AP
            nodeAssigned = false; %This node can not assign a frequency in the initial phase
            return
        end
    end
end

nodeAssigned = true;

end