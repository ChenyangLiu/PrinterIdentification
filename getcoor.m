function [ coor,font ] = getcoor( imgb )

    cc = bwconncomp(~imgb);
    st = regionprops(cc);

    tmp = zeros(size(st, 1), 3);
    for i = 1:size(st, 1)
        c = st(i).BoundingBox;
        tmp(i, :) = [c(2) + c(4), c(1) + 0.5*c(3), c(4)];
    end

    tmp = sortrows(tmp, 1);
    coor = tmp(:, 1:2);
    font = tmp(:, 3);

end