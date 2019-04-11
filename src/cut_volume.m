function T=cut_volume(T,x,th)
ss=(x(T(:,1))<th)+(x(T(:,2))<th)+(x(T(:,3))<th)+(x(T(:,4))<th);
T(find(ss>0),:)=[];