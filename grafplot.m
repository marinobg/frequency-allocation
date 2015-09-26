function [ ]=grafplot(V,E,Px,Py,Size)
% plots graf

n=length(V);
e=length(E(:,1));
hold on

figure(1)
plot(Px,Py,'o', 'markersize', 8)
axis([ 0 Size 0 Size])
lables = cellstr(num2str([1:n]'));
text(Px, Py, lables, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
%text is plotting a label on each node in the topology (numbers from 1 to NP)
x=zeros(2,1);
y=zeros(2,1);
hold on
for i=1:e
    x(1)=Px(E(i,1));
    x(2)=Px(E(i,2));
    y(1)=Py(E(i,1));
    y(2)=Py(E(i,2));
    plot(x,y);
end
end