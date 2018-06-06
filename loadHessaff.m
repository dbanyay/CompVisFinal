function [frames,descs] = loadHessaff(imageLoc)
%loadHessaff Load result of Hessian corner detector

cntr = 1;

%% Load Castle

% for num = 586:604
%     %imageLoc = ['model_castle_small_features\8ADT8' num2str(num) '.ppm.harhes'];
%     
%     imageLoc = ['model_castle_features\8ADT8' num2str(num) '.ppm.hesaff.sift'];
% 
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame1 = impoints(1:5,:);
%     desc1 = impoints(6:end,:);
% %     frames(1:size(frame,1),1:size(frame,2),cntr)=frame;
% %     descs(1:size(desc,1),1:size(desc,2),cntr)=desc;
%     
%     imageLoc = ['model_castle_features\8ADT8' num2str(num) '.ppm.haraff.sift'];
%     
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame2 = impoints(1:5,:);
%     desc2 = impoints(6:end,:);
%     
%     
%     frames(:,1:size(frame1,2)+size(frame2,2),cntr) = [frame1 frame2];
%     descs(:,1:size(desc1,2)+size(desc2,2),cntr) = [desc1 desc2];
%     
%     cntr = cntr + 1;
% 
% end

%% Load Teddybear

for num = 1:20
    %imageLoc = ['model_castle_small_features\8ADT8' num2str(num) '.ppm.harhes'];
    
    imageLoc = ['teddybear_features\obj02_0' num2str(num, '%02d') '.png.harhes.sift'];

    impoints = importdata(imageLoc, ' ',2);
    impoints = impoints.data';


    frame = impoints(1:5,:);
    desc = impoints(6:end,:);
    frames(1:size(frame,1),1:size(frame,2),cntr)=frame;
    descs(1:size(desc,1),1:size(desc,2),cntr)=desc;
    cntr = cntr + 1;
end




save('frames','frames')
save('descs','descs')

end

