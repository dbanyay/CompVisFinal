function RGBvalues = getRGBValues(M,Imf)
%getRGBValues get RGB values from the original image, use it for feature
%points

cntr = 1;

while cntr <= size(M,2)
    coordinates = round(M(3:4,cntr));
    RGBvalues(1:3,cntr) = Imf(coordinates(2),coordinates(1),:,2);
    cntr = cntr + 1;
end

RGBvalues = RGBvalues./255;

end

