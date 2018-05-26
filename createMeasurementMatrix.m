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
    


     for i = 1:length(newMatches)
        coord_img1(1,i) = frames1(1,newMatches(1,i)); %x coordinates of matched points in img1
        coord_img1(2,i) = frames1(2,newMatches(1,i)); %y coordinates of matched points in img1
        coord_img2(1,i) = frames2(1,newMatches(2,i)); %x coordinates of matched points in img2
        coord_img2(2,i) = frames2(2,newMatches(2,i)); %y coordinates of matched points in img2
        
        desc_prev_frame(:,i) = desc2(:,newMatches(1,i)); % save descriptors for frame 2
     end

    measurementMatrix = sortrows([coord_img1' coord_img2'],[1 2 3 4], 'descend')';
    % fill in first 4 rows with the random matches
    
    
    
    for frame = 1:size(frames,3) -1
        
        indexes1 = bestMatches()
        
        
        
        frame1 = frames(:,:,frame);
        frame2 = frames(:,:,frame+1);
        
        
        desc1 = descs(:,:,frame);
        desc1 = descs(:,:,frame);
        
        [matches, scores] = vl_ubcmatch (desc_prev_frame, desc_cur_frame);
        % look for matches between previous frame and current frame
        
        measurementMatrix(frame*2-1:frame*2, 1:size(matches,2)) = frames1(1:2,matches(2,1:size(matches,2)));
        % fill next line with matches from the previous frame 
                
        
        desc_prev_frame = desc_cur_frame(:,matches(2,1:size(matches,2)));
     
        
        remainingmatches = nummatches - size(matches,2); % number of matches still to be filled  
        randindexes = randperm(size(frames,2),nummatches);
% 
%         for j = 1:nummatches
%             randmatches(:,j) = matches(:,randindexes(j));
%         end      
        measurementMatrix(frame*2-1:frame*2, size(matches,2):nummatches) = 0;
       
    end    
end

