clear all
close all

%% Load files
% We saved the matrices after a step was successfully finished, so we
% do not have to run that part again

%%%%%%%%%%%%%%%%%%%%%%%%%%% For castle image set %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('cm_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
% load('c2_descs')
% load('c2_frames')
% load('c2_bestMatches')
% load('c2_measurementMatrix')
% pointViewMatrix = measurementMatrix;

%%%%%%%%%%%%%%%%%%%%%%%%% For teddybear image set %%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('b_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
% load('b_descs')
% load('b2_frames')
% load('b_bestMatches')
% load('b_measurementMatrix')
% pointViewMatrix = measurementMatrix;

starttime=clock; % start measuring time


%% Load images
tic
Imf = loadImages();
fprintf('Load images: %4.4f s\n',toc)

%% Feature detection and extraction of SIFT points

tic
[frames, descs] = loadHessaff(Imf); 
fprintf('Load frames and descriptors: %4.4f s\n',toc)


%% Apply normalized 8-point RANSAC and find best matches

tic
bestMatches = eightPointRANSAC(Imf,frames,descs);
fprintf('Eight Point RANSAC: %4.4f s\n',toc)

%% Chaining
tic
pointViewMatrix = createpointViewMatrix(bestMatches,frames,descs);
fprintf('create Point-View matrix: %4.4f s\n',toc)

%% Stitching 

tic
%[S_matrix, correspond_indexes, RGBvalues] = sfm_for_teddy(pointViewMatrix,Imf);
[S_matrix, correspond_indexes, RGBvalues] = sfm_for_castle(pointViewMatrix,Imf);
fprintf('Create structure from motion: %4.4f s\n',toc)

%% 3D plot
tic
[S_concat,RGB_concat] = plot3Dpoints(S_matrix, correspond_indexes, RGBvalues);
fprintf('3D cloud: %4.4f s\n',toc)

TestMyCrustOpen;  % run surface plot, using saved 3D point matrix
