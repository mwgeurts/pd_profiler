function [center, profile] = ImageSymmetricCenter(image)
% FindSymmetricCenter runs an optimization to find the pixel coordinates 
% around which a 2D image is most symmetric. It returns two variables, a 
% [2 x 1] vector of center coordinates and a [n x 1] array representing the
% mean radial profile from the center coordinate to the edge of the
% image.
%
% Example usage:
%  image = phantom();
%  [center, profile] = ImageSymmetricCenter(double(image));
%
% Author: Mark Geurts, mark.w.geurts@gmail.com
% Copyright (C) 2022 Aspirus, Inc.
%
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the  
% Free Software Foundation, either version 3 of the License, or (at your 
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along 
% with this program. If not, see http://www.gnu.org/licenses/.

% Define number of rays to average and initialize profile/profiles arrays
rays = 32;
profile = zeros(max(size(image)), 1);
profiles = zeros(max(size(image)), rays);

% Start optimization at center of image
center = size(image)/2 + 0.5;

% Display progress dialog
d = waitbar(0, 'Aligning measured image');
p = 0;

% Run optimization
options = optimset('Display', 'iter');
center = fminsearch(@objectiveFunction, center, options);

% Clean up
close(d);
clear rays profiles x y d p;

% Clip profile NaNs
profile = profile(~isnan(profile));

% Define optimization function
function f = objectiveFunction(c)

    % Update waitbar
    p = p + 0.005;
    waitbar(min(p,1), d);

    % Loop through rays
    for i = 1:rays
        
        % Convert to cartesian
        [x, y] = pol2cart(repmat(i/rays*2*pi, [1 size(profiles,1)]), ...
            0:size(profiles,1)-1);
    
        % Interpolate profile, extrapolating with NaN when outside image
        profiles(:,i) = interp2(image, x + c(2), y + c(1), 'linear', NaN);
    end

    % Calculate median profile
    profile = median(profiles, 2, 'omitnan');

    % Calculate sum square difference from average
    f = sum((profiles - repmat(profile, [1 rays])) .^ 2, 'all', 'omitnan');
end

% End main function
end