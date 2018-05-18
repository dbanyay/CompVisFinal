function bestMatches = eightPointRANSAC(Imf,frames,descs)
%eightPointRANSAC Find best matches with 8 point RANSAC method


for i = 1:2 %% TODO change later to all images

    [matches, scores] = vl_ubcmatch (descs(:,:,i), descs(:,:,i+1));

    nummatches = 20; % number of random selected matches

    randindexes = randi([1, size(matches,2)],1,nummatches);

    for j = 1:nummatches
        randmatches(:,j) = matches(:,randindexes(j));
    end

    plotDiff(Imf(:,:,i),randmatches,frames(:,:,i),frames(:,:,i+1));
    
end

bestMatches = matches; % TODO change
end

