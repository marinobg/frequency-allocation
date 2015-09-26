function [dminste, V, Ex]=dminst (d)
% finds the smallest distance dminste 
%kanalplanen channel
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
    end
end
dx=sort(ds);


id=length(dx);
chano=zeros(id,1);


for i=2:id
    [V,E]=Vertex(d,dx(i));
    ch=dsatur(V,E);
    chano(i)=max(ch); 
    if chano(i)==3;
        dminste=dx(i);
        Ex=E;
    else
    end
    
  
end





end