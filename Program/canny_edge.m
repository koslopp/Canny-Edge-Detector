function Iedg = canny_edge(I,thrL,thrH,sigma)

mask = gauss_mask_2d(sigma); % Find Gaussian mask to filter image
If = conv2(I,mask,'same'); % Filter the image with Gaussian mask

% Determine gradients x and y using Sobel mask
Gx = grad_x(If); % Gradient of x direction
Gy = grad_y(If); % Gradient of y direction

% Determine magnitude and direction of Gradient
mag = sqrt(Gx.^2 + Gy.^2); % Find magnitude
theta_grad = atan2(Gy,Gx); % Find direction

% Select local maxima and supress non-maxima
Ithin = suppress(mag,theta_grad);
In = Ithin./max(max(Ithin)); % Normalize image

% Apply hysteresis threshold to find true edges
Iedg = hyst_thresh(In, thrH, thrL);
end

