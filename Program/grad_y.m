function Gy = grad_y(I)
%% Find gradient in y direction with Sobel Mask
sobel_mask = [-1 -2 -1;0 0 0;1 2 1]; % Sobel mask
Ip = padarray(I,[1 1],'replicate'); % Pad borders to avoid false edges
tmp = conv2(Ip,sobel_mask,'same'); % Convolution result
Gy = tmp(2:end-1,2:end-1); % Pick just image size (remove pad)
end