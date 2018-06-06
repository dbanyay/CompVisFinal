function [M_matrix,S_matrix] = estimate_3D_points(M,Imf)
close all
count = 1;
[m2,n] = size(M);
%save original M
M_original = M;
for i = 1:2:m2-4
    count_found = 1;
    for j = 1:n
         if nnz(~(M_original(i:i+5,j))) == 0
             i:i+5
                M_set(1:6,count_found) = M_original(i:i+5,j);
                count_found = count_found + 1;
         end
    end
    
    % get RGB values for current feature points
    RGBvalues = getRGBValues(M_set,Imf);
        
    
    % % %Shift the mean of the points to zero using "repmat" command
    MC = readMeasurementMatrix(M_set);

    % % %singular value decomposition
    [U,W,V] = svd(MC);

    % % force rank (=3) constraint
    V = V';
    U = U(:,1:3);
    W = W(1:3,1:3);
    V = V(1:3,:);

    M_set = U*sqrtm(W);
    S = sqrtm(W)*V;

    save('M_set','M_set') %???
    
    % % %solve for affine ambiguity
    A = M_set(1:2,:);        %A = A1
    Id = diag(ones(1:2));    
    L0= pinv(A)*Id*pinv(A');         %Ai*L0*Ait = Id
    
%     % Solve for L
%     L = lsqnonlin(@myfun,L0);
%     % Recover C
%     C = chol(L,'lower');
%     % Update M and S
%     M_set = M_set*C;
%     S = pinv(C)*S;
    
    
    
    M_matrix{count} = M_set;
    S_matrix{count} = S;
    
    if count > 1
        [d,S_transformed{count-1}] = procrustes(S_matrix{count},S_matrix{count});
        
        hold on
        for point = 1:size(S,2)
            plot3(S_transformed{count-1}(1,point),S_transformed{count-1}(2,point),S_transformed{count-1}(3,point),'Marker','.','Color',RGBvalues(:,point));
        end
        hold off
    else
        hold on
        for point = 1:size(S,2)
        plot3(S(1,point),S(2,point),S(3,point),'Marker','.','Color',RGBvalues(:,point));
        %plot3(S(1,point),S(2,point),S(3,point),'.b');
        end
        hold off
    end
    
    count = count + 1;
    % reset M
    M_set = [];

end