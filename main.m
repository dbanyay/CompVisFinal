clear all
close all

 load('c_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
 load('c2_descs')
 load('c2_frames')
%  load('b_bestMatches')
%  load('measurementMatrix')
%  load('S_matrix')
%  load('RGBvalues')

%  load('c_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
%  load('c_descs')
%  load('c_frames')
%  load('c_bestMatches')
%  load('measurementMatrix')
%  load('S_matrix')
%  load('RGBvalues')

% load('Imf_teddy') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)


%% Load images

%Imf = loadImages();

%% Feature detection and extraction of SIFT points

%[frames, descs] = extractSIFT(Imf); % using vl_feat

%[frames, descs] = loadHessaff(); % using Hessian deterctor + SIFT descriptors

% load('descs_teddy')
% load('frames_teddy')


%% Apply normalized 8-point RANSAC and find best matches

% bestMatches = eightPointRANSAC(Imf,frames,descs);
load('c2_bestMatches');
% load('b_bestMatches');

%% Chaining
pointViewMatrix = createpointViewMatrix(bestMatches,frames,descs);

% load('b_measurementMatrix')
%% Stitching

% [M,S] = estimate_3D_points(measurementMatrix,Imf);

[S_matrix, correspond_indexes, RGBvalues] = sfm_for_castle(pointViewMatrix,Imf);

plot3Dpoints(S_matrix, correspond_indexes, RGBvalues);

%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



