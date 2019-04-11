%||AUM||
clc;clear all;close all;


nsteps=1;
%addpath '/home/ajoshi/working/AnandJoshi/sipi/my_functions/mri_toolbox/'
%addpath '/home/ajoshi/working/AnandJoshi/sipi/my_functions/'
addpath(genpath('/deneb_disk/mouse_reg_FEM/my_functions'));


fname1 = '/deneb_disk/mouse_reg_FEM/DigiMouse/ct_data/ct_380x992x208';%'/home/ajoshi/data/mouse_spie/ct_data/atlas_380x992x208_ds_pad8_topcorr';fname_surf=[fname1,'.dfs'];

% sp_sub=readdfs('/home/ajoshi/data/CT_mouse_data/CT0400_Adult_Mouse_Total_x4_DICOM_ds_reoriented.dfs');
fxed_pts_atlas=[6939,5632];%,966];

fxed_pts_sub=[4454,3517];%,5529];

surf_sub=readdfs('mouse_pts2q.res1.dfs');
view_patch(surf_sub);


v1=avw_read(fname1);
%v1=resample_avw(v1,round(size(v1.img)/2));
pad=20;
v1=downsample_zeropad_img(v1,2,2,2,pad);res=v1.hdr.dime.pixdim(2:4);
load('/deneb_disk/mouse_reg_FEM/DigiMouse/tesselated_atlas/Tesselated_Atlas.mat')

r(:,1)=r(:,1)+pad*res(1);r_hull(:,1)=r_hull(:,1)+pad*res(1);
r(:,2)=r(:,2)+pad*res(2);r_hull(:,2)=r_hull(:,2)+pad*res(2);
r(:,3)=r(:,3)+pad*res(3);r_hull(:,3)=r_hull(:,3)+pad*res(3);

r=[r(:,2),r(:,1),r(:,3)];r_hull=[r_hull(:,2),r_hull(:,1),r_hull(:,3)];
tetmesh.vertices=r;tetmesh.faces=double(T);

surf_atlas.faces=double(S_hull);
surf_atlas.vertices=r_hull;
view_patch(surf_atlas);


def_fxed_pts=surf_sub.vertices(fxed_pts_sub,:)-surf_atlas.vertices(fxed_pts_atlas,:);

def_surf_reqd=surf_disp_from_fxedpts(surf_atlas,fxed_pts_atlas,def_fxed_pts);
plot(def_surf_reqd);
surf_atlas_repositioned.faces=surf_atlas.faces;
surf_atlas_repositioned.vertices=surf_atlas.vertices+def_surf_reqd;
view_patch(surf_atlas);
view_patch(surf_atlas_repositioned);


ind1=dsearchn(tetmesh.vertices,surf_atlas.vertices);
nrm=tetmesh.vertices(ind1,:)-surf_atlas.vertices;
disp(sprintf('it is %g close',max(abs(nrm(:)))));


surf_atlas_warped=assymetric_L2_surf_matching(surf_atlas_repositioned,surf_sub);

def_surf=def_surf_reqd./nsteps;
tetmesh_orig=tetmesh;
for jj=1:nsteps

K=myelastic_E_tet(tetmesh,.3,1);


% S=get_surf_tet(tetmesh.faces);
% S=correct_orientation_tet(S,tetmesh.faces,tetmesh.vertices); p.faces=S;p.vertices=tetmesh.vertices;
% figure;patch(p,'FaceColor','y','EdgeColor','none');axis equal;light; drawnow;
% 
% surf_pts_ind = intersect(p.faces(:),tetmesh.faces(:));
surf_pts_ind =ind1;

N=length(tetmesh.vertices);
constrained_pts=[surf_pts_ind,N+surf_pts_ind,2*N+surf_pts_ind];
ind=1:length(K);indf=ind;indf(constrained_pts)=[];
Kfc=K(:,constrained_pts);
Kfc=Kfc(indf,:);

Kcf=K(constrained_pts,:);
Kcf=Kcf(:,indf);


Kff=K(indf,:);Kff=Kff(:,indf);

%clear ind indf surf_pts_ind spts r r_hull 

M=(diag(Kff)+eps);
%bb=-0.5*(Kfc+Kcf')*ones(size(Kfc,2),1);
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

save(sprintf('tetmesh_%s',jj), 'tetmesh');

end

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
S=correct_orientation_tet(S,T1,r); p.faces=S;p.vertices=r;figure;
patch(p,'FaceColor','y','EdgeColor','none');axis equal;light;axis off; drawnow;view(0,0);


T=tetmesh2.faces;r=tetmesh2.vertices;
T1=cut_volume(T,r(:,2)-mean(r(:,2)),2.5);
S=get_surf_tet(T1);
S=correct_orientation_tet(S,T1,r); p2.faces=S;p2.vertices=r;figure;
patch(p2,'FaceColor','y','EdgeColor','none');axis equal;axis off;light; drawnow;view(0,0);
drawnow;

save tttt_2davis


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
disp('done this');
save test22
xd(v1_mask_ind)=disp_vec_mask(:,1);
yd(v1_mask_ind)=disp_vec_mask(:,2);
zd(v1_mask_ind)=disp_vec_mask(:,3);
[x,y,z]=ind2sub(Msize,v1_mask_ind);
x=reshape(x,Msize);y=reshape(y,Msize);z=reshape(z,Msize);
xpxd=min(max(x+xd,1),Msize(1));
ypyd=min(max(y+yd,1),Msize(2));
zpzd=min(max(z+zd,1),Msize(3));
vi.img=interp3(v1.img,ypyd,xpxd,zpzd);
vi.hdr=v1.hdr;
avw_write(vi,'warped_atlas');

save ttyty2
tetmesh.label=cond;
plot_tet_label_mesh(tetmesh);

%[x,y,z]=ind2sub(Msize,find(v1.img>-10));
%vi.img(:)=y;
avw_view(vi);


