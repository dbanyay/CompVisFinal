function [M, S, RGBvalues, short_chain_index] = estimate_3D_points(M,Imf)

[m2,n] = size(M);
%save original M
M_original = M;
count_found = 1;
for j = 1:n
       if nnz(~(M_original(:,j))) == 0
            short_chain_index(count_found) = j;
            M_set(1:6,count_found) = M_original(:,j);
            count_found = count_found + 1;
       end
end
    
    % get RGB values for current feature points
    RGBvalues{count} = getRGBValues(M_set,Imf);
        
    
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

    save('M_set','M_set') %used for myfun.m
   
    % % %solve for affine ambiguity
    A = M_set(1:2,:);        %A = A1
    Id = diag(ones(1:2));    
    L0= pinv(A)*Id*pinv(A'); %Ai*L0*Ait = Id     
    % Solve for L
    L = lsqnonlin(@myfun,L0);
    % Recover C
    C = chol(L,'lower');
    % Update M and S
    M_set = M_set*C;
    S = pinv(C)*S;
    
    count = count + 1;
    % reset M
    M_set = [];
end

