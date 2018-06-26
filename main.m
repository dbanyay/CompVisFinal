clear all
close all

%% Load files

load('cm_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
load('cs_descs')
load('cs_frames')
% load('cs_bestMaches')
% load('cs_pointViewMatrix')
%  load('c2_descs')
%  load('c2_frames')
%  load('c2_bestMatches')
%  load('c2_measurementMatrix')
%  pointViewMatrix = measurementMatrix;
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



starttime=clock; % start measuring time


% Load images
% tic
% Imf = loadImages();
% fprintf('Load images: %4.4f s\n',toc)

% Feature detection and extraction of SIFT points
% 
% tic
% [frames, descs] = loadHessaff(Imf); 
% fprintf('Load frames and descriptors: %4.4f s\n',toc)
% 
% 
% % Apply normalized 8-point RANSAC and find best matches

tic
bestMatches = eightPointRANSAC(Imf,frames,descs);
fprintf('Eight Point RANSAC: %4.4f s\n',toc)

% % Chaining

tic
pointViewMatrix = createpointViewMatrix(bestMatches,frames,descs);
fprintf('create Point-View matrix: %4.4f s\n',toc)

%% Stitching 

tic
[S_matrix, correspond_indexes, RGBvalues] = sfm_for_castle(pointViewMatrix,Imf);
fprintf('Create structure from motion: %4.4f s\n',toc)

%% 3D plot
tic
[S_concat,RGB_concat] = plot3Dpoints(S_matrix, correspond_indexes, RGBvalues);
fprintf('3D cloud: %4.4f s\n',toc)



