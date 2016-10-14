function [ imgcbd ] = denoised( imgcb )
    
    thresh = 1000;

    cc = bwconncomp(~imgcb);
    st = regionprops(cc);
    imgcbd = imgcb;
    
    width = size(imgcb, 1);
    for i = 1:size(st, 1)
        if st(i).Area < thresh
            cclist = cc.PixelIdxList{i};
            ccloc = [ceil(cclist / width), mod(cclist, width)];
            for j = 1:size(ccloc, 1)
                if ccloc(j, 2) ~= 0
                    imgcbd(ccloc(j, 2), ccloc(j, 1)) = true;
                else
                    imgcbd(width, ccloc(j, 1)) = true;
                end
            end
        end
    end

end