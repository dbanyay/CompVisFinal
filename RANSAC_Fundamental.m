function inlier_index = RANSAC_Fundamental(coord_img1, coord_img2, p_i, p_i_prime, T, T_new)

    nummatches = 8;

    for repeat = 1:100
        %pick 8 point correspondences randomly to construct a fundamental
        %matrix F (denormalized F)
        randindex = randperm(max(size(p_i)),nummatches); %select 8 unique indexes randomly

        p_i_eight = [p_i(:,randindex);ones(1,nummatches)];
        p_i_prime_eight = [p_i_prime(:,randindex);ones(1,nummatches)];

        F_eight = getFundamentalM(p_i_eight, p_i_prime_eight, T, T_new, 'd');  %denormalized F
        
        threshold = 20; 
        match1 = [coord_img1;ones(1,length(coord_img1))];
        match2 = [coord_img2;ones(1,length(coord_img1))];
        nom = (diag(match2'*(F_eight*match1))').^2;
        Fm1 = F_eight*match1;
        Fm2 = F_eight'*match2;
        denom = sum([Fm1(1:2,:);Fm2(1:2,:)].^2);
        d(repeat,:) = nom./denom;
        inlier_ind{repeat} = find(d(repeat,:) < threshold);
        inliers(repeat) = length(inlier_ind{repeat});
    end


[max_val, ind] = max(inliers);
inlier_index = inlier_ind{ind};

end