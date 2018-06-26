function [S_matrix, correspond_indexes, RGBvalues] = sfm_for_castle(pointViewMatrix,Imf)

[m2,n] = size(pointViewMatrix);
count = 1;
for i = 1:2:m2-1
    switch i
        case m2-3 
            M_set(1:4,:) = pointViewMatrix(i:i+3,:);
            M_set(5:6,:) = pointViewMatrix(1:2,:); %TODO
            M_long = [pointViewMatrix(i:i+3,:); pointViewMatrix(1:4,:)];
        case m2-5
            M_set(1:4,:) = pointViewMatrix(i:i+3,:);
            M_set(5:6,:) = pointViewMatrix(1:2,:); %TODO
            M_long = [pointViewMatrix(i:i+5,:); pointViewMatrix(1:2,:)];
        case m2-1
            M_set(1:2,:) = pointViewMatrix(i:i+1,:);
            M_set(3:6,:) = pointViewMatrix(1:4,:); %TODO
            M_long = 0;
        otherwise
            M_set = pointViewMatrix(i:i+5,:);
            M_long = pointViewMatrix(i:i+7,:);
end
    
    [M, S, RGBvalue,short_chain_index] = estimate_3D_points(M_set,Imf,i);
    
    long_chain_index = find_long_chain(M_long,'s');
    if size(long_chain_index,2) > 1
        intersected_index = intersect(short_chain_index,long_chain_index);
        for j = 1:length(intersected_index)
            correspond_index_1(j) = find(short_chain_index == intersected_index(j));
            correspond_index_2(j) = find(long_chain_index == intersected_index(j));
        end
        correspond_indexes{count} = [correspond_index_1; correspond_index_2];
    else
        correspond_indexes{count} = 0;
    end
    correspond_index_1 = [];
    correspond_index_2 = [];
    S_matrix{count} = S;
    RGBvalues{count} = RGBvalue;
    count = count + 1;
end

end