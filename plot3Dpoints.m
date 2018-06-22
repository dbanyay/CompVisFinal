function plot3Dpoints(S_matrix, correspond_indexes, RGBvalues)

hold on
for point = 1:size(S_matrix{1},2)
    plot3(S_matrix{1}(1,point),S_matrix{1}(2,point),S_matrix{1}(3,point),'Marker','.','Color',RGBvalues{1}(:,point));
end

S_transformed{1} = S_matrix{1};
count = 1;
while count < length(S_matrix)
        correspond_index = correspond_indexes{count};
        if size(correspond_index,1) == 2 %there are corresponding indexes
            S_1 = S_transformed{count};
            S_1 = S_1(:,correspond_index(1,:));
            S_2 = S_matrix{count+1};
            S_2 = S_2(:,correspond_index(2,:));
            [d,z,transform{count}] = procrustes(S_1',S_2');
            transform_info = transform{count};
            transformed_S = transform_info.b*S_matrix{count+1}'*transform_info.T + mean(transform_info.c,1);
            S_transformed{count+1} = transformed_S';
        else  %there are no corresponding indexes
            S_transformed{count+1} = S_transformed{count};
        end
        
        hold on
        for point = 1:size(S_transformed{count+1},2)
            plot3(S_transformed{count+1}(1,point),S_transformed{count+1}(2,point),S_transformed{count+1}(3,point),'Marker','.','Color',RGBvalues{count+1}(:,point));
        end
        hold off

    
    count = count + 1;
end

S_concat = S_transformed{1};

for i = 2:size(bestMatches,3)
    S_concat = [S_concat S_transformed{i}];
end

RGB_concat = RGBvalues{1};

for i = 2:size(bestMatches,3)
    RGB_concat = [RGB_concat RGBvalues{i}];
end

end


