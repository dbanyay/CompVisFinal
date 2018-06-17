function long_chain_index = find_long_chain(M)

if size(M,1) ~= 0
    [m2,n] = size(M);
    %save original M
    M_original = M;

    count_found = 1;
    for j = 1:n
           if nnz(~(M_original(:,j))) == 0
                long_chain_index(count_found) = j; %store index of long chain
                M_set(1:8,count_found) = M_original(:,j);
                count_found = count_found + 1;
           end
    end

    if count_found == 1
        long_chain_index = 0;
    end
else
    long_chain_index = 0;
end

end