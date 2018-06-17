clear all
close all

 load('b_Imf') % load image matrix, with colors! 4-D matrix, (x,y,color,frame)
 load('b_descs')
 load('b_frames')
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

bestMatches = eightPointRANSAC(Imf,frames,descs);
% load('bestMatches');
% load('b_bestMatches');

%% Chaining
measurementMatrix = createMeasurementMatrix(bestMatches,frames,descs);

% load('b_measurementMatrix')
%% Stitching

% [M,S] = estimate_3D_points(measurementMatrix,Imf);
[m2,n] = size(measurementMatrix);
count = 1;
for i = 1:2:m2-1
    switch i
        case m2-3 
            M_set(1:4,:) = measurementMatrix(i:i+3,:);
            M_set(5:6,:) = measurementMatrix(1:2,:); %TODO
            M_long = [measurementMatrix(i:i+3,:); measurementMatrix(1:4,:)];
        case m2-5
            M_set(1:4,:) = measurementMatrix(i:i+3,:);
            M_set(5:6,:) = measurementMatrix(1:2,:); %TODO
            M_long = [measurementMatrix(i:i+5,:); measurementMatrix(1:2,:)];
        case m2-1
            M_set(1:2,:) = measurementMatrix(i:i+1,:);
            M_set(3:6,:) = measurementMatrix(1:4,:); %TODO
            M_long = 0;
        otherwise
            M_set = measurementMatrix(i:i+5,:);
            M_long = measurementMatrix(i:i+7,:);
    end
    
    [M, S, RGBvalue,short_chain_index] = estimate_3D_points(M_set,Imf,i);
    
    long_chain_index = find_long_chain(M_long);
    if long_chain_index ~= 0
        intersected_index = intersect(short_chain_index,long_chain_index);
        for j = 1:length(intersected_index)
            correspond_index_1(j) = find(short_chain_index == intersected_index(j));
            correspond_index_2(j) = find(long_chain_index == intersected_index(j));
        end
        correspond_indexes{count} = [correspond_index_1; correspond_index_2];
    else
        correspond_indexes{count} = 0;
    end
    correspond_index_1 = [];
    correspond_index_2 = [];
    S_matrix{count} = S;
    RGBvalues{count} = RGBvalue;
    count = count + 1;
end

plot3Dpoints(S_matrix, correspond_indexes, RGBvalues);

%% Apply bundle adjustment


%% Eliminate Affine ambiguity


%% 3D model plotting



