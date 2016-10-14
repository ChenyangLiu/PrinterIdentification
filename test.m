%% Do Test
clearvars;
load('feature.mat');
trainstart = 1;
trainend = 30;
teststart = 31;
testend = 70;
klvl = 1;
% Identification mode:
% ptls, ptli, ptls-ptli, ptli-ptls : based on paper
mode = 'myptls-ptli';
error = [];
result = zeros(numPrinter, numPrinter);
for i = 1:numPrinter
    for j = teststart:testend
        ret = getresult(feature{i, j}, fontsize{i,j}, feature(:,trainstart:trainend), mode, klvl);
        result(i, ret) = result(i, ret) + 1;
        if i ~= ret
            error = [error; i, j , ret];
        end
    end
end
accuracy = trace(result) / (numPrinter*(testend-teststart+1));