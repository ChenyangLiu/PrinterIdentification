function [ dist ] = featuredist( a, b, mode )

    if strcmp(mode, 'matchingeuc');
        if size(a, 1) <= size(b,1)
            dist = +Inf;
            for i = 1:size(b,1)-size(a,1)+1
                d = sum((a - b(i:i+size(a,1)-1)).^2)  / size(a, 1);
                dist = min([dist, d]);
            end
        else
            dist = +Inf;
            for i = 1:size(a,1)-size(b,1)+1
                d = sum((b - a(i:i+size(b,1)-1)).^2) / size(b, 1);
                dist = min([dist, d]);
            end
        end
    end

end

