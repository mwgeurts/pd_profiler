function [center, corrected] = OptimizeCorrection(radial, image, res)
% OptimizeCorrection calculates an optimized radial profile correction
% based on a target radial profile and source image.
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

% Start optimization at center of target image
center = size(image)/2 + 0.5;

% Normalize image to 1.000 at center
image = image / image(ceil(center(1)), ceil(center(2)));

% Normalize radial to 1.000 at origin
radial(:,2) = radial(:,2) / radial(1,2);

% Initialize corrected radial x and y values
n = 20;
x = (0:1/(n-1):1)'*radial(end,1);
y = ones(length(x)-1, 1);

% Display progress dialog
d = waitbar(0, 'Optimizing calibration correction');
p = 0;

% Run optimization
m = 5000;
options = optimset('Display', 'off', 'MaxFunEvals', m, 'MaxIter', m);
vars = [center, y'];
vars = fminsearch(@objectiveFunction, vars, options);
center = vars(1:2);
corrected = [x, [1 vars(3:end)]'];

% Clean up
close(d);
clear d p m;

% Define optimization function
function f = objectiveFunction(c)

    % Update waitbar
    p = p + 1/m;
    waitbar(min(p,1), d);

    % Calculate radial coordinates of image pixels
    r = sqrt(((repmat(1:size(image,2), [size(image,1) 1]) - c(2)) * res(2)) .^ 2 + ...
        ((repmat(1:size(image,1), [size(image,2) 1])' - c(1)) * res(1)) .^ 2);

    % Apply correction to radial profile
    cr = radial(:,2) .* interp1(x, [1 c(3:end)], radial(:,1), 'linear', 1);
    
    % Objective is abs difference between image and corrected profile
    f = sum(sum(abs(interp1(radial(:,1), cr, r, 'linear', 0) - image)));

end

% End main function
end


    
