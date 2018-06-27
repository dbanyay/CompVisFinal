function E = bundle_adjustment(D, MS, n) 

S = MS(:,1:n);
M = MS(:,n+1:end);

PX = M' * S;

E = abs(D - PX);
E = sum(sum(E));

end 