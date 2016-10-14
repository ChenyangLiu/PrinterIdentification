clear all;
load('feature.mat');
load('p.mat');
klvl = 1;
% Identification mode:
% ptls, ptli, ptls-ptli, ptli-ptls : based on paper
mode = 'myptls-ptli';
loopsize = 1;
acc = zeros(1,loopsize);
tic;
for l = 1:loopsize
     train = p(l,1:30);
    test = p(l,31:50);     test = [51:70];
    result = zeros(numPrinter, numPrinter);
    for i = 1:numPrinter
        for j = test
            ret = getresult(feature{i, j}, fontsize{i,j}, feature(:,train), mode, klvl);
            result(i, ret) = result(i, ret) + 1;
        end
    end
    acc(l) = trace(result) / (numPrinter*size(test,2));
end
toc / (loopsize*size(test,2))
accuracy = mean(acc);