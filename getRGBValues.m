function RGBvalues = getRGBValues(M,Imf,i)
%getRGBValues get RGB values from the original image, use it for feature
%points

cntr = 1;

if i+1 >= size(Imf,4)*2
    frame = 1;
else
frame = (i+1)/2;
end

while cntr <= size(M,2)
    coordinates = round(M(3:4,cntr));
    RGBvalues(1:3,cntr) = double(Imf(coordinates(2),coordinates(1),:,frame));
    cntr = cntr + 1;
end

RGBvalues = RGBvalues./255.0;

end