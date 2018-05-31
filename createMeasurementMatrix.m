function measurementMatrix = createMeasurementMatrix(bestMatches,frames,descs)
%createMeasurementMatrix Create neasurement matrix
% an image sequence can be represented as a 2F x P measurement matrix W, which is made up of the
% horizontal and vertical coordinates of P points tracked through F frames.

    measurementMatrix = bestMatches(:,1:4,1)'; % fill in first 2 rows with frame 1-2 indices of best matches   
    measurementMatrix = reshape(measurementMatrix(measurementMatrix ~= 0),4,[]); % remove zeros
   
    prev_num_points = size(measurementMatrix,2); 
    
    chain_index_vector = 1:prev_num_points; 
    
    for i = 1:prev_num_points
        bestMatches(i,7,1) = chain_index_vector(i);        
    end
    
    for frame = 2:size(frames,3)-1      
        
        prev_matches = bestMatches(:,6,frame-1); % frame indexes from first pic
        prev_matches = prev_matches(prev_matches ~= 0); % remove zeros
        
        cur_matches = bestMatches(:,5,frame);% frame indexes from second pic
        cur_matches = cur_matches(cur_matches ~= 0); % remove zeros
        
        cur_num_points = length(cur_matches);
        % this is the number of the matches found in bestMatches for second
        % image       
        
        
        [C, IA, IB] = intersect(prev_matches, cur_matches);
        % IA and IB stores matching indexes
        

        matches = [IA IB];
                
        for i = 1:length(IA)
            
          
            measurementMatrix((frame+1)*2-1:(frame+1)*2,bestMatches(IA(i),7,frame-1)) = bestMatches(IB(i),3:4,frame)';   

       
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
                     
    end   
end

