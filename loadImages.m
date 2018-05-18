function Imf = loadImages()
% loadImages loads castle model images from folder as 
% greyscale single values

cntr = 1;

for num = 586:604
    imageLoc = ['model_castle\8ADT8' num2str(num) '.JPG'];
    im = im2single(rgb2gray(imread(imageLoc)));
    if num == 1
        Imf=zeros(size(im,1),size(im,2),19);
    end
    Imf(:,:,cntr)=im;
    cntr = cntr + 1;

end

save('Imf','Imf')

end

