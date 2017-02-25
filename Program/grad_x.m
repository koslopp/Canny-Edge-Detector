function Gx = grad_x(I)
%% Find gradient in x direction with Sobel Mask
sobel_mask = [-1 0 1;-2 0 2;-1 0 1]; % Sobel mask
Ip = padarray(I,[1 1],'replicate'); % Pad borders to avoid false edges
tmp = conv2(Ip,sobel_mask,'same'); % Convolution result
Gx = tmp(2:end-1,2:end-1); % Pick just image size (remove pad)
end