clear all
close all

 load('b_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
 load('b_descs')
 load('b_frames')
 load('b_bestMatches')
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



%% Load images

%Imf = loadImages();

%% Feature detection and extraction of SIFT points

%[frames, descs] = extractSIFT(Imf); % using vl_feat

%[frames, descs] = loadHessaff(); % using Hessian deterctor + SIFT descriptors

%% Apply normalized 8-point RANSAC and find best matches

%bestMatches = eightPointRANSAC(Imf,frames,descs);


%% Chaining
[measurementMatrix,bestMatches] = createMeasurementMatrix(bestMatches,frames,descs);


%% Stitching

[M,S_matrix,RGBvalues] = estimate_3D_points(measurementMatrix,Imf);

plot3DPoints(Imf,S_matrix,RGBvalues);

%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



