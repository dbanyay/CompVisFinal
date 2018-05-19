function bestMatches = eightPointRANSAC(Imf,frames,descs)




%% Fundamental Matrix Estimation
for frame = 1:size(Imf,3)-1
    img1 = Imf(:,:,frame);
    img2 = Imf(:,:,frame+1);

    frames1 = frames(:,:,frame);
    frames2 = frames(:,:,frame+1);

    desc1 = descs(:,:,frame);
    desc2 = descs(:,:,frame+1);

    [matches, scores] = vl_ubcmatch (descs(:,:,frame) , descs(:,:,frame+1));

    %select 20 matched points manually
    count = 0;
    for i = 1:length(matches)

        count = count + 1;
        newMatches(1,count) = matches(1,i);
        newMatches(2,count) = matches(2,i);

    end


   [matches, scores] = vl_ubcmatch (desc1, desc2);
   
   
    nummatches = 20; % number of random selected matches
    
    randindexes = randi([1, size(matches,2)],1,nummatches);

    for j = 1:nummatches
        randmatches(:,j) = matches(:,randindexes(j));
    end

    newMatchesx =  randmatches(1,:);
    newMatchesy =  randmatches(2,:);
    newMatches = [newMatchesx ; newMatchesy];
    
    figure(1);
    plotDiff(img1,newMatches,frames1,frames2)
    
    coord_img1 = zeros(2,nummatches);
    coord_img2 = zeros(2,nummatches);

    for i = 1:length(newMatches)
        coord_img1(1,i) = frames1(1,newMatches(1,i)); %x coordinates of matched points in img1
        coord_img1(2,i) = frames1(2,newMatches(1,i)); %y coordinates of matched points in img1
        coord_img2(1,i) = frames2(1,newMatches(2,i)); %x coordinates of matched points in img2
        coord_img2(2,i) = frames2(2,newMatches(2,i)); %y coordinates of matched points in img2
    end

    colume1 = coord_img1(1,:).*coord_img2(1,:); %x*x'
    colume2 = coord_img1(1,:).*coord_img2(2,:); %x*y'
    colume3 = coord_img1(1,:); %x
    colume4 = coord_img1(2,:).*coord_img2(1,:); %y*x'
    colume5 = coord_img1(2,:).*coord_img2(2,:); %y*y'
    colume6 = coord_img1(2,:); %y
    colume7 = coord_img2(1,:); %x'
    colume8 = coord_img2(2,:); %y'
    colume9 = ones(1,20);

    %% Eight-point Algorithm
    %construct 20*9 matrix A
    A = [colume1', colume2', colume3', colume4', colume5', colume6', colume7', colume8', colume9'];
    [U,D,V] = svd(A); % A = UDV' 
    %V = V';
    F = reshape(V(:,9),3,3);
    [Uf,Df,Vf] = svd(F);
    Df(3,3) = 0; %Set the smallest singular value in the diagonal matrix Df to zero
    F_new = Uf*Df*Vf'; %Recompute F : F = UfDfVf'

    %% Normalized Eight-point Algorithm
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

    colume1 = p_i_new(1,:).*p_i_new2(1,:); %x*x'
    colume2 = p_i_new(1,:).*p_i_new2(2,:); %x*y'
    colume3 = p_i_new(1,:); %x
    colume4 = p_i_new(2,:).*p_i_new2(1,:); %y*x'
    colume5 = p_i_new(2,:).*p_i_new2(2,:); %y*y'
    colume6 = p_i_new(2,:); %y
    colume7 = p_i_new2(1,:); %x'
    colume8 = p_i_new2(2,:); %y'
    colume9 = ones(1,20);

    A1 = [colume1', colume2', colume3', colume4', colume5', colume6', colume7', colume8', colume9'];
    [U1,D1,V1] = svd(A1); % A = UDV'
    F1 = reshape(V1(:,9),3,3);
    [Uf1,Df1,Vf1] = svd(F1);
    Df1(3,3) = 0; %Set the smallest singular value in the diagonal matrix Df to zero
    F_new1 = Uf1*Df1*Vf1'; %Recompute F : F = UfDfVf'
    F = T_new'*F_new1*T_new; %Denormalization: let F = T'FT

    coord_img1 = coord_img1';
    coord_img2 = coord_img2';

    figure(2);
    subplot(121);
    imshow(img1); 
    title('Inliers and Epipolar Lines in First Image'); hold on;
    plot(coord_img1(:,1),coord_img1(:,2),'go')
    epiLines = epipolarLine(F,coord_img1);
    points = lineToBorderPoints(epiLines,size(img1));
    line(points(:,[1,3])',points(:,[2,4])');

    subplot(122); 
    imshow(img2);
    title('Inliers and Epipolar Lines in Second Image'); hold on;
    plot(coord_img2(:,1),coord_img2(:,2),'go')
    epiLines = epipolarLine(F,coord_img2);
    points = lineToBorderPoints(epiLines,size(img2));
    line(points(:,[1,3])',points(:,[2,4])');


end

%F = RANSAC_Fundamental(p_i_new, p_i_new2, T_new);
bestMatches = 1;
end