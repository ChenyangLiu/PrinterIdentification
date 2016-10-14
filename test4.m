clearvars;
load('feature.mat');
trainsize = 30;
teststart = 31;
testend = 70;
klvl = 1;
% Identification mode:
% ptls, ptli, ptls-ptli, ptli-ptls : based on paper
mode = 'myptls-ptli';
printer = 7:8;
tic;
result = zeros(8, 8);
for i = printer
    for j = teststart:testend
        ret = getresult(feature{i, j}, fontsize{i,j}, feature(printer,1:trainsize), mode, klvl);
        result(i, printer(ret)) = result(i, printer(ret)) + 1;
    end
end
atime = toc / ((testend-teststart+1)*size(printer, 2));
result = result(printer, printer);
accuracy = trace(result) / (size(printer, 2)*(testend-teststart+1));