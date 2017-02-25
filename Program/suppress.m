function Ithin= suppress(mag,theta)
%% Process non-maxima supression to thin edges in the figure
lim_ang = pi/8; % Step of the angle: 22.5 degrees
magp = padarray(mag,[1 1]); % Pad magnitude image with zeros
% Pass maginitude values to result. The non-maxima points will receive zero
Ithin = mag;
% For each pixel verify if it is a maximo point in a 3x3 mask accordingly
% with edge direction
for i = 1 : size(mag,1)
    for j = 1 : size(mag,2)
        % If grandient between +- 22.5 degree => Angle at horizontal
        if ((theta(i,j) > -lim_ang && theta(i,j) <= lim_ang) ||...
                (theta(i,j) > pi-lim_ang || theta(i,j) <= -pi+lim_ang))
            % If not maximo than gives zero
            if magp(i+1,j+1) < magp(i+1,j+2) || magp(i+1,j+1) < magp(i+1,j)
                Ithin(i,j) = 0;
            end
            % Gradient at horizontal
        elseif ((theta(i,j) > pi/2-lim_ang && theta(i,j) <= pi/2+lim_ang) ||...
                (theta(i,j) > -pi/2-lim_ang && theta(i,j) <= -pi/2+lim_ang))
            % If not maximo than gives zero
            if magp(i+1,j+1) < magp(i+2,j+1) || magp(i+1,j+1) < magp(i,j+1)
                Ithin(i,j) = 0;
            end
            % Gradient at +45 degrees
        elseif ((theta(i,j) > lim_ang && theta(i,j) <= pi/2-lim_ang) ||...
                (theta(i,j) > -pi/2-lim_ang && theta(i,j) <= -pi+lim_ang))
            % If not maximo than gives zero
            if magp(i+1,j+1) < magp(i+2,j) || magp(i+1,j+1) < magp(i,j+2)
                Ithin(i,j) = 0;
            end
            % Gradient at -45 degrees
        elseif ((theta(i,j) > pi/2+lim_ang && theta(i,j) <= pi-lim_ang) ||...
                (theta(i,j) > -pi+lim_ang && theta(i,j) <= -pi/2-lim_ang))
            % If not maximo than gives zero
            if magp(i+1,j+1) < magp(i,j) || magp(i+1,j+1) < magp(i+2,j+2)
                Ithin(i,j) = 0;
            end
        end
    end
end

end

