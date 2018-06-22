function [pointViewMatrix, bestMatches] = createpointViewMatrix(bestMatches,frames,descs)
%createMeasurementMatrix Create neasurement matrix
% an image sequence can be represented as a 2F x P measurement matrix W, which is made up of the
% horizontal and vertical coordinates of P points tracked through F frames.

    pointViewMatrix = bestMatches(:,1:4,1)'; % fill in first 2 rows with frame 1-2 indices of best matches   
    pointViewMatrix = reshape(pointViewMatrix(pointViewMatrix ~= 0),4,[]); % remove zeros
   
    prev_num_points = size(pointViewMatrix,2);
    
        
    bestMatches(1:prev_num_points,7,1) = 1:prev_num_points;  % save indexes in measurement matrix

    
    for frame = 2:size(frames,3)
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
          
            if frame == size(frames,3)
                pointViewMatrix(1:2,bestMatches(IA(i),7,frame-1)) = bestMatches(IB(i),3:4,frame)'; 
                bestMatches(IB(i),7,frame) = bestMatches(IA(i),7,frame-1);

            else 
                pointViewMatrix((frame+1)*2-1:(frame+1)*2,bestMatches(IA(i),7,frame-1)) = bestMatches(IB(i),3:4,frame)'; 
                bestMatches(IB(i),7,frame) = bestMatches(IA(i),7,frame-1);
            end
       
        end     
        % fill in values that match with the previous frame 
        
        cntr = size(pointViewMatrix,2)+1;

        if frame == size(frames,3)
            for i = 1:cur_num_points            % fill in non used values   
                if(~ismember(i,IB))
                    pointViewMatrix((frame+1)*2-3:(frame+1)*2-2,cntr) = bestMatches(i,1:2,frame)';
                    pointViewMatrix(1:2,cntr) = bestMatches(i,3:4,frame)';                
                    bestMatches(i,7,frame) = cntr;
                    cntr = cntr+1;
                end   
            end             
        else
            for i = 1:cur_num_points            % fill in non used values   
                if(~ismember(i,IB))
                    pointViewMatrix((frame+1)*2-3:(frame+1)*2,cntr) = bestMatches(i,1:4,frame)';                
                    bestMatches(i,7,frame) = cntr;
                    cntr = cntr+1;
                end   
            end  
        end          
    end
    
    %% Start from beginning for new matches
    
frame = 1;
prev_matches = bestMatches(:,6,size(bestMatches,3)); % frame indexes from first pic
prev_matches = prev_matches(prev_matches ~= 0); % remove zeros        

cur_matches = bestMatches(:,5,1);% frame indexes from second pic
cur_matches = cur_matches(cur_matches ~= 0); % remove zeros

cur_num_points = length(cur_matches);
% this is the number of the matches found in bestMatches for second
% image       


[C, IA, IB] = intersect(prev_matches, cur_matches);
% IA and IB stores matching indexes

matches = [IA IB];


for i = 1:length(IA) 
    pointViewMatrix(3:4,bestMatches(IA(i),7,size(bestMatches,3))) = bestMatches(IB(i),3:4,frame)';        
end   


end

