function initialPlot(Px, Py, Size, NP)

%Creates a plot of the topology before any channels are assigned

figure(1)
plot(Px,Py,'x', 'markersize', 8)
axis([ 0 Size 0 Size])
lables = cellstr(num2str([1:NP]'));
text(Px, Py, lables, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
%text is plotting a label on each node in the topology (numbers from 1 to NP)

end