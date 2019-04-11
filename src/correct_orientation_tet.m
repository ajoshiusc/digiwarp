function S_new=correct_orientation_tet(S,T,r)
% S_new=correct_orientation_tet(S,T,r)
% corrects the orientstion of the surface triangles in S such that they point
% out from the volume tesselated by the tetrahedrons T.
% The coordinate list is contained in r
% (c) 2003 Felix Darvas, Ph.D.
% SIPI, University of Southern California
ix=get_element_from_surf(S,T);
h=waitbar(0,'correct surface orientation');
kk=0;
S_new=S;
ds=size(S,1)/100;
for i=1:size(S,1)
    tix=ix(i);
    rt=r(S(i,:),:);
    a=rt(3,:)-rt(1,:);
    b=rt(2,:)-rt(1,:);
    n=cross(a,b);
    n=n/norm(n);
    rct=mean(rt);
    rth=r(T(tix,:),:);
    rcth=mean(rth);
    inw=rcth-rct;
    if(dot(inw,n)>0)
        S_new(i,:)=S(i,[1 3 2]);
    end
    kk=kk+1;
    if(kk>ds)
        kk=0;
        waitbar(i/size(S,1));
    end
end
close(h);