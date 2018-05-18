function plotDiff(im1,matches,frames1,frames2)

%figure;
imshow(im1);
hold on

for i = 1:length(matches)
    index  = matches(:,i); 
    
    im1matches(:,i) = frames1(1:2,index(1));
    im2matches(:,i) = frames2(1:2,index(2));
    
    x = [im1matches(1,i) im2matches(1,i)];
    y = [im1matches(2,i) im2matches(2,i)];
    
    line(x,y,'Color','y');
end

h1 = vl_plotframe(im1matches) ;
set(h1,'color','r','linewidth',3);

hold off

end

