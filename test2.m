clear all;
load('feature.mat');
teststart = 31;
testend = 70;
klvl = 1;
% Identification mode:
% ptls, ptli, ptls-ptli, ptli-ptls : based on paper
mode = 'myptls-ptli';
accuracy = zeros(1,30);
tic;
parfor k = 1:30
    acc = 0;
    for l = 1:1
        disp([k,l]);
%         pick = randperm(30,k);
        pick = 1:k;
        result = zeros(numPrinter, numPrinter);
        for i = 1:numPrinter
            for j = teststart:testend
                ret = getresult(feature{i, j}, fontsize{i,j}, feature(:,pick), mode, klvl);
                result(i, ret) = result(i, ret) + 1;
            end
        end
        acc = acc + trace(result) / (numPrinter*(testend-teststart+1));
    end
    accuracy(k) = acc / 1;
end
toc;