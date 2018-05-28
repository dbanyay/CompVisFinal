function [F, inlier_index] = RANSAC_Fundamental(p_i, p_i_prime, T, T_new)

    nummatches = 8;

    for repeat = 1:10

        randindex = randperm(max(size(p_i)),nummatches); %select 8 unique indexes randomly
        
        %pick 8 point correspondences randomly to construct a fundamental
        %matrix F' (normalized F)
        for i = 1:nummatches
            p_i_eight(:,i) = [p_i(:,randindex(i));1];
            p_i_prime_eight(:,i) = [p_i_prime(:,randindex(i));1];
        end
        F_eight = getFundamentalM(p_i_eight, p_i_prime_eight, T, T_new, 'n');  %normalized F
        
        threshold = 50; 
        inliercntr = 0;
        for i = 1:length(p_i)
            c1 = F_eight*[p_i(:,i);1]; %Fpi
            c2 = F_eight'*[p_i_prime(:,i);1]; %F'pi'
            nom = ([p_i_prime(:,i);1]'*F_eight*[p_i(:,i);1])^2;
            denom = c1(1)^2+c1(2)^2+c2(1)^2+c2(2)^2;
            d(repeat,i) = 1000* (nom / denom);
            if d(repeat,i) < threshold
                inliercntr = inliercntr+1;
                inlier_ind(repeat,inliercntr) = i; 
            end
        end
    inliers(repeat) = inliercntr;
    end


[max_val, ind] = max(inliers);
inlier_index = inlier_ind(ind,:);

for i = 1:length(inlier_index)
       p_i_inliers(:,i) = [p_i(:,inlier_index(i));1];
       p_i_prime_inliers(:,i) = [p_i_prime(:,inlier_index(i));1];
       i = i + 1;
end

F = getFundamentalM(p_i_inliers, p_i_prime_inliers, T, T_new, 'd'); 
end