function disp_vec_mask=interp_disp_field_mask(tetmesh,tetmesh2,v1_mask_ind,Msize)

disp_vec=tetmesh2.vertices-tetmesh.vertices;
[x,y,z]=ind2sub(Msize,v1_mask_ind);
xd=0*x;%()
yd=xd;zd=xd;
iind=sub2ind(Msize,round(tetmesh.vertices(:,1)),round(tetmesh.vertices(:,2)),round(tetmesh.vertices(:,3)));
xd(iind)=disp_vec(:,1);
yd(iind)=disp_vec(:,2);
zd(iind)=disp_vec(:,3);

%[t,p]=mytsearchn(x,y,zz,tet,z,xin,yin,zzin,tnum,pc)

%[t,p]=tsearchn(tetmesh.vertices,tetmesh.faces,[x,y,z]);
%tic
%xd=mygriddata3_tet(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),tetmesh.faces,disp_vec(:,1),x,y,z,t,p);toc
%yd=mygriddata3_tet(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),tetmesh.faces,disp_vec(:,2),x,y,z,t,p);toc
%zd=mygriddata3_tet(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),tetmesh.faces,disp_vec(:,3),x,y,z,t,p);toc

tic
xd=griddata(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),disp_vec(:,1),x,y,z);toc%,'linear');toc
yd=griddata(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),disp_vec(:,2),x,y,z);toc%,'nearest');toc
zd=griddata(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),disp_vec(:,3),x,y,z);toc%,'nearest');toc
toc

nanind=isnan(xd)|isnan(yd)|isnan(zd);
xd(nanind)=griddata(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),disp_vec(:,1),x(nanind),y(nanind),z(nanind),'nearest');%100000;
yd(nanind)=griddata(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),disp_vec(:,2),x(nanind),y(nanind),z(nanind),'nearest');%100000;
zd(nanind)=griddata(tetmesh.vertices(:,1),tetmesh.vertices(:,2),tetmesh.vertices(:,3),disp_vec(:,3),x(nanind),y(nanind),z(nanind),'nearest');%100000;

disp_vec_mask=[xd,yd,zd];

