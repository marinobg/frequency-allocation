function frequencyPlot(Px, Py, Size, NP, freq_alloc)

waitforbuttonpress;

figure()
hold on
axis([ 0 Size 0 Size])

%Creates cellarray for the plots
var = {1, NP};

for i = 1:length(freq_alloc)
    marker = sprintf('%sx', color(freq_alloc, i));
    var{i} = plot(Px(i), Py(i), marker, 'markersize', 12, 'linewidth', 3);
end

%Find out which plots to use in legend
if length(find(freq_alloc)) == NP
    handlesToUse = zeros(1, 3);
    counter = 1;
    for i = 1:5:11
        index = find(freq_alloc == i);
        index = index(1);
        handlesToUse(counter) = index;
        counter = counter + 1;
    end
    
else
    handlesToUse = zeros(1, 4);
    counter = 1;
    for i = 1:5:11
        index = find(freq_alloc == i);
        if isempty(index)
            continue
        end
        index = index(1);
        handlesToUse(counter) = index;
        counter = counter + 1;
    end
    %If not channel assigned yet
    index = find(freq_alloc == 0);
    index = index(1);
    handlesToUse(counter) = index;
end

lables = cellstr(num2str([1:NP]'));
text(Px, Py, lables, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')

if length(handlesToUse) == 3
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}, var{handlesToUse(3)}], {'Channel 1', 'Channel 6', 'Channel 11'})

elseif isempty(find(freq_alloc == 1)) && isempty(find(freq_alloc == 6))
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}], {'Channel 11', 'Channel not assigned'})

elseif isempty(find(freq_alloc == 1)) && isempty(find(freq_alloc == 11))
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}], {'Channel 6', 'Channel not assigned'})

elseif isempty(find(freq_alloc == 6)) && isempty(find(freq_alloc == 11))
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}], {'Channel 1', 'Channel not assigned'})
    
elseif isempty(find(freq_alloc == 1))
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}, var{handlesToUse(3)}], {'Channel 6', 'Channel 11', 'Channel not assigned'})
    
elseif isempty(find(freq_alloc == 6))
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}, var{handlesToUse(3)}], {'Channel 1', 'Channel 11', 'Channel not assigned'})
    
elseif isempty(find(freq_alloc == 11))
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}, var{handlesToUse(3)}], {'Channel 1', 'Channel 6', 'Channel not assigned'})
    
else
    legend([var{handlesToUse(1)}, var{handlesToUse(2)}, var{handlesToUse(3)}, var{handlesToUse(4)}], {'Channel 1', 'Channel 6', 'Channel 11', 'Channel not assigned'})
end

end