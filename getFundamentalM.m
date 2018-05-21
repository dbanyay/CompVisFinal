function F = getFundamentalM(p_i_new, p_i_new2, T, s)


colume1 = p_i_new(1,:).*p_i_new2(1,:); %x*x'
colume2 = p_i_new(1,:).*p_i_new2(2,:); %x*y'
colume3 = p_i_new(1,:); %x
colume4 = p_i_new(2,:).*p_i_new2(1,:); %y*x'
colume5 = p_i_new(2,:).*p_i_new2(2,:); %y*y'
colume6 = p_i_new(2,:); %y
colume7 = p_i_new2(1,:); %x'
colume8 = p_i_new2(2,:); %y'
colume9 = ones(1,length(p_i_new(1,:)));


A1 = [colume1', colume2', colume3', colume4', colume5', colume6', colume7', colume8', colume9'];
[U1,D1,V1] = svd(A1); % A = UDV'
F1 = reshape(V1(:,9),3,3);
[Uf1,Df1,Vf1] = svd(F1);
Df1(3,3) = 0; %Set the smallest singular value in the diagonal matrix Df to zero
F_new1 = Uf1*Df1*Vf1'; %Recompute F : F = UfDfVf'

%choose to output normalized F or denormalized F
if strcmp(s,'n')
    F = F_new1;
elseif strcmp(s,'d')
    F = T'*F_new1*T; %Denormalization: let F = T'FT
end