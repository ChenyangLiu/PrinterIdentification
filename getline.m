function [ b ] = getline( line )

    desthresh = 10;
    
    seg = 0;
    for i = 2:size(line, 1)
        if line(i, 1) - line(i-1, 1) > desthresh
            seg = [seg; i-1];
        end
    end
    seg = [seg; size(line, 1)];
    
    if size(seg, 1) == 2
        left = 1;
        mid = size(line, 1);
        right = size(line, 1);
    else if size(seg, 1) >= 3
            diffseg = [];
            for i = 2:size(seg, 1)
                diffseg = [diffseg; seg(i) - seg(i-1)];
            end
            [~, ind] = max(diffseg);
            left = seg(ind) + 1;
            mid = seg(ind + 1);
            right = seg(min(ind + 2, size(seg, 1)));
        end
    end
    
	baseline = line(left:mid, :);
	desline = line(mid+1:right, :);

	b = [ones(size(baseline, 1),1) baseline(:,2)] \ baseline(:, 1);

	desdiff = desline(:, 1) - b(1) + b(2).*desline(:, 2);
	r = mean(desdiff);

	baseline = [baseline; desline(:, 1) - r, desline(:, 2)];
	b = [ones(size(baseline, 1),1) baseline(:,2)] \ baseline(:, 1);
    b = b';

end