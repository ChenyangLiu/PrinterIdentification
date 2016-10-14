function [ error ] = checkfeature( feature )

    [n, m] = size(feature);
    s = zeros(n, 1);
    error = [];
    for i = 1:m
        for j = 1:n
            s(j) = size(feature{j, i}, 1);
        end
        if size(unique(s), 1) ~= 1
                error = [error; i];
        end
    end

end