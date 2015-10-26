
clear all
clf(figure(1))
clf(figure(2))
clf(figure(3))
floors=8;
dmin1=5;
  ampl=1; 
NP=8*floors;
xn=zeros(NP,1);
yn=zeros(NP,1);
xn=zeros(NP,1);

x=[6 10 14];
y=[6 10 14];

for i=1: floors
    z(i)=2+4*(i-1);
end

for j=1:floors
    for i=1:8
         zn(i+(j-1)*8)=z(j);
        if i<4
            
        yn(i+(j-1)*8)=y(i);
        xn(i+(j-1)*8)=x(1);
        end
        
        if i==4 
            xn(i+(j-1)*8)=x(2);
            yn(i+(j-1)*8)=y(3);
        end
        if i==5
            xn(i+(j-1)*8)=x(3);
            yn(i+(j-1)*8)=y(3);
        end
        if i==6
            xn(i+(j-1)*8)=x(3);
            yn(i+(j-1)*8)=y(2);
        end
        if i==7
            xn(i+(j-1)*8)=x(3);
            yn(i+(j-1)*8)=y(1);
        end
        if i==8
            xn(i+(j-1)*8)=x(2);
            yn(i+(j-1)*8)=y(1);
        end
    end
end

%figure(1)
%plot3(xn,yn,zn,'ko-' )

for i=1:NP
    xn(i)=xn(i)+ampl*(0.5-rand(1,1));
    yn(i)=yn(i)+ampl*(0.5-rand(1,1));
    zn(i)=zn(i)+ampl*(0.5-rand(1,1));
end





d = ones(NP) * inf;
nlist = d;
for i = 1:NP
    for j = 1:NP
        d(i,j) = sqrt((xn(i)-xn(j))^2 + (yn(i)-yn(j))^2+ (zn(i)-zn(j))^2);
    end %j
end %i

%**************************************** include SELFISH
% Px=xn;
Py=yn;
Pz=zn;

availableFreqs = [1, 6, 11];
[neighbourlist,I] = sort(d,1,'descend');



%Number of iterations
iterations = 10 * NP + 1;

%Array with shortest distance for each selfish iteration
dmin = zeros(1, iterations);

%Array with frequencies for the nodes
freq_allocSelf = zeros(1, NP);

nodes = 1:NP; %Array with nodes

% Give all nodes a random frequency, not thinking about neighbours or
% anything
while ~isempty(nodes)
    node = nodes(randi(numel(nodes))); %Selecting random node
    nodes(find(nodes == node)) = []; %Removing node selected, preventing from selecting that node again
    freq_allocSelf(node) = availableFreqs(randi(numel(availableFreqs)));
end

freq_allocRemember = freq_allocSelf; %Start point for FIRE too

distances = smallestDistance(NP, d, freq_allocSelf); %Get shortest distances for each node to an interfering node
dmin(1) = min(distances); %Inserting smallest distance between interfering nodes into dmin

nodes = 1:NP; %Get the nodes array with the node numbers again

for i = 2:iterations
    node = nodes(randi(numel(nodes))); %Selecting random node
    freq = chooseFrequency(node, neighbourlist, I, availableFreqs, freq_allocSelf); %Choose best frequency based on neighbour list
    freq_allocSelf(node) = freq;
    
    distances = smallestDistance(NP, d, freq_allocSelf); %Get shortest distances for each node to an interfering node
    dmin(i) = min(distances); %Inserting smallest distance between interfering nodes into dmin
end
freq_allocSelf
figure(4)
plot(dmin)
% figure (3)
% frequencyPlot3(Px, Py, Pz, floors, NP, freq_allocSelf, true)
%****************************************

n=size(d,1);
V=zeros(n,1);
e=0;
for i=1:n
    V(i)=i;
    for j=1:i
        if d(i,j)<dmin1
            if i==j 
            else
                e=e+1;
            E(e,1)=i;
            E(e,2)=j;
            end
            
        end
    end
end

% plots graf

n=length(V);
e=length(E(:,1));
figure(2)
plot3(xn,yn,zn,'o', 'markersize', 1)
zmax=floors*4;
axis([0 16 0 16 0 zmax])

hold on
%axis([ 0 Size 0 Size])
lables = cellstr(num2str([1:n]'));
text(xn,yn,zn, lables, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
%text is plotting a label on each node in the topology (numbers from 1 to NP)
xl=zeros(2,1);
yl=zeros(2,1);
zl=zeros(2,1);

hold on

for i=1:e
    xl(1)=xn(E(i,1));
    xl(2)=xn(E(i,2));
    yl(1)=yn(E(i,1));
    yl(2)=yn(E(i,2));
    zl(1)=zn(E(i,1));
    zl(2)=zn(E(i,2));
    plot3(xl,yl,zl);
end

n=size(d,1);
V=zeros(n,1);
N=n*(n-1)/2;
ds=zeros(N,1);
dsort=sort(d);
e=0;
for i=1:n
    for j=i+1:n
        e=1+e;
        ds(e)=d(i,j);
        fra(e)=i;
        til(e)=j;
    end
end
[dx,II]=sort(ds);




id=length(dx);
chano=zeros(id,1);
ima=min(round(2.522*n),N);

for i=6:ima
 
    [V,E]=Vertex(d,dx(i));
    ch=dsatur(V,E);
    chano(i)=max(ch);
    clz=length(E(:,1));
    cnz=length(ch);
    ddy(i)=dx(i);
    cxx(i)=i;
    chan(i)=chano(i);
   
    
    if chano(i)==3;
        dminste=dx(i);
        channels=ch;
        
        Ex=E;
        ix=i;
    else
    end
    
  
end
ix
dminste


plot3(xn,yn,zn,'o', 'markersize', 1)

%channels

for i=1:NP
    if channels(i)==1
    plot3(xn(i),yn(i),zn(i),'bo', 'markersize', 10)
    end
    if channels(i)==2
    plot3(xn(i),yn(i),zn(i),'ro', 'markersize', 10)
    end
    if channels(i)==3
    plot3(xn(i),yn(i),zn(i),'go', 'markersize', 10)
    end
    
end
lables = cellstr(num2str([1:n]'));
text(xn,yn,zn, lables, 'VerticalAlignment','bottom', 'HorizontalAlignment','right')
%text is plotting a label on each node in the topology (numbers from 1 to NP)
    

    xl(1)=xn(fra(II(ix+1)));
    xl(2)=xn(til(II(ix+1)));
    yl(1)=yn(fra(II(ix+1)));
    yl(2)=yn(til(II(ix+1)));
    zl(1)=zn(fra(II(ix+1)));
    zl(2)=zn(til(II(ix+1)));
    plot3(xl,yl,zl, 'k-','LineWidth',5, 'markersize', 20);
 
figure(1)
plot(cxx,chan,'b-', cxx,ddy,'r-','markersize', 10)
hold on
axis([6 ima 0 8])
plot([ix ix], [0 8],'k-','markersize', 10)
grid
hold off