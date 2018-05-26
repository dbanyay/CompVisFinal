function measurementMatrix = createMeasurementMatrix(bestMatches,frames,descs)
%createMeasurementMatrix Create neasurement matrix
% an image sequence can be represented as a 2F x P measurement matrix W, which is made up of the
% horizontal and vertical coordinates of P points tracked through F frames.

    frame = 1;  % create first 2 lines of M matrix

    frames1 = frames(:,:,frame);
    frames2 = frames(:,:,frame+1);

    desc1 = descs(:,:,frame);
    desc2 = descs(:,:,frame+1);

    [matches, scores] = vl_ubcmatch (desc1, desc2);  
    nummatches = length(bestMatches(:,:,1)); % number of random selected matches  
%     randindexes = randperm(max(size(matches)),nummatches);
% 
%     for j = 1:nummatches
%         randmatches(:,j) = matches(:,randindexes(j));
%     end      
%     
%      newMatchesx =  randmatches(1,:);
%      newMatchesy =  randmatches(2,:);
%      newMatches = [newMatchesx ; newMatchesy];
     
     coord_img1 = zeros(2,nummatches);
     coord_img2 = zeros(2,nummatches);
     bestMatches_temporary = bestMatches(:,:,1)'; %for testing

     for i = 1:nummatches
        coord_img1(1,i) = bestMatches_temporary(1,i); %x coordinates of matched points in img1
        coord_img1(2,i) = bestMatches_temporary(2,i); %y coordinates of matched points in img1
        coord_img2(1,i) = bestMatches_temporary(3,i); %x coordinates of matched points in img2
        coord_img2(2,i) = bestMatches_temporary(4,i); %y coordinates of matched points in img2
     end

    measurementMatrix = sortrows([coord_img1' coord_img2'],[1 2 3 4], 'descend')';
    % fill in first 4 rows with the random matches
    
    for frame = 2:size(frame,3)-1
        
    end
%measurementMatrix = 1;
end