function freq_allocSelfish = selfishAllocation(NP, availableFreqs, neighbourlist, I, Px, Py, Size, d)

freq_allocSelfish = zeros(1, NP);
nodes = 1:NP;


while ~isempty(nodes)
    node = nodes(randi(numel(nodes))); %Selecting random node
    nodes(find(nodes == node)) = []; %Removing node selected, preventing from selecting that node again
    freq = chooseFrequency(node, neighbourlist, I, availableFreqs, freq_allocSelfish);
    freq_allocSelfish(node) = freq;
    freq_allocSelfish = [6 6 1 1 11 11 11 1 6 1]; %DENNE MÅ SLETTES!!!
    frequencyPlot(Px, Py, Size, NP, freq_allocSelfish, true)
    
end

%freq_allocSelfish
%distancePlot(d, freq_alloc, NP, true)

end