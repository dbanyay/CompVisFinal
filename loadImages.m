function Imf = loadImages()
% loadImages loads castle model images from folder as 
% greyscale single values

cntr = 1;


%% For castle
% for num = 586:604
%     %imageLoc = ['model_castle_small\8ADT8' num2str(num) '.JPG'];
%     imageLoc = ['model_castle\8ADT8' num2str(num) '.JPG'];
%     im = imread(imageLoc);
%     %imwrite(im, ['8ADT8' num2str(num) '.ppm']);
%     if num == 1
%         Imf=zeros(size(im,1),size(im,2),3,19);
%     end
%     Imf(:,:,:,cntr)=im;
%     cntr = cntr + 1;
% 
% end



%% For teddybear
for num = 1:20

    imageLoc = ['teddybear\obj02_0' num2str(num, '%02d') '.png'];
    im = imread(imageLoc);
    %imwrite(im, ['8ADT8' num2str(num) '.ppm']);
    if num == 1
        Imf=zeros(size(im,1),size(im,2),3,19);
    end
    Imf(:,:,:,cntr)=im;
    cntr = cntr + 1;

end

save('Imf','Imf')

end

