clc;clear all;close all;
%% This code warps the digiwarp atlas to a set of points.

addpath(genpath('src'));

%% Please make sure that the inputs below are set correctly
atlas_tet_mat='/deneb_disk/mouse_reg_FEM/DigiMouse/tesselated_atlas/Tesselated_Atlas.mat';
fname1 = '/deneb_disk/mouse_reg_FEM/DigiMouse/atlas/atlas_380x992x208';%'/home/ajoshi/data/mouse_spie/ct_data/atlas_380x992x208_ds_pad8_topcorr';fname_surf=[fname1,'.dfs'];
surf_file = '/home/ajoshi/coding_ground/digiwarp/sample_data/mouse_pts2q.res1.dfs';

%fxed_pts_atlas=[6939,5632];%,966];
%fxed_pts_sub=[4454,3517];%,5529];


sub_pts=[45.807,-6.034,17.65;
        84.40,-3.08, 16.03];
    
atlas_pts=[18.8,34,18.4;
    19.24,17.38,16.8];


surf_sub=readdfs(surf_file);
%view_patch(surf_sub);

% padding used for the CT or MRI data.
opts.pad = 20;

% Use nearest neighbor for warping atlas 
%labels. use linear or cubic to warp CT or other images
opts.interp_method='nearest';

digiwarp(surf_sub.vertices,atlas_tet_mat,fname1,sub_pts,atlas_pts);

