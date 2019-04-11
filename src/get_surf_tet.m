function [surl,ix]=get_surf_tet(elm)
s1=elm(:,1:3);
s2=elm(:,2:4);
s3=elm(:,[1 2 4]);
s4=elm(:,[1 3 4]);
sall=[s1; s2; s3 ;s4];
sur=sort(sall')';
sur=sortrows(sur);
d=sur(1:end-1,1:size(sur,2))==sur(2:end,1:size(sur,2));
ix=find(sum(d')==3)+1;
ix2=ix-1;
ixx=[ix ix2];
nfac=size(sur,1);
flist=ones(nfac,1);
flist(ixx)=0;
ix=find(flist>0);
surl=zeros(length(ix),size(sur,2));
surl(1:length(ix),1:size(sur,2))=sur(ix,1:size(sur,2));
surl=int32(surl);
