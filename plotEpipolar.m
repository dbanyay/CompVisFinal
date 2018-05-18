function plotEpipolar(Imf, F)
%plotEpipolar plots epipolar lines on images

figure;

subplot(121);
imshow(img1); 
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(coord_img1(:,1),coord_img1(:,2),'go')
epiLines = epipolarLine(F,coord_img1);
points = lineToBorderPoints(epiLines,size(img1));
line(points(:,[1,3])',points(:,[2,4])');

subplot(122); 
imshow(img2);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(coord_img2(:,1),coord_img2(:,2),'go')
epiLines = epipolarLine(F,coord_img2);
points = lineToBorderPoints(epiLines,size(img2));
line(points(:,[1,3])',points(:,[2,4])');

end

