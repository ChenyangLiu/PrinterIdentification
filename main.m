clear;close all;clc;tic;

%% Read Data and Get Feature
dataoripath = 'E:\workspace\matlab\printerdata\';
databwpath = 'E:\workspace\matlab\printerbwdata\';
orifmt = 'jpg';

leftratio = 0.2;

% Since preprocess image takes long time, we can save them after
% preprocess. If isOri is true, it will read original data, preprocess and
% save them. If isOri is false, it will read bw data, and get feature
% directly. If isLoad is true, it will read bwdata if it exists, otherwise
% it will read original data.
isOri = false;
isLoad = true;

if isOri == true
    [numPrinter, numDoc, dataPath] = readFile(dataoripath, orifmt);
else
    [numPrinter, numDoc, dataPath] = readFile(databwpath, 'png');
end

feature = cell(numPrinter, numDoc);
fontsize = cell(numPrinter, numDoc);
disp(strcat(int2str(numPrinter), ' printers, ', int2str(numDoc*numPrinter), ' docs in total.'));
for i = 1:numPrinter
    if isOri == true
        mkdir(strcat(databwpath, num2str(i, '%02d')));
    end
    for j = 1:numDoc
        time = tic;
        imgname = dataPath{i, j};
        if isOri == true
            if isLoad == true && exist(strcat(databwpath, num2str(i, '%02d'), '\', num2str(j, '%03d'), '.png'), 'file')
                imgcbd = imread(strcat(databwpath, num2str(i, '%02d'), '\', num2str(j, '%03d'), '.png'), 'png');
            else
                img = imread(imgname, orifmt);
                img = rgb2gray(img);
                imgcbd = preprocess(img);
                imwrite(imgcbd, strcat(databwpath, num2str(i, '%02d'), '\', num2str(j, '%03d'), '.png'));
            end
        else
            imgcbd = imread(imgname, 'png');
        end
        [height, width] = size(imgcbd);
        imgcbd = imgcbd(round(0.5*leftratio*height+1):round(height*(1-0.5*leftratio)), round(0.5*leftratio*width+1):round(width*(1-0.5*leftratio)));
        [coor, font] = getcoor(imgcbd);
        [feature{i, j}, fontsize{i,j}] = getfeature(coor, font);
        disp(strcat('printers:', int2str(i), '/', int2str(numPrinter), ', docs:', int2str(j), '/', int2str(numDoc)));
        disp(strcat('size of feature:', int2str(size(feature{i,j}, 1))));
        toc(time);
    end
    
end
delete(gcp('nocreate'));
save feature80.mat feature numPrinter numDoc fontsize;
error = checkfeature(feature);

