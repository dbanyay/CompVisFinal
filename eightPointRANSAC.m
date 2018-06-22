function bestMatches = eightPointRANSAC(Imf,frames,descs)




%% Fundamental Matrix Estimation
for frame = 1:size(frames,3)
    
    if frame == size(frames,3)        
        frames1 = frames(:,:,frame);
        frames2 = frames(:,:,1);
        desc1 = descs(:,:,frame);
        desc2 = descs(:,:,1);        
    else
        frames1 = frames(:,:,frame);
        frames2 = frames(:,:,frame+1);
        desc1 = descs(:,:,frame);
        desc2 = descs(:,:,frame+1);
    end

    [matches, scores] = vl_ubcmatch(desc1, desc2, 1.5); %1.5 is default threshold

    nummatches = max(size(matches));

     coord_img1 = zeros(2,nummatches);
     coord_img2 = zeros(2,nummatches);

     coord_img1(1,:) = frames1(1,matches(1,:)); %x coordinates of matched points in img1
     coord_img1(2,:) = frames1(2,matches(1,:)); %y coordinates of matched points in img1
     coord_img2(1,:) = frames2(1,matches(2,:)); %x coordinates of matched points in img2
     coord_img2(2,:) = frames2(2,matches(2,:)); %y coordinates of matched points in img2


    %% Normalized Eight-point Algorithm using RANSAC
     m_x = mean(coord_img1(1,:));
     m_y = mean(coord_img1(2,:));
     d_sum = sum(sqrt( (coord_img1(1,:)-m_x).^2 + (coord_img1(2,:)-m_y).^2 ));
     d_1 = d_sum/nummatches;
     T = [sqrt(2)/d_1 0 -m_x*sqrt(2)/d_1; 0 sqrt(2)/d_1 -m_y*sqrt(2)/d_1; 0 0 1 ];     
     p_i = zeros(3,nummatches); %normalized coordiantes of img1
     p_i = T*[coord_img1(1,:);coord_img1(2,:);ones(1,nummatches)];
     p_i = p_i(1:2,:);

     m_x_new = mean(coord_img2(1,:)); 
     m_y_new = mean(coord_img2(2,:)); 
     d_sum = sum(sqrt( (coord_img2(1,:)-m_x_new).^2 + (coord_img2(2,:)-m_y_new).^2 ));
     d_new = d_sum/nummatches;
     T_new = [sqrt(2)/d_new 0 -m_x_new*sqrt(2)/d_new; 0 sqrt(2)/d_new -m_y_new*sqrt(2)/d_new; 0 0 1 ];  
     p_i_prime = zeros(3,nummatches);%normalized coordinates of img2
     p_i_prime = T_new*[coord_img2(1,:);coord_img2(2,:);ones(1,nummatches)];
     p_i_prime = p_i_prime(1:2,:);
    
     coord_img1 = coord_img1';
     coord_img2 = coord_img2';
    
     inlier_index = RANSAC_Fundamental(coord_img1', coord_img2', p_i, p_i_prime, T, T_new);

     inliers_img1 = [coord_img1(inlier_index,:)];
     inliers_img2 = [coord_img2(inlier_index,:)];
     inliers_matches = [matches(:,inlier_index)'];

     bestMatches(1:size(inliers_img1,1),1:6,frame) = [inliers_img1 inliers_img2 inliers_matches];
%      plotError(Imf(:,:,1,frame),bestMatches(:,:,frame))
%      F_ransac = getFundamentalM(p_i(:,inlier_index), p_i_prime(:,inlier_index), T, T_new, 'd'); 
     % first feature point coordinates, second feature point coordinates,
     % indexes from original frame

     
%      figure(2);
%      subplot(121);
%      imshow(img1); 
%      title('Inliers and Epipolar Lines in First Image'); hold on;
%      plot(inliers_img1(:,1),inliers_img1(:,2),'go')
%      epiLines = epipolarLine(F_ransac,inliers_img1);
%      points = lineToBorderPoints(epiLines,size(img1));
%      line(points(:,[1,3])',points(:,[2,4])');
% 
%      subplot(122); 
%      imshow(img2);
%      title('Inliers and Epipolar Lines in Second Image'); hold on;
%      plot(inliers_img2(:,1),inliers_img2(:,2),'go')
%      epiLines = epipolarLine(F_ransac,inliers_img2);
%      points = lineToBorderPoints(epiLines,size(img2));
%      line(points(:,[1,3])',points(:,[2,4])');

     
     inliers_img1 = [];
     inliers_img2 = [];
     inliers_matches = [];
end


% save('bestMatches','bestMatches')
end