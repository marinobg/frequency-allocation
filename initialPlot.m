function initialPlot(Px, Py, Size, NP)

figure(1)
plot(Px,Py,'x', 'markersize', 8)
axis([ 0 Size 0 Size])
lables = cellstr(num2str([1:NP]'));
text(Px, Py, lables, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')

end