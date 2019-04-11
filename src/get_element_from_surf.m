function ix=get_element_from_surf(surf,elm);
% function ix=get_element_from_surf(surf,elm);
% searches the elments belonging to surface surf
% works only for tetrahedrons

cf=sort(surf,2);
ne=size(elm,1);
f1=sort(elm(:,[1 2 3]),2);
f2=sort(elm(:,[2 3 4]),2);
f3=sort(elm(:,[1 2 4]),2);
f4=sort(elm(:,[1 3 4]),2);
ix_list=int32(zeros(ne*4,1));
for i=1:4
    ix_list(((i-1)*ne+1):i*ne)=1:ne;
end
ff=[f1;f2;f3;f4];
[dd,ixx]=intersect(uint32(ff),uint32(cf),'rows');
ix=ix_list(ixx);
%ix=unique(ix);
ix=int32(ix);