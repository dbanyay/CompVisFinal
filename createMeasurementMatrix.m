function measurementMatrix = createMeasurementMatrix(bestMatches,frames,descs)
%createMeasurementMatrix Create neasurement matrix
% an image sequence can be represented as a 2F x P measurement matrix W, which is made up of the
% horizontal and vertical coordinates of P points tracked through F frames.

    measurementMatrix = bestMatches(:,1:4,1)'; % fill in first 4 rows with frame 1 2  best matches   
    measurementMatrix = reshape(measurementMatrix( measurementMatrix ~= 0),4,[]); % remove zeros
    
    prev_num_points = size(measurementMatrix,2);
    
    
    for frame = 2:size(frames,3) -1        
              
        for i = 1:prev_num_points
            desc1(:,i) = descs(:,bestMatches(i,5,frame),frame); 
            desc2(:,i) = descs(:,bestMatches(i,6,frame),frame+1); 
        end

        
        [matches, scores] = vl_ubcmatch (desc1, desc2);
        % look for matches between previous frame and current frame
        
        for i = 1:size(matches,2)    
            measurementMatrix((frame+1)*2-1:(frame+1)*2,matches(1,i)) = bestMatches(matches(i),3:4,frame)';
        end
        
        
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

