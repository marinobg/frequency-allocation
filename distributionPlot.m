function distributionPlot(neighbourlist, NP)

bin = zeros(1,50);

for i = 1:NP
    for j = 1:NP
        if neighbourlist(i,j) ~= 0
            elem = neighbourlist(i,j);
            index = roundn(elem, -2) * 100; %Round to closest hundreth
            index = int8(index);
            if index > 50
                index = 50;
            end
            bin(index) = bin(index) + 1;
        end
    end
end

plot(0.01:0.01:0.50, bin)
xlabel('metrikk')
ylabel('antall')


diffnlist = zeros(sum(1:NP-1)+1,NP); %Array with difference between metrics as elements

for col = 1:NP
    index = 1; %Keep track of where to insert an element into diffnlist
    for row = 1:NP
        if neighbourlist(row,col) == 0
            index = index + 1;
            continue
        end
        
        elem = neighbourlist(row, col); %Non-zero element
        for row2 = row:NP %Calculates differences for the non-zero element and the other non-zero elements in the neighbour list
            diff = abs(elem - neighbourlist(row2, col));
            diffnlist(index, col) = diff;
            index = index + 1;
        end
    end
end

diffnlist = sort(diffnlist, 1, 'ascend');

bin = zeros(1, 10000);
for i = 1:length(diffnlist)
    for j = 1:NP
        if diffnlist(i,j) ~= 0
            elem = diffnlist(i,j);
            index = roundn(elem, -4) * 10000; %Round to closest thousandth
            index = int64(index);
            if index > 10000
                index = 10000;
            elseif index < 1
                index = 1;
            end
            bin(index) = bin(index) + 1;
        end
    end
end

figure()
plot(0.0001:0.0001:1.000, bin)
xlabel('differanse')
ylabel('antall')






% Array with how many neighbour lists with a certain amount of numbers. Goes
% from zero to NP-1 numbers in neighbourlist
antForekomster = zeros(1, NP);
for col = 1:NP
    nonzero = length(find(neighbourlist(:, col))); %Finding number of nodes detected by AP
    antForekomster(nonzero+1) = antForekomster(nonzero+1) + 1;
end

figure()
bar(0:NP-1, antForekomster)
axis([0 NP-1 0 max(antForekomster+1)])
xlabel('Number of nodes detected')
ylabel('Number of neighbourlists')
hold on


%Creating theoretical poisson distribution
discovered = 0;
for i = 1:NP
    discovered = discovered + length(find(neighbourlist(:,i))); %How many nodes discovered in each neighbourlist
end
lambda = discovered / NP; %Expected value of nodes discovered by an AP (fixed radius)
probabilities = poisspdf(0:NP-1, lambda);

plot(0:NP-1, probabilities*sum(antForekomster), 'r')
axis([0 NP-1 0 max(probabilities*sum(antForekomster))])



end