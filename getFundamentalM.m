function F = getFundamentalM(p_i, p_i_prime, T, T_new, s)


colume1 = p_i(1,:).*p_i_prime(1,:); %x*x'
colume2 = p_i(1,:).*p_i_prime(2,:); %x*y'
colume3 = p_i(1,:); %x
colume4 = p_i(2,:).*p_i_prime(1,:); %y*x'
colume5 = p_i(2,:).*p_i_prime(2,:); %y*y'
colume6 = p_i(2,:); %y
colume7 = p_i_prime(1,:); %x'
colume8 = p_i_prime(2,:); %y'
colume9 = ones(1,length(p_i(1,:)));


A = [colume1', colume2', colume3', colume4', colume5', colume6', colume7', colume8', colume9'];
[U,D,V] = svd(A); % A = UDV'
F = reshape(V(:,9),3,3);
[Uf,Df,Vf] = svd(F);
Df(3,3) = 0; %Set the smallest singular value in the diagonal matrix Df to zero
normalized_F = Uf*Df*Vf'; %Recompute F : F = UfDfVf'

%choose to output normalized F or denormalized F
if strcmp(s,'n')
    F = normalized_F;
elseif strcmp(s,'d')
    F = T_new'*normalized_F*T; %Denormalization: let F = T'FT
end