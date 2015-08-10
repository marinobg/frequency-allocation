function distancePlot(d, freq_alloc, NP, freq_allocSelfish)

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

%Make the shortest distance appear on channel 6
[~, index] = min(dmin);

if freq_alloc(index) ~= 6
    changeVar = freq_alloc(index); %Finding the channel with shortest distance
    fbestCopy = freq_alloc; %Creates a copy
    fbestCopy(fbestCopy==changeVar) = 6; %Changes all elements in fbestCopy that had value changeVar to 6
    fbestCopy(freq_alloc==6) = changeVar; %Changes those elements in fbestCopy that is 6 in fbestCopy and also 6 in fbest
    freq_alloc = fbestCopy;
end


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

%Make the shortest distance appear on channel 6
[~, index] = min(dminSelf);

if freq_allocSelfish(index) ~= 6
    changeVar = freq_allocSelfish(index); %Finding the channel with shortest distance
    fbestCopy = freq_allocSelfish; %Creates a copy
    fbestCopy(fbestCopy==changeVar) = 6; %Changes all elements in fbestCopy that had value changeVar to 6
    fbestCopy(freq_allocSelfish==6) = changeVar; %Changes those elements in fbestCopy that is 6 in fbestCopy and also 6 in fbest
    freq_allocSelfish = fbestCopy;
end

figure(4)
hold on
xlabel('Distance (meter)')
ylabel('Channels')

%Change numbers visible on y-axis
set(gca, 'YTick', [1 6 11]);
set(gca, 'YTickLabel', [1 6 11]);

var = {1, 2};
freq_alloc
freq_allocSelfish
dmin
dminSelf

%Plot shortest distances at same frequencies
for i = 1:length(dmin)
    if dminSelf(i) ~= 0 %Ploting distances for selfish assignment
        col = sprintf('%s%s', color(freq_allocSelfish, i), '+');
        if freq_allocSelfish(i) ~= 11
            var{1} = plot(dminSelf(i), freq_allocSelfish(i)+1, col, 'linewidth', 12);
        else
            var{1} = plot(dminSelf(i), freq_allocSelfish(i)-1, col, 'linewidth', 12);
        end
    end
    
    if dmin(i) ~= 0 %Ploting distances for smart frequency allocation
        col = sprintf('%s%s', color(freq_alloc, i), 'x');
        var{2} = plot(dmin(i), freq_alloc(i), col, 'linewidth', 15);
    end
end

%Plot lines with all possible distances
for i = 1:length(d) %Rows
    for j = 1:length(d) %Columns
        if j > i
            line([d(i,j), d(i,j)], [0 11+1])
            axis([0 max(max(d))+1 1 11])
        end
    end
end

lgnd = legend([var{1}, var{2}], {'Selfish', 'Smart allocation'});
set(lgnd, 'color', 'none'); %Make legend transparent

end