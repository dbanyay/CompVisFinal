function [frames,descs] = loadHessaff()
%loadHessaff Load result of Hessian corner detector

cntr = 1;

for num = 586:604
    imageLoc = ['model_castle_small_features\8ADT8' num2str(num) '.ppm.harhes'];
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

