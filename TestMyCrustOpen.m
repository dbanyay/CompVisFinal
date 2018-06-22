

%WARNING WORKSPACE WILL BE CLEARED !!!!!
clc
clear
close all

%Instructions :

%just uncomment one of the following line and run


%% Open points cloud:
% load Nefertiti.mat
% load Hypersheet.mat
% load pipes.mat
% load Monkey2.mat
% load Foot.mat
% load HandOliver
% load Falangi.mat
% load Mannequin
% load cactus.mat

load bear
load b_RGB

p = S_concat';



%% Run  program
[t]=MyCrustOpen(p);

%% plot the points cloud
figure;
set(gcf,'position',[0,0,1280,800]);
subplot(1,2,1)
hold on
axis equal
title('Points Cloud','fontsize',14)
plot3(p(:,1),p(:,2),p(:,3),'g.')
axis vis3d
view(3)


%% plot the output triangulation

limit = 150; %limit for edge lenght


figure;
hold on
title('Output Triangulation','fontsize',14)
axis equal
%trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor',C,'edgecolor','b')%plot della superficie


for i = 1:size(t,1) % size(t,1)
    
    index = t(i,:);
    color(1,:) = RGB_concat(:,index(1));
    color(2,:) = RGB_concat(:,index(2));
    color(3,:) = RGB_concat(:,index(3));
    
    color_avg = mean(color);
    
    edge_len(i,1) = sqrt((p(index(1),1)-p(index(2),1))^2+(p(index(1),2)-p(index(2),2))^2+(p(index(1),3)-p(index(2),3))^2);
    edge_len(i,2) = sqrt((p(index(1),1)-p(index(3),1))^2+(p(index(1),2)-p(index(3),2))^2+(p(index(1),3)-p(index(3),3))^2);
    edge_len(i,3) = sqrt((p(index(2),1)-p(index(3),1))^2+(p(index(2),2)-p(index(3),2))^2+(p(index(2),3)-p(index(3),3))^2);
    
    if(edge_len(i,1) <= limit && edge_len(i,2) <= limit && edge_len(i,3) <= limit)
    trisurf(t(i,:),p(:,1),p(:,2),p(:,3),'facecolor',color_avg,'edgecolor','b')%plot della superficie
    end
end

hold off
axis vis3d
view(3)


