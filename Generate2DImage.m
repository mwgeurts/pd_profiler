function [res, image] = Generate2DImage(profile)
% Generate2DImage creates a 2D image by radially projecting a 1D profile
% around in 360 degrees. The resolution of the 2D image is based on the
% resolution of the profile. The profile is expected to be an [n x m]
% array, where n is the length of the profile elements and m is at least
% two. This function will assume the first column are radial values, while
% the last column contains image values. 
%
% This function will return two variables, a [2 x 1] array of resolutions,
% and an [2n-1 x 2n-1 array] of image values. Note, the function will
% extrapolate the last value of the profile for all image positions
% exceeding the profile.
%
% Example usage:
% 
%  profile = [0,5;1,4;2,3;3,2;4,1;5,0];
%  [res, image] = Generate2DImage(profile)
%  imagesc(image)
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

% Calculate image resolution as the minimum resolution of the input profile
res = repmat(min(abs(diff(profile(:,1)))), [1 2]);

% Calculate image at provided resolution
x = ceil(abs(profile(end,1)-profile(1,1))/res(1));
image = repmat(1:2*x-1, [2*x-1 1]);
image = interp1(profile(:,1), profile(:, end), sqrt((image - x) .^ 2 + ...
    (image' - x) .^ 2) * res(1), 'linear', profile(end, end));

% Clean up
clear x;
