function digiwarp(surf_sub_vertices,atlas_tet_mat,fname1,pts_sub,pts_atlas,outdir,opts)

pad=opts.pad;
interp_method=opts.interp_method;
DS=opts.DS;
v1=avw_read(fname1);

% Load and downsample atlas;
v1=downsample_zeropad_img(v1,DS,DS,DS,pad);res=v1.hdr.dime.pixdim(2:4);
load(atlas_tet_mat);

fxed_pts_atlas=dsearchn(r_hull,pts_atlas);
fxed_pts_sub = dsearchn(surf_sub_vertices,pts_sub);
%fxed_pts_atlas=[6939,5632];%,966];
%fxed_pts_sub=[4454,3517];%,5529];


disp('The following numbers should be close to 0, which will show match to atlas');
r_hull(fxed_pts_atlas,:)-pts_atlas


disp('The following numbers should be close to 0, which will show match to subject');
surf_sub_vertices(fxed_pts_sub,:)-pts_sub


r(:,1)=r(:,1)+pad*res(1);r_hull(:,1)=r_hull(:,1)+pad*res(1);
r(:,2)=r(:,2)+pad*res(2);r_hull(:,2)=r_hull(:,2)+pad*res(2);
r(:,3)=r(:,3)+pad*res(3);r_hull(:,3)=r_hull(:,3)+pad*res(3);

r=[r(:,2),r(:,1),r(:,3)];r_hull=[r_hull(:,2),r_hull(:,1),r_hull(:,3)];



tetmesh.vertices=r;tetmesh.faces=double(T);

surf_atlas.faces=double(S_hull);
surf_atlas.vertices=r_hull;
view_patch(surf_atlas);


def_fxed_pts=surf_sub_vertices(fxed_pts_sub,:)-surf_atlas.vertices(fxed_pts_atlas,:);

def_surf_reqd=surf_disp_from_fxedpts(surf_atlas,fxed_pts_atlas,def_fxed_pts);
plot(def_surf_reqd);
surf_atlas_repositioned.faces=surf_atlas.faces;
surf_atlas_repositioned.vertices=surf_atlas.vertices+def_surf_reqd;
view_patch(surf_atlas);
view_patch(surf_atlas_repositioned);


ind1=dsearchn(tetmesh.vertices,surf_atlas.vertices);
nrm=tetmesh.vertices(ind1,:)-surf_atlas.vertices;


surf_atlas_warped=assymetric_L2_surf_matching(surf_atlas_repositioned,surf_sub_vertices,opts.NIT);

def_surf=surf_atlas_warped.vertices;%def_surf_reqd;
tetmesh_orig=tetmesh;

K=myelastic_E_tet(tetmesh,.3,1);


surf_pts_ind =ind1;

N=length(tetmesh.vertices);
constrained_pts=[surf_pts_ind,N+surf_pts_ind,2*N+surf_pts_ind];
ind=1:length(K);indf=ind;indf(constrained_pts)=[];
Kfc=K(:,constrained_pts);
Kfc=Kfc(indf,:);

Kcf=K(constrained_pts,:);
Kcf=Kcf(:,indf);


Kff=K(indf,:);Kff=Kff(:,indf);


M=(diag(Kff)+eps);
bb=-0.5*(Kfc+Kcf')*def_surf(:);
sol=mypcg(Kff,bb,1e-232,30000,M);
plot(sol);
def=zeros(size(tetmesh.vertices,1),3);
tetmesh2=tetmesh;

def(indf)=sol;def(constrained_pts)=def_surf;
tetmesh2.vertices=tetmesh2.vertices+def;

T=tetmesh.faces;r=tetmesh.vertices;
T1=cut_volume(T,r(:,3)-mean(r(:,3)),0);
S=get_surf_tet(T1);
S=correct_orientation_tet(S,T1,r); p.faces=S;p.vertices=r;figure;
patch(p,'FaceColor','y','EdgeColor','none');axis equal;light; drawnow;
view(0,-90);


T=tetmesh2.faces;r=tetmesh2.vertices;
T1=cut_volume(T,r(:,3)-mean(r(:,3)),0);
S=get_surf_tet(T1);
S=correct_orientation_tet(S,T1,r); p2.faces=S;p2.vertices=r;figure;
patch(p2,'FaceColor','y','EdgeColor','none');axis equal;light; drawnow;
drawnow;view(0,-90);
tetmesh=tetmesh2;

save(fullfile(outdir,'tetmesh_warped.mat'), 'tetmesh');



vi=v1;
Msize=size(vi.img);vi.img=0*vi.img;
res=v1.hdr.dime.pixdim(2:4);
tetmesh_orig.vertices(:,1)=tetmesh_orig.vertices(:,1)/res(1);
tetmesh_orig.vertices(:,2)=tetmesh_orig.vertices(:,2)/res(2);
tetmesh_orig.vertices(:,3)=tetmesh_orig.vertices(:,3)/res(3);
tetmesh2.vertices(:,1)=tetmesh2.vertices(:,1)/res(1);
tetmesh2.vertices(:,2)=tetmesh2.vertices(:,2)/res(2);
tetmesh2.vertices(:,3)=tetmesh2.vertices(:,3)/res(3);



T=tetmesh_orig.faces;r=tetmesh_orig.vertices;
T1=cut_volume(T,r(:,2)-mean(r(:,2)),2.5);
S=get_surf_tet(T1);
S=correct_orientation_tet(S,T1,r); p.faces=S;p.vertices=r;

figure;
patch(p,'FaceColor','y','EdgeColor','none');axis equal;light;axis off; drawnow;view(0,0);
title('Warped tetmesh');

T=tetmesh2.faces;r=tetmesh2.vertices;
T1=cut_volume(T,r(:,2)-mean(r(:,2)),2.5);
S=get_surf_tet(T1);
S=correct_orientation_tet(S,T1,r); p2.faces=S;p2.vertices=r;

figure;
patch(p2,'FaceColor','y','EdgeColor','none');axis equal;axis off;light; drawnow;view(0,0);
drawnow;title('Warped atlas surface');


tetmesh_orig.vertices(:,1)=max(min(tetmesh_orig.vertices(:,1),Msize(1)),1);
tetmesh_orig.vertices(:,2)=max(min(tetmesh_orig.vertices(:,2),Msize(2)),1);
tetmesh_orig.vertices(:,3)=max(min(tetmesh_orig.vertices(:,3),Msize(3)),1);

vi=v1;
ind11=sub2ind(Msize,round(tetmesh_orig.vertices(:,1)+0),round(tetmesh_orig.vertices(:,2)+20),round(tetmesh_orig.vertices(:,3)+0));
vi.img(ind11)=931;

tetmesh_orig2=tetmesh_orig;
tetmesh_orig2.vertices(:,2)=tetmesh_orig.vertices(:,2)+20;
tetmesh_orig2.vertices(:,3)=tetmesh_orig.vertices(:,3);
%
%Align centers
tetmesh2.vertices(:,1)=tetmesh2.vertices(:,1)-mean(tetmesh2.vertices(:,1))+mean(tetmesh_orig2.vertices(:,1));
tetmesh2.vertices(:,2)=tetmesh2.vertices(:,2)-mean(tetmesh2.vertices(:,2))+mean(tetmesh_orig2.vertices(:,2));
tetmesh2.vertices(:,3)=tetmesh2.vertices(:,3)-mean(tetmesh2.vertices(:,3))+mean(tetmesh_orig2.vertices(:,3));


tetmesh2.vertices(:,1)=max(min(tetmesh2.vertices(:,1),Msize(1)),1);
tetmesh2.vertices(:,2)=max(min(tetmesh2.vertices(:,2),Msize(2)),1);
tetmesh2.vertices(:,3)=max(min(tetmesh2.vertices(:,3),Msize(3)),1);

% vi=v1;
%  ind11=sub2ind(Msize,round(tetmesh2.vertices(:,1)+0),round(tetmesh2.vertices(:,2)+3),round(tetmesh2.vertices(:,3)+1));
%  vi.img(ind11)=931;



%vi.img=warp_vols_tetmeshes(find(v1.img>-10),v1.img,Msize,tetmesh2,tetmesh_orig2);
v1_mask_ind=find(v1.img>-10);
disp_vec_mask=interp_disp_field_mask(tetmesh2,tetmesh_orig2,v1_mask_ind,Msize);
xd=zeros(Msize);yd=xd;zd=xd;
disp('done computing deformation for the volume');
xd(v1_mask_ind)=disp_vec_mask(:,1);
yd(v1_mask_ind)=disp_vec_mask(:,2);
zd(v1_mask_ind)=disp_vec_mask(:,3);
[x,y,z]=ind2sub(Msize,v1_mask_ind);
x=reshape(x,Msize);y=reshape(y,Msize);z=reshape(z,Msize);
xpxd=min(max(x+xd,1),Msize(1));
ypyd=min(max(y+yd,1),Msize(2));
zpzd=min(max(z+zd,1),Msize(3));
vi.img=interp3(v1.img,ypyd,xpxd,zpzd,interp_method);
vi.hdr=v1.hdr;
avw_write(vi,fullfile(outdir,'warped_atlas'));

tetmesh.label=cond;
plot_tet_label_mesh(tetmesh);
title('Warped atlas');

avw_view(vi);


