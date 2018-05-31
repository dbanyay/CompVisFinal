function bestMatches = eightPointRANSAC(Imf,frames,descs)




%% Fundamental Matrix Estimation
for frame = 1:size(Imf,3)-1
    img1 = Imf(:,:,frame);
    img2 = Imf(:,:,frame+1);

    frames1 = frames(:,:,frame);
    frames2 = frames(:,:,frame+1);

    desc1 = descs(:,:,frame);
    desc2 = descs(:,:,frame+1);

    [matches, scores] = vl_ubcmatch (desc1, desc2);  
    %nummatches = 20; % number of random selected matches  
    %randindexes = randperm(max(size(matches)),nummatches);
    nummatches = max(size(matches));
%     for j = 1:nummatches
%         randmatches(:,j) = matches(:,randindexes(j));
%     end

%      newMatchesx =  randmatches(1,:);
%      newMatchesy =  randmatches(2,:);
%      newMatches = [newMatchesx ; newMatchesy];
     
     %plot the different of random matches in two images
     %figure(1);
     %plotDiff(img1,newMatches,frames1,frames2)
    
     coord_img1 = zeros(2,nummatches);
     coord_img2 = zeros(2,nummatches);

     for i = 1:nummatches
        coord_img1(1,i) = frames1(1,matches(1,i)); %x coordinates of matched points in img1
        coord_img1(2,i) = frames1(2,matches(1,i)); %y coordinates of matched points in img1
        coord_img2(1,i) = frames2(1,matches(2,i)); %x coordinates of matched points in img2
        coord_img2(2,i) = frames2(2,matches(2,i)); %y coordinates of matched points in img2
     end

    %% Normalized Eight-point Algorithm using RANSAC
     m_x = mean(coord_img1(1,:));
     m_y = mean(coord_img1(2,:));
     d_sum = 0;
     for i = 1:nummatches
        d_sum = d_sum + sqrt( (coord_img1(1,i)-m_x)^2 + (coord_img1(2,i)-m_y)^2 );
     end
     d_1 = d_sum/nummatches;
     T = [sqrt(2)/d_1 0 -m_x*sqrt(2)/d_1; 0 sqrt(2)/d_1 -m_y*sqrt(2)/d_1; 0 0 1 ];     
     p_i = zeros(3,nummatches); %normalized coordiantes of img1
     for i = 1:nummatches
        x = coord_img1(1,i); %coordinate x
        y = coord_img1(2,i); %coordinate y
        z = 1;
        p_i(:,i) = T*[x;y;z];
     end
     p_i = p_i(1:2,:);

     m_x_new = mean(coord_img2(1,:)); 
     m_y_new = mean(coord_img2(2,:)); 
     d_sum = 0;
     for i = 1:nummatches
        d_sum = d_sum + sqrt( (coord_img2(1,i)-m_x_new)^2 + (coord_img2(2,i)-m_y_new)^2 );
     end
     d_new = d_sum/nummatches;
     T_new = [sqrt(2)/d_new 0 -m_x_new*sqrt(2)/d_new; 0 sqrt(2)/d_new -m_y_new*sqrt(2)/d_new; 0 0 1 ];  
     p_i_prime = zeros(3,nummatches);%normalized coordinates of img2
     for i = 1:nummatches
        x = coord_img2(1,i); %coordinate x'
        y = coord_img2(2,i); %coordinate y'
        z = 1;
        p_i_prime(:,i) = T_new*[x;y;z];
     end
     p_i_prime = p_i_prime(1:2,:);
    
     coord_img1 = coord_img1';
     coord_img2 = coord_img2';
    
     [F_ransac, inlier_index] = RANSAC_Fundamental(coord_img1', coord_img2', p_i, p_i_prime, T, T_new);
     for i = 1:length(inlier_index)
                inliers_img1(i,:) = [coord_img1(inlier_index(i),:)];
                inliers_img2(i,:) = [coord_img2(inlier_index(i),:)];
                inliers_matches(i,:) = [matches(:,inlier_index(i))'];
     end
     bestMatches(1:size(inliers_img1,1),1:6,frame) = [inliers_img1 inliers_img2 inliers_matches];

     % first feature point coordinates, second feature point coordinates,
     % indexes from original frame
     

%      figure;
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



end