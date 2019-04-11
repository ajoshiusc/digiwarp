function [Dx,Dy,Dz]=myget_tet_grad(tmesh)
T=tmesh.faces;X=tmesh.vertices(:,1);Y=tmesh.vertices(:,2);Z=tmesh.vertices(:,3);
NumT=size(T,1);
NumVertx=size(X,1);
%NumPinnedVertx=size(pinnedVertx,1);
%NumfreeVertx=size(X,1)-NumPinnedVertx;
v_1=T(:,1);v_2=T(:,2);v_3=T(:,3);v_4=T(:,4);
x1=X(v_1);x2=X(v_2);x3=X(v_3);x4=X(v_4);
y1=Y(v_1);y2=Y(v_2);y3=Y(v_3);y4=Y(v_4);
z1=Z(v_1);z2=Z(v_2);z3=Z(v_3);z4=Z(v_4);

D=((x2-x1).*((z4-z1).*(y3-y1)-(y4-y1).*(z3-z1))- ...
    (y2-y1).*((x3-x1).*(z4-z1)-(x4-x1).*(z3-z1))+ ...
    (z2-z1).*((x3-x1).*(y4-y1)-(y3-y1).*(x4-x1)));
D=[D,D,D,D];
tmp_1=[z3.*y4-y3.*z4+y2.*z4-y4.*z2-y2.*z3+y3.*z2, y3.*z4-z3.*y4-y1.*z4+y4.*z1+y1.*z3-y3.*z1, z2.*y4-y2.*z4+y1.*z4-y4.*z1-y1.*z2+y2.*z1, y2.*z3-z2.*y3-z3.*y1+z1.*y3+y1.*z2-z1.*y2];
tmp_2=-[z3.*x4-x3.*z4+x2.*z4-x4.*z2-x2.*z3+x3.*z2, x3.*z4-z3.*x4-x1.*z4+x4.*z1+x1.*z3-x3.*z1, z2.*x4-x2.*z4+x1.*z4-x4.*z1-x1.*z2+x2.*z1, x2.*z3-z2.*x3-z3.*x1+z1.*x3+x1.*z2-z1.*x2];
tmp_3=[y3.*x4-x3.*y4+x2.*y4-x4.*y2-x2.*y3+x3.*y2, x3.*y4-y3.*x4-x1.*y4+x4.*y1+x1.*y3-x3.*y1, y2.*x4-x2.*y4+x1.*y4-x4.*y1-x1.*y2+x2.*y1, x2.*y3-y2.*x3-y3.*x1+y1.*x3+x1.*y2-y1.*x2];
tmp_1=tmp_1./D;tmp_2=tmp_2./D;tmp_3=tmp_3./D;

rowno=3*[1:NumT]';rowno_1=rowno-1;rowno_2=rowno-2;
rowno_all=[rowno_2;rowno_2;rowno_2;rowno_2;rowno_1;rowno_1;rowno_1;rowno_1;rowno;rowno;rowno;rowno];
vertx_all=[v_1;v_2;v_3;v_4;v_1;v_2;v_3;v_4;v_1;v_2;v_3;v_4];
tmp_AB_all=[tmp_1(:,1);tmp_1(:,2);tmp_1(:,3);tmp_1(:,4);tmp_2(:,1);tmp_2(:,2);tmp_2(:,3);tmp_2(:,4);tmp_3(:,1);tmp_3(:,2);tmp_3(:,3);tmp_3(:,4)];
clear T x1 x2 x3 y1 y2 y3 z1 z2 z3 tmp_1 tmp_2 tmp_3 D
A=sparse(rowno_all,vertx_all,tmp_AB_all);
Dx=A(3*(0:(NumT-1))+1,:);
Dy=A(3*(0:(NumT-1))+2,:);
Dz=A(3*(0:(NumT-1))+3,:);
