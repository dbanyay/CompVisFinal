function [frames,descs] = loadHessaff(Imf)
%loadHessaff Load result of Hessian corner detector

cntr = 1;

%% Load Castle

for num = 586:604

      [fa, da] = vl_sift(single(Imf(:,:,cntr)),'PeakThresh', 1.5);
      
      frames(:,1:size(fa,2),cntr) = fa;
      descs(:,1:size(da,2),cntr) = da;
    
%     imageLoc = ['model_castle_features_m\8ADT8' num2str(num) '.ppm.hesaff.sift'];
% 
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame1 = impoints(1:5,:);
%     desc1 = impoints(6:end,:);
%     
%     imageLoc = ['model_castle_features_m\8ADT8' num2str(num) '.ppm.haraff.sift'];
%     
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame2 = impoints(1:5,:);
%     desc2 = impoints(6:end,:);
%     
%     imageLoc = ['model_castle_features_m\8ADT8' num2str(num) '.ppm.harhes.sift'];
%     
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame3 = impoints(1:5,:);
%     desc3 = impoints(6:end,:);
%     
%     frames(:,1:size(frame1,2)+size(frame2,2)+size(frame3,2),cntr) = [frame1 frame2 frame3];
%     descs(:,1:size(desc1,2)+size(desc2,2)+size(desc3,2),cntr) = [desc1 desc2 desc3];
    
    cntr = cntr + 1;

end

%% Load Teddybear

% for num = 1:16
%     %imageLoc = ['model_castle_small_features\8ADT8' num2str(num) '.ppm.harhes'];
%     
%     imageLoc = ['teddybear_features_m\obj02_0' num2str(cntr, '%02d') '.ppm.harhes.sift'];
% 
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame1 = impoints(1:5,:);
%     desc1 = impoints(6:end,:);
%     
%     imageLoc = ['teddybear_features_m\obj02_0' num2str(cntr, '%02d') '.ppm.haraff.sift'];
%     
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame2 = impoints(1:5,:);
%     desc2 = impoints(6:end,:);
%     
%     imageLoc = ['teddybear_features_m\obj02_0' num2str(cntr, '%02d') '.ppm.hesaff.sift'];
%     
%     impoints = importdata(imageLoc, ' ',2);
%     impoints = impoints.data';
% 
%     frame3 = impoints(1:5,:);
%     desc3 = impoints(6:end,:);
%     
%     
%     frames(:,1:size(frame1,2)+size(frame2,2)+size(frame3,2),cntr) = [frame1 frame2 frame3];
%     descs(:,1:size(desc1,2)+size(desc2,2)+size(desc3,2),cntr) = [desc1 desc2 desc3];
%     
%     cntr = cntr + 1;
% 
% end


end

