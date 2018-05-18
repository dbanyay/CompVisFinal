function bestMatches = eightPointRANSAC(Imf,frames,descs)
%eightPointRANSAC Find best matches with 8 point RANSAC method


%% Select 20 random matches
for i = 1:size(Imf,3)-1 %% TODO change later to all images

    [matches, scores] = vl_ubcmatch (descs(:,:,i), descs(:,:,i+1));

    nummatches = 20; % number of random selected matches

    randindexes = randi([1, size(matches,2)],1,nummatches);

    for j = 1:nummatches
        randmatches(:,j,i) = matches(:,randindexes(j));
    end

    plotDiff(Imf(:,:,i),randmatches(:,:,i),frames(:,:,i),frames(:,:,i+1));
     pause(0.04)
    
end


%% Normalized 8 point algorithm

for i = 1:size(randmatches,2) %construct A, only for 2 first images
    
    index  = randmatches(:,i,1); 
    
    x(i) = frames(1,index(1),1);
    y(i) = frames(2,index(1),1);
    xprim(i) = frames(1,index(2),2);
    yprim(i) = frames(1,index(2),2);   
   

end


mx = mean(x);
my = mean(y);

d = mean(sqrt((x-mx*ones(1,length(x))).^2 + (y-my*ones(1,length(x))).^2));

T = [sqrt(2)/d  0       -mx*sqrt(2)/d
     0       sqrt(2)/d  -my*sqrt(2)/d
     0          0             1];

 pi = [x;y;ones(1,length(x))];
 
 for i = 1:size(pi,2)
     piprim(:,i) = T*pi(:,i);
 end
 
for i = 1:size(piprim,2) %construct Anorm
    
    xnorm(i) = pi(1,i);
    ynorm(i) = pi(2,i);
    xnormprim(i) = piprim(1,i);
    ynormprim(i) = piprim(2,i);
    
    Anorm(i,:) = [xnorm(i)*xnormprim(i) xnorm(i)*ynormprim(i) xnorm(i) ynorm(i)*xnormprim(i)  ...
    ynorm(i)*ynormprim(i) ynorm(i) xnormprim(i) ynormprim(i) 1];

end

[Unorm,Dnorm,Vnorm] = svd(Anorm); 

[minvalue,minindex] = min(Dnorm(Dnorm>0));

Fnorm = reshape(Vnorm(:,minindex),3,3);

[Ufnorm,Dfnorm,Vfnorm] = svd(Fnorm); 

[minvalue,minindex] = min(Dfnorm(Dfnorm>0));

Dfnorm(minindex,minindex) = 0;

Fnorm = Ufnorm*Dfnorm*Vfnorm';

Fdenorm = T'*Fnorm*T; %Denormalization: let F = T'FT

plotEpipolar(Imf,Fdenorm,x,y,xprim,yprim);


bestMatches = 1;
end

