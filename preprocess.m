function [ ret ] = preprocess( img )

    borderwidth = 500;
    [m, n] = size(img);
    img(1:borderwidth, :) = 255;
    img(m-borderwidth:m, :) = 255;
    img(:, 1:borderwidth) = 255;
    img(:, n-borderwidth:n) = 255;

	imgc = slantcrt(img);
	imgcb = im2bw(imgc, graythresh(imgc));
	ret = denoised(imgcb);

end