function mask = gauss_mask_2d(sigma)
%% Calculate the Gaussian mask to filter image

mask_size = 2*ceil(sigma); % Determine the size os Gauss mask
k = (mask_size-1)/2; % Used to center the mask

% Calculate the Gaussian mask
mask = zeros(length(mask_size));
for i = 1 : mask_size
    for j = 1 : mask_size
        mask(i,j) = (1/(2*pi*(sigma^2)))*exp(-((i-(k+1))^2 + (j-(k+1))^2)/(2*(sigma^2)));
    end
end
end

