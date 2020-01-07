function state = pooling(data,pooling_a)
    % calculation layer operation
    [data_row,data_col] = size(data);
    [pooling_row,pooling_col] = size(pooling_a);
    for m = 1:data_col/pooling_col
        for n = 1:data_row/pooling_row
            state(m,n) = sum(sum(data(2*m-1:2*m,2*n-1:2*n).*pooling_a));
        end
    end
end