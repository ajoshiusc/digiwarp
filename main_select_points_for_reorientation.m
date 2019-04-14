clc;clear all;close all;
%% This code warps the digiwarp atlas to a set of points.

addpath(genpath('src'));

%% Please make sure that the inputs below are set correctly
atlas_tet_mat='/deneb_disk/mouse_reg_FEM/DigiMouse/tesselated_atlas/Tesselated_Atlas.mat';
surf_file = '/home/ajoshi/coding_ground/digiwarp/sample_data/mouse_pts2q.res1.dfs';

%% The code will render the surfaces of subject and the atlas.
%% Tools->Data cursor. Then click on the points in the two surfaces that you think should correspond.
%% Click 2-3 points.

surf_sub=readdfs(surf_file);surf_sub_vertices = surf_sub.vertices;

% Display the surface points of the subject
fig=figure;
plot3(surf_sub_vertices(:,1),surf_sub_vertices(:,2),surf_sub_vertices(:,3),'.g','MarkerSize',5.0);axis off;axis equal;axis tight;
set(gcf,'color','white');
title('Subject');


% Load and display the atlas
load(atlas_tet_mat);
surf_atlas.faces=double(S_hull);
surf_atlas.vertices=r_hull;


view_patch(surf_atlas);axis off;
title('Atlas');

% Note down the points below
%%%%% COPY THIS TO THE main_digiwarp script

sub_pts=[45.807,-6.034,17.65;
        84.40,-3.08, 16.03];
    
atlas_pts=[18.8,34,18.4;
    19.24,17.38,16.8];



