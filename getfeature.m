function [ feature, fontsize ] = getfeature( coor, font )

	rowthresh = 100;
    linethresh = 5;

	feature = [];
    fontsize = [];
    
    lf = font(1);
	line = coor(1,:);
    pre = coor(1,:);
    for i = 2:size(coor, 1)
        if coor(i, 1) - pre(1, 1) < rowthresh
            lf = [lf; font(i)];
            line = [line; coor(i,:)];
            pre = coor(i, :);
        else
            if size(line, 1) >= linethresh
                feature = [feature; getline(line)];
                fontsize = [fontsize; round(median(lf))];
            end
            lf = font(i);
            line = coor(i, :);
            pre = coor(i, :);
        end
    end
    if size(line, 1) >= linethresh
        feature = [feature; getline(line)];
        fontsize = [fontsize; round(median(lf))];
    end
    
end