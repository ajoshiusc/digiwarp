%||AUM||
%||Shree Ganeshaya namaha||
function [v]=downsample_zeropad_img(v,XD,YD,ZD,pad)

if (XD==1)&&(YD==1)&&(ZD==1)
    return
end
v.img=v.img(1:XD:end,1:YD:end,1:ZD:end);
Msize=size(v.img);
%Msize=Msize./[XD,YD,ZD];
ZZ=zeros(Msize+2*pad);

[X,Y,Z]=ndgrid(1:Msize(1),1:Msize(2),1:Msize(3));

X=reshape(X,Msize(1)*Msize(2)*Msize(3),1)+pad;
Y=reshape(Y,Msize(1)*Msize(2)*Msize(3),1)+pad;
Z=reshape(Z,Msize(1)*Msize(2)*Msize(3),1)+pad;

ZZ(sub2ind(Msize+2*pad,X,Y,Z))=v.img;
v.img=ZZ;
%Msize=Msize+2*pad;
res=double(v.hdr.dime.pixdim(2:4));
res=res.*[XD,YD,ZD];
v.hdr.dime.pixdim(2:4)=res;
v.hdr.dime.dim(2:4)=size(v.img);

