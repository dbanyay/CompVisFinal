function plot3Dpoints(S_matrix, correspond_indexes, RGBvalues)

hold on
for point = 1:size(S_matrix{1},2)
    plot3(S_matrix{1}(1,point),S_matrix{1}(2,point),S_matrix{1}(3,point),'Marker','.','Color',RGBvalues{1}(:,point));
end
hold off
count = 1;
while count < length(S_matrix)
        correspond_index = correspond_indexes{count};
        S_1 = S_matrix{count};
        S_1 = S_1(:,correspond_index(1,:));
        S_2 = S_matrix{count+1};
        S_2 = S_2(:,correspond_index(2,:));
        [d,z,transform{count}] = procrustes(S_1',S_2');
        transform_info = transform{count};
        transformed_S = transform_info.b*S_matrix{count+1}'*transform_info.T + mean(transform_info.c,1);
        S_transformed{count} = transformed_S';
        
        hold on
        for point = 1:size(S_transformed{count},2)
            plot3(S_transformed{count}(1,point),S_transformed{count}(2,point),S_transformed{count}(3,point),'Marker','.','Color',RGBvalues{count+1}(:,point));
        end
        hold off

    
    count = count + 1;
end
