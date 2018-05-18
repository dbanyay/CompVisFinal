function [frames,descs] = extractSIFT(Imf)
%extractSIFT extract SIFT points and save them in a frame and desc matrix



for i = 1:size(Imf,3)
    [frame,desc] = vl_sift(Imf(:,:,i));
    frames(1:size(frame,1),1:size(frame,2),i) = frame;
    descs(1:size(desc,1),1:size(desc,2),i) = desc;

end

end

