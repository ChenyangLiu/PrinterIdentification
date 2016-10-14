function [numPrinter, numDoc, dataPath] = readFile(p, fmt)
    
    subp = genpath(p);
    len = size(subp, 2);
    
    temp = [];
    path = {};
    numPrinter = 1;
    for i = 1:len
        if subp(i) ~= ';'
            temp = [temp subp(i)];
        else
            path{numPrinter} = [temp '\'];
            temp = [];
            numPrinter = numPrinter + 1;
        end
    end
    path = path(2:numPrinter - 1);
    numPrinter = numPrinter - 2;

    dataPath = {};
    form = strcat('*.', fmt);
    for i = 1:numPrinter
        subf = path{i};
        imglist = dir(strcat(subf, form));
        numDoc = length(imglist);
        for j = 1:numDoc
            dataPath{i, j} = strcat(subf, imglist(j).name);
        end
    end

end