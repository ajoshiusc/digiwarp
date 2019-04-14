clc;clear all;close all;
%% This code warps the digiwarp atlas to a set of points.

addpath(genpath('src'));

%% Please make sure that the inputs below are set correctly
atlas_tet_mat='/deneb_disk/mouse_reg_FEM/DigiMouse/tesselated_atlas/Tesselated_Atlas.mat';
surf_file = '/home/ajoshi/coding_ground/digiwarp/sample_data/mouse_pts2q.res1.dfs';


% The following code loads subject surface points and atlas surface points,
% and then rigidly repositions the subject surface to match the atlas surface

surf_sub=readdfs(surf_file);surf_sub_vertices = surf_sub.vertices;

% Swapping dimensions might work better some times than ICP only
surf_sub_vertices=[surf_sub_vertices(:,2),surf_sub_vertices(:,1),surf_sub_vertices(:,3)];

% Load and display the atlas
load(atlas_tet_mat);
%r_hull=[r_hull(:,2),r_hull(:,1),r_hull(:,3)];

surf_atlas.faces=double(S_hull);
surf_atlas.vertices=r_hull;

% Display the surface points of the subject
fig=figure;
plot3(surf_sub_vertices(:,1),surf_sub_vertices(:,2),surf_sub_vertices(:,3),'.g','MarkerSize',5.0);axis off;axis equal;axis tight;
set(gcf,'color','white');
title('Subject before ICP');
hold on;view_patch(surf_atlas,0);axis off;



[Ricp Ticp ER t] = icp(r_hull', surf_sub_vertices', 150);
surf_sub_vertices = Ricp * surf_sub_vertices' + Ticp;
surf_sub_vertices=surf_sub_vertices';

fig=figure;
plot3(surf_sub_vertices(:,1),surf_sub_vertices(:,2),surf_sub_vertices(:,3),'.g','MarkerSize',5.0);axis off;axis equal;axis tight;
set(gcf,'color','white');
title('Subject after ICP on atlas');

hold on;view_patch(surf_atlas,0);axis off;


% Save the ICP warped vertices.
save('surf_sub_vertices.mat','surf_sub_vertices');
