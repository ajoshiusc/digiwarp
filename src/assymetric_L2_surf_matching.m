%||AUM||
%clc;clear all;close all;
function surf_atlas=assymetric_L2_surf_matching(surf_atlas,surf_sub)

addpath '/home/ajoshi/sipi/my_functions/'
addpath '/home/ajoshi/sipi/my_functions/mri_toolbox'
addpath '/home/ajoshi/sipi/my_functions/ply'
step_size=.05;
lap_reg=8;
L=loreta(surf_atlas);
scrsz = get(0,'ScreenSize');

figure;

for kk=1:150
tic
    k=dsearchn(surf_atlas.vertices,surf_sub.vertices);
toc
%k is an index into atlas surface

    [vec_atlas_pts,ind]=unique(k);
%put edge length penalty
    vec_atlas2sub=surf_sub.vertices(ind,:)-surf_atlas.vertices(vec_atlas_pts,:);
%vec=vec1(vec_pts,:);

clear dat row col
 for jj=1:length(vec_atlas_pts)
     row(jj)=jj;
     col(jj)=vec_atlas_pts(jj);
     dat(jj)=1;
 end

    S=sparse(row,col,dat,length(vec_atlas_pts),length(surf_atlas.vertices));


    L1=[lap_reg*L;S];%speye(length(surf_atlas.vertices))];
    bx=[zeros(length(L),1);vec_atlas2sub(:,1)];
    by=[zeros(length(L),1);vec_atlas2sub(:,2)];
    bz=[zeros(length(L),1);vec_atlas2sub(:,3)];


    L1tL1=L1'*L1;
    M=diag(L1tL1)+eps;
    vx=mypcg(L1'*L1,L1'*bx,1e-100,300,M);
    vy=mypcg(L1'*L1,L1'*by,1e-100,300,M);
    vz=mypcg(L1'*L1,L1'*bz,1e-100,300,M);

   close all; figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
    set(gca,'xlim',[0 120]);axis equal;

%figure;
    patch(surf_atlas,'facecolor','g','edgecolor','none','facealpha',0.2);hold on;axis equal;axis off;camlight;drawnow;
%patch(surf_sub,'facecolor','r','edgecolor','none','facealpha',0.2);drawnow;axis off;
%plot3(surf_sub.vertices(:,1),surf_sub.vertices(:,2),surf_sub.vertices(:,3),'.r');
    plot3(surf_sub.vertices(:,1),surf_sub.vertices(:,2),surf_sub.vertices(:,3),'.r','MarkerSize',2.0);
    drawnow;axis off;drawnow;

    F(kk)=getframe;
% quiver3(surf_atlas.vertices(:,1),surf_atlas.vertices(:,2),surf_atlas.vertices(:,3),vx,vy,vz);
% 
% quiver3(surf_atlas.vertices(vec_atlas_pts,1),surf_atlas.vertices(vec_atlas_pts,2),surf_atlas.vertices(vec_atlas_pts,3),vec_atlas2sub(:,1),vec_atlas2sub(:,2),vec_atlas2sub(:,3),'r');
    L1_dist=sqrt(mean(vec_atlas2sub(:).^2));
    err(kk)=L1_dist;
    disp(sprintf('The asymmetric L1 distance is now :%g',L1_dist));

    surf_atlas.vertices=surf_atlas.vertices+step_size*[vx,vy,vz];
%save intermedi_mouse_warp2_new
end

save tmpF F;

% movie(F,100);
 
% movie2avi(F,'mouse_atlas_warping2.avi');


