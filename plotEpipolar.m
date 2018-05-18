function plotEpipolar(Imf, F, x, y, xprim, yprim)
%plotEpipolar plots epipolar lines on images

img1 = Imf(:,:,1);
img2 = Imf(:,:,2);


figure;

subplot(121);
imshow(img1); 
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(x,y,'go')
epiLines = epipolarLine(F,[x' y']);
points = lineToBorderPoints(epiLines,size(img1));
line(points(:,[1,3])',points(:,[2,4])');

subplot(122); 
imshow(img2);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(xprim,yprim,'go')
epiLines = epipolarLine(F,[xprim' yprim']);
points = lineToBorderPoints(epiLines,size(img2));
line(points(:,[1,3])',points(:,[2,4])');

end

