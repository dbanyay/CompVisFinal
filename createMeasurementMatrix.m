function measurementMatrix = createMeasurementMatrix(bestMatches,frames,descs)
%createMeasurementMatrix Create neasurement matrix
% an image sequence can be represented as a 2F x P measurement matrix W, which is made up of the
% horizontal and vertical coordinates of P points tracked through F frames.

    measurementMatrix = bestMatches(:,1:4,1)'; % fill in first 2 rows with frame 1-2 indices of best matches   
    measurementMatrix = reshape(measurementMatrix( measurementMatrix ~= 0),4,[]); % remove zeros
   
    prev_num_points = size(measurementMatrix,2);     

    
    
    for frame = 2:size(frames,3)-1      
        
        [C, IA, IB] = intersect(bestMatches(:,6,frame), bestMatches(:,5,frame+1));
        % IA and IB stores matching indexes
        
        cur_num_points = length(nonzeros(bestMatches(:,1,frame)));
        % this is the number of the matches found in bestMatches for second
        % image
        
        
        for i = 1:length(IA)
            
            matched_coordinates(1) = IA(matches(2,i),3:4,frame)';
            matched_coordinates(2) = IB();
            measurementMatrix((frame+1)*2-1:(frame+1)*2,matches(1,i)) = 
        end     
        % fill in values that match with the previous frame        
 
        cntr = prev_num_points+1;
        
        for i = 1:cur_num_points            % fill in non used values   
            
            if(~ismember(i,matches(2,:)))
                measurementMatrix((frame+1)*2-1:(frame+1)*2,cntr) = bestMatches(i,3:4,frame)';
                cntr = cntr+1;
            end            
            
        end    
        
       prev_num_points = size(descs,2);
       
       desc1 = desc2;
              
    end   
end

