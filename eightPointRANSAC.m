function bestMatches = eightPointRANSAC(Imf,frames,descs)
%eightPointRANSAC Find best matches with 8 point RANSAC method


%% Select 20 random matches
for i = 1:size(Imf,3) %% TODO change later to all images

    [matches, scores] = vl_ubcmatch (descs(:,:,i), descs(:,:,i+1));

    nummatches = 20; % number of random selected matches

    randindexes = randi([1, size(matches,2)],1,nummatches);

    for j = 1:nummatches
        randmatches(:,j) = matches(:,randindexes(j));
    end

    plotDiff(Imf(:,:,i),randmatches,frames(:,:,i),frames(:,:,i+1));
    pause(0.1)
    
end


%% 8 point algorithm, fundamental matrix

for i = 1:length(randmatches) %construct A
    
    index  = matches(:,i); 
    
    x(i) = frames1(1,index(1));
    y(i) = frames1(2,index(1));
    xprim(i) = frames2(1,index(2));
    yprim(i) = frames2(1,index(2));
    
    A(i,:) = [x(i)*xprim(i) x(i)*yprim(i) x(i) y(i)*xprim(i)  y(i)*yprim(i) y(i) xprim(i) yprim(i) 1];

end

[U,D,V] = svd(A); % A = UDV' 

[minvalue,minindex] = min(D(D>0));

F = reshape(V(:,minindex),3,3);

[Uf,Df,Vf] = svd(F); 

[minvalue,minindex] = min(Df(Df>0));

Df(minindex,minindex) = 0;

F = Uf*Df*Vf';

%% Normalized eight-point

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

%% Plot epipolar lines
plotEpipolar(Imf,Fdenorm);


end

