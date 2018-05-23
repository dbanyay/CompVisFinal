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
    nummatches = 20; % number of random selected matches  
    randindexes = randperm(max(size(matches)),nummatches);

    for j = 1:nummatches
        randmatches(:,j) = matches(:,randindexes(j));
    end

     newMatchesx =  randmatches(1,:);
     newMatchesy =  randmatches(2,:);
     newMatches = [newMatchesx ; newMatchesy];
     
     %plot the different of random matches in two images
     %figure(1);
     %plotDiff(img1,newMatches,frames1,frames2)
    
     coord_img1 = zeros(2,nummatches);
     coord_img2 = zeros(2,nummatches);

     for i = 1:length(newMatches)
        coord_img1(1,i) = frames1(1,newMatches(1,i)); %x coordinates of matched points in img1
        coord_img1(2,i) = frames1(2,newMatches(1,i)); %y coordinates of matched points in img1
        coord_img2(1,i) = frames2(1,newMatches(2,i)); %x coordinates of matched points in img2
        coord_img2(2,i) = frames2(2,newMatches(2,i)); %y coordinates of matched points in img2
     end

    %% Normalized Eight-point Algorithm using RANSAC
     m_x = mean(frames1(1,newMatches(1,:)));
     m_y = mean(frames1(2,newMatches(1,:)));
     d_sum = 0;
     for i = 1:20
        d_sum = d_sum + sqrt( (frames1(1,newMatches(1,i))-m_x)^2 + (frames1(2,newMatches(1,i))-m_y)^2 );
     end
     d = d_sum/20;
     T = [sqrt(2)/d 0 -m_x*sqrt(2)/d; 0 sqrt(2)/d -m_y*sqrt(2)/d; 0 0 1 ]; 

     p_i = zeros(3,20);
     p_i_new = zeros(3,20);
     for i = 1:20
        p_i(1,i) = frames1(1,newMatches(1,i)); %coordinate x
        p_i(2,i) = frames1(2,newMatches(1,i)); %coordinate y
        p_i(3,i) = 1;
        p_i_new(:,i) = T*p_i(:,i);
     end
     p_i_new = p_i_new(1:2,:);

     m_x_new = mean(frames2(1,newMatches(1,:))); %coordinate x'
     m_y_new = mean(frames2(2,newMatches(1,:))); %coordinate y'
     d_sum = 0;
     for i = 1:20
        d_sum = d_sum + sqrt( (coord_img2(1,i)-m_x_new)^2 + (coord_img2(2,i)-m_y_new)^2 );
     end
     d_new = d_sum/20;
     T_new = [sqrt(2)/d_new 0 -m_x_new*sqrt(2)/d_new; 0 sqrt(2)/d_new -m_y_new*sqrt(2)/d_new; 0 0 1 ];  

     p_i_new2 = zeros(3,20);
     for i = 1:20
        x = coord_img2(1,i); %coordinate x'
        y = coord_img2(2,i); %coordinate y'
        z = 1;
        p_i_new2(:,i) = T_new*[x;y;z];
     end
     p_i_new2 = p_i_new2(1:2,:);
    
     coord_img1 = coord_img1';
     coord_img2 = coord_img2';
    
     [F_ransac, inlier_index] = RANSAC_Fundamental(p_i_new, p_i_new2, T_new);
     for i = 1:length(inlier_index)
                inliers_img1(i,:) = [coord_img1(inlier_index(i),:)];
                inliers_img2(i,:) = [coord_img2(inlier_index(i),:)];
     end
     bestMatches = [inliers_img1, inliers_img2];
    
     figure(2);
     subplot(121);
     imshow(img1); 
     title('Inliers and Epipolar Lines in First Image'); hold on;
     plot(inliers_img1(:,1),inliers_img1(:,2),'go')
     epiLines = epipolarLine(F_ransac,inliers_img1);
     points = lineToBorderPoints(epiLines,size(img1));
     line(points(:,[1,3])',points(:,[2,4])');

     subplot(122); 
     imshow(img2);
     title('Inliers and Epipolar Lines in Second Image'); hold on;
     plot(inliers_img2(:,1),inliers_img2(:,2),'go')
     epiLines = epipolarLine(F_ransac,inliers_img2);
     points = lineToBorderPoints(epiLines,size(img2));
     line(points(:,[1,3])',points(:,[2,4])');
end



end