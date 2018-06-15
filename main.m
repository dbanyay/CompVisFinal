clear all
close all

%% Load images

%Imf = loadImages(); %

load('Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)


%% Feature detection and extraction of SIFT points

%[frames, descs] = extractSIFT(Imf); % using vl_feat

%[frames, descs] = loadHessaff(); % using Hessian deterctor + SIFT descriptors

load('descs')
load('frames')



%% Apply normalized 8-point RANSAC and find best matches

bestMatches = eightPointRANSAC(Imf,frames,descs);

load('bestMatches')
%% Chaining
[measurementMatrix,bestMatches] = createMeasurementMatrix(bestMatches,frames,descs);

load('measurementMatrix')
%% Stitching

[M,S,RGBvalues] = estimate_3D_points(measurementMatrix,Imf);

load('S_matrix')
load('RGBvalues')

plot3DPoints(Imf,S_matrix,RGBvalues);

%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



