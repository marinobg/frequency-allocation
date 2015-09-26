function [V,E]=Vertex(d,dmin)
% assignes Vertex index values V and
% Edges E from a quadratic distance matrix d
% by first converting it to a graph problem by assigning edges
% to all distances less or eqaul to dmin
n=size(d,1);
V=zeros(n,1);
e=0;
for i=1:n
    V(i)=i;
    for j=1:i
        if d(i,j)<dmin
            if i==j 
            else
                e=e+1;
            E(e,1)=i;
            E(e,2)=j;
            end
            
        end
    end
end
