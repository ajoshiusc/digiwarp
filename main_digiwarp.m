clc;clear all;close all;
%% This code warps the digiwarp atlas to a set of points.

addpath(genpath('src'));

%% These points are copied from main_select_points_for_reorientation
sub_pts=[45.807,-6.034,17.65];
        %84.40,-3.08, 16.03];
    
atlas_pts=[18.8,34,18.4];
    %19.24,17.38,16.8];


%% Please make sure that the inputs below are set correctly
atlas_tet_mat='/deneb_disk/mouse_reg_FEM/DigiMouse/tesselated_atlas/Tesselated_Atlas.mat';
fname1 = '/deneb_disk/mouse_reg_FEM/DigiMouse/atlas/atlas_380x992x208';
surf_file = '/home/ajoshi/coding_ground/digiwarp/surf_sub_vertices.mat'; 
% Specify the output directory, this should exist.
out_dir='.';



[~,~,ext]=fileparts(surf_file)
if strcmp(ext,'dfs')
    surf_sub=readdfs(surf_file);
    surf_sub_vertices=surf_sub.vertices;
else
    load(surf_file);sub_pts=[];atlas_pts=[];
end
%view_patch(surf_sub);

% padding used for the CT or MRI data.
opts.pad = 0;

% Number of iterations for nonlinear warping
opts.NIT=1%50;

% Use nearest neighbor for warping atlas 
%labels. use linear or cubic to warp CT or other images
opts.interp_method='nearest';


% The atlas is at too high resolution, Downsample by a factor of DS for
% computation
opts.DS=2;


%% Run the main code. This will take a while (~30 min or more)
digiwarp(surf_sub_vertices,atlas_tet_mat,fname1,sub_pts,atlas_pts, out_dir, opts);

