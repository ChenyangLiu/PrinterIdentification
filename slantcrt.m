function [ imgc ] = slantcrt( img )

    k = 15;
    sizethresh = 100;
    D = 8;

    bw = ~im2bw(img, graythresh(img));
    cc = bwconncomp(bw);
    st = regionprops(cc);

    for i = size(st):-1:1
        if st(i).Area < sizethresh
            st(i) = [];
        end
    end
    
    centors = zeros(size(st, 1), 2);
    for i = 1:size(st, 1)
        c = st(i).BoundingBox;
        centors(i, :) = [c(1) + 0.5*c(3), c(2) + c(4)];
    end

    Mdl = KDTreeSearcher(centors);
    idx = knnsearch(Mdl, centors, 'k', k+1);
    slant = zeros(size(idx, 1), 1);

    parfor i = 1:size(idx, 1)
        coor = centors(idx(i,:),:);
        dis = +Inf;
        for m = 2:k-1
            for n = m+1:k
                if abs(det([coor(n,:)-coor(m,:);coor(1,:)-coor(m,:)]))/norm(coor(n,:)-coor(m,:)) < dis
                    closem = m;
                    closen = n;
                    dis = abs(det([coor(n,:)-coor(m,:);coor(1,:)-coor(m,:)]))/norm(coor(n,:)-coor(m,:));
                end
            end
        end
        disq1q2 = norm(coor(closem, :) - coor(closen, :));
        disq1p = norm(coor(closem, :) - coor(1, :));
        disq2p = norm(coor(1, :) - coor(closen, :));
        if disq1q2 > disq1p && disq1q2 > disq2p
            line = [coor(closem,:);coor(closen,:)];
        else if disq1p > disq2p
                line = [coor(closem,:);coor(1,:)];
            else
                line = [coor(1,:);coor(closen,:)];
            end
        end

        lineset = [];
        for j = 1:size(idx, 1)
            if abs(det([line(2,:)-line(1,:);centors(j,:)-line(1,:)]))/norm(line(2,:)-line(1,:)) < D
                lineset = [lineset; centors(j,:)];
            end
        end
        b = regress(lineset(:,2), [lineset(:,1) ones(size(lineset,1),1)]);
        slant(i) = b(1);

    end
    
    left = -1;
    right = 1;
    step = 0.0001;
    histogram = zeros(size(left:step:right, 2),1);
    for i = 1:size(slant, 1)
        if slant(i) <= right && slant(i) >= left
            histogram(round((slant(i) - left) / step) + 1) = histogram(round((slant(i) - left) / step) + 1) + 1;
        end
    end
    [~, ang] = max(histogram);
    ang = (ang - 1) * step + left;
    
    imgs = imsubtract(uint8(255*ones(size(img))),img);
    imgc = imrotate(imgs, atan(ang)*180/pi, 'bilinear', 'crop');
    imgc = imsubtract(uint8(255*ones(size(imgc))),imgc);
    
end