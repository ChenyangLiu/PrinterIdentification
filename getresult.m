function [ ret ] = getresult( test, fontsize, train, mode, klvl)

    interploymethod = 'linear';

	[numPrinter, numDoc] = size(train);

    if strcmp(mode, 'ptls')
        dist = zeros(numPrinter*numDoc, 1);
        for i = 1:numPrinter
            for j = 1:numDoc
                a = test(:,2);
                b = train{i,j}(:,2);
                dist(j + (i-1)*numDoc) = featuredist(a, b, 'matchingeuc');
            end
        end
        [~, ind] = sort(dist);
        ret = ceil(ind / numDoc);
    end
    
    if strcmp(mode, 'ptli')
        dist = zeros(numPrinter*numDoc, 1);
        for i = 1:numPrinter
            for j = 1:numDoc
                a = test(2:size(test,1), 1) - test(1:size(test,1)-1, 1);
                b = train{i,j}(2:size(train{i,j},1), 1) - train{i,j}(1:size(train{i,j},1)-1, 1);
                dist(j + (i-1)*numDoc) = featuredist(a, b, 'matchingeuc');
            end
        end
        [~, ind] = sort(dist);
        ret = ceil(ind / numDoc);
    end
    
    if strcmp(mode, 'ptls-ptli')
        dist = zeros(numPrinter*numDoc, 1);
        for i = 1:numPrinter
            for j = 1:numDoc
                a = test(:,2);
                b = train{i,j}(:,2);
                dist(j + (i-1)*numDoc) = featuredist(a, b, 'matchingeuc');
            end
        end
        [~, ind] = sort(dist);
        ind = ind(1:ceil(size(ind, 1) / 2));
        dist = zeros(size(ind, 1), 1);
        for i = 1:size(ind, 1)
            printerno = ceil(ind(i) / numDoc);
            docno = ind(i) - (printerno - 1)*numDoc;
            a = test(2:size(test,1), 1) - test(1:size(test,1)-1, 1);
            b = train{printerno,docno}(2:size(train{printerno,docno},1), 1) - train{printerno,docno}(1:size(train{printerno,docno},1)-1, 1);
            dist(i) = featuredist(a, b, 'matchingeuc');
        end
        dist = [dist ind];
        dist = sortrows(dist, 1);
        ret = ceil(dist(:, 2) / numDoc);
    end
    
    if strcmp(mode, 'ptli-ptls')
        dist = zeros(numPrinter*numDoc, 1);
        for i = 1:numPrinter
            for j = 1:numDoc
                a = test(2:size(test,1), 1) - test(1:size(test,1)-1, 1);
                b = train{i,j}(2:size(train{i,j},1), 1) - train{i,j}(1:size(train{i,j},1)-1, 1);
                dist(j + (i-1)*numDoc) = featuredist(a, b, 'matchingeuc');
            end
        end
        [~, ind] = sort(dist);
        ind = ind(1:ceil(size(ind, 1) / 2));
        dist = zeros(size(ind, 1), 1);
        for i = 1:size(ind, 1)
            printerno = ceil(ind(i) / numDoc);
            docno = ind(i) - (printerno - 1)*numDoc;
            a = test(:,2);
            b = train{printerno, docno}(:,2);
            dist(i) = featuredist(a, b, 'matchingeuc');
        end
        dist = [dist ind];
        dist = sortrows(dist, 1);
        ret = ceil(dist(:, 2) / numDoc);
    end
    
    if strcmp(mode, 'myptls')
        % PTLS特征用插值后的train与test距离比较
        dist = zeros(numPrinter*numDoc, 1);
        for i = 1:numPrinter
            for j = 1:numDoc
                a = interp1(train{i,j}(:,1), train{i,j}(:,2), test(:,1), interploymethod, 'extrap');
                dist(j + (i-1)*numDoc) = sum(abs(test(:,2) - a)) / size(test, 1);
            end
        end
        [~, ind] = sort(dist);
        ret = ceil(ind / numDoc);
    end
    
    if strcmp(mode, 'myptli')
        % 考虑特征为： x表示第几行 y表示该行与前行的距离 从第二行开始
        % 12pt: 81/104 18pt:42/104
        dist = zeros(numPrinter*numDoc, 1);
        stdlinespc = 249;
        % Get test feature
        b = zeros(size(test, 1), 2);
        b(1,:) = [1, 0];
        for i = 2:size(fontsize, 1)
            if fontsize(i) > 120 && fontsize(i-1) > 120
                b(i,1) = b(i-1,1) + 2;
                b(i,2) = (test(i,1) - test(i-1,1)) / 2;
            else if fontsize(i) > 120 && fontsize(i-1) < 120
                    b(i,1) = b(i-1,1) + 1.625;
                    b(i,2) = (test(i,1) - test(i-1,1)) / 1.625;
                else if fontsize(i) < 120 && fontsize(i-1) > 120
                        b(i,1) = b(i-1,1) + 1.375;
                        b(i,2) = (test(i,1) - test(i-1,1)) / 1.375;
                    else if fontsize(i) < 120 && fontsize(i-1) < 120
                            b(i,1) = b(i-1,1) + 1;
                            b(i,2) = (test(i,1) - test(i-1,1)) / 1;
                        end
                    end
                end
            end
        end
        b = b(2:end,:);        
        for i = 1:numPrinter
            for j = 1:numDoc
                % Get train feature
                a = zeros(size(train{i,j}, 1), 2);
                a(1,:) = [train{i,j}(1,1), 0];
                cl = [];
                for k = 2:size(train{i,j}, 1);
                    linepos = train{i,j}(k,1);
                    a(k,1) = round((linepos - a(1,1)) / stdlinespc) + 1;
                    a(k,2) = linepos - train{i,j}(k-1,1);
                    if a(k,1) == a(k-1, 1)
                        cl = [cl; k];
                    end
                end
                a(cl,:) = [];
                a = a(2:end,:);
                % calc dist
                dist(j + (i-1)*numDoc) = sum(abs(interp1(a(:,1), a(:,2), b(:,1), interploymethod, 'extrap') - b(:,2))) / size(b, 1);
            end
        end
        [~, ind] = sort(dist);
        ret = ceil(ind / numDoc);
    end
    
    if strcmp(mode, 'myptls-ptli')
        dist = zeros(numPrinter*numDoc, 1);
        for i = 1:numPrinter
            for j = 1:numDoc
                dist(j + (i-1)*numDoc) = sum(abs(test(:,2) - interp1(train{i,j}(:,1), train{i,j}(:,2), test(:,1), interploymethod, 'extrap'))) / size(test, 1);
            end
        end
        [~, ind] = sort(dist);
        ind = ind(1:ceil(size(ind, 1) / 2));
        dist = zeros(size(ind, 1), 1);
        stdlinespc = 249;
        % Get test feature
        b = zeros(size(test, 1), 2);
        b(1,:) = [1, 0];
        for i = 2:size(fontsize, 1)
            if fontsize(i) > 120 && fontsize(i-1) > 120
                b(i,1) = b(i-1,1) + 2;
                b(i,2) = (test(i,1) - test(i-1,1)) / 2;
            else if fontsize(i) > 120 && fontsize(i-1) < 120
                    b(i,1) = b(i-1,1) + 1.625;
                    b(i,2) = (test(i,1) - test(i-1,1)) / 1.625;
                else if fontsize(i) < 120 && fontsize(i-1) > 120
                        b(i,1) = b(i-1,1) + 1.375;
                        b(i,2) = (test(i,1) - test(i-1,1)) / 1.375;
                    else if fontsize(i) < 120 && fontsize(i-1) < 120
                            b(i,1) = b(i-1,1) + 1;
                            b(i,2) = (test(i,1) - test(i-1,1)) / 1;
                        end
                    end
                end
            end
        end
        b = b(2:end,:);
        for i = 1:size(ind, 1)
            printerno = ceil(ind(i) / numDoc);
            docno = ind(i) - (printerno - 1)*numDoc;
            trdata = train{printerno,docno};
            a = zeros(size(trdata, 1), 2);
            a(1,:) = [trdata(1,1), 0];
            cl = [];
            for k = 2:size(trdata, 1);
                linepos = trdata(k,1);
                a(k,1) = round((linepos - a(1,1)) / stdlinespc) + 1;
                a(k,2) = linepos - trdata(k-1,1);
                if a(k,1) == a(k-1, 1)
                    cl = [cl; k];
                end
            end
            a(cl,:) = [];
            a = a(2:end,:);
            % calc dist
            dist(i) = sum(abs(interp1(a(:,1), a(:,2), b(:,1), interploymethod, 'extrap') - b(:,2))) / size(b, 1);
        end
        dist = [dist ind];
        dist = sortrows(dist, 1);
        ret = ceil(dist(:, 2) / numDoc);
    end
    
    % Use KNN
    ret = ret(1:klvl);
    printer = zeros(numPrinter, 1);
    for i = 1:klvl
        printer(ret(i)) = printer(ret(i)) + 1;
    end
    m = max(printer);
    idx = find(printer == m);
    if size(idx, 1) ~= 1
        for i = 1:size(ret, 1)
            if find(idx == ret(i))
                ret = ret(i);
                break;
            end
        end
    else
        ret = idx;
    end

end