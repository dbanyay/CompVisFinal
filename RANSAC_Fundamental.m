function [F, chosen_randindex] = RANSAC_Fundamental(p_i, p_i_prime, T)

    nummatches = 8;

    for repeat = 1:10

        randindex = randperm(max(size(p_i)),nummatches); %select 8 unique indexes randomly
        
        %pick 8 point correspondences randomly to construct a fundamental
        %matrix F' (normalized F)
        for i = 1:nummatches
            p_i_eight(:,i) = [p_i(:,randindex(i));1];
            p_i_prime_eight(:,i) = [p_i_prime(:,randindex(i));1];
        end
        F_eight = getFundamentalM(p_i_eight, p_i_prime_eight, T, 'n'); 
        %the other correspondences
        count = 1;
        i = 1;
        while count <= 20
            if ismember(count,randindex) == 0 %to tell if the value of count is found in the vector randindex or not
                p_i_rest(:,i) = [p_i(:,count);1];
                p_i_prime_rest(:,i) = [p_i_prime(:,count);1];
                i = i + 1;
            end
            count = count + 1;
        end
        
        threshold = 0.01; 
        inliercntr = 0;
        for i = 1:20-nummatches
            c1 = F_eight*p_i_rest(:,i); %Fpi
            c2 = F_eight'*p_i_rest(:,i); %F'pi
            d(repeat,i) = ((p_i_prime_rest(:,i)'*F_eight*p_i_rest(:,i))^2)/(c1(1)^2+c1(2)^2+c2(1)^2+c2(2)^2);
            if d(repeat,i) < threshold
                inliercntr = inliercntr+1;
            end
        end
    inliers(repeat) = inliercntr;
    all_randindex(repeat,:) = randindex;
    end


[max_val, ind] = max(inliers);
chosen_randindex = all_randindex(ind,:);
count = 1;
i = 1;
while count <= 20
      if ismember(count,chosen_randindex) == 0 %to tell if the value of count is found in the vector randindex or not
            p_i_inliers(:,i) = [p_i(:,count);1];
            p_i_prime_inliers(:,i) = [p_i_prime(:,count);1];
            i = i + 1;
      end
      count = count + 1;
end
F = getFundamentalM(p_i_inliers, p_i_prime_inliers, T, 'd'); 
end