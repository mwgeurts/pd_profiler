function PlotNormalizedProfiles(arrays, handle, method)
% PlotNormalizedProfiles plots a cell array of [n x m] matrices to the 
% provided axes handle. For each cell array, the elements (n) within the 
% first and last columns (m) are plotted, normalized based on method.
% 
% Method can be one of the following strings:
%   'none' for no normalization
%   'first' to normalize to the first value
%   'max' to normalize to the max value
%   'mean' to normalize to the average value
%
% Example usage:
%  profiles = {[1:10;rand(1,10)]', [1:10;rand(1,10)]'};
%  PlotNormalizedProfiles(profiles, figure, 'max');
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

% Normalize values based on method input
s = 0;
for i = 1:length(arrays)
    if ~isempty(arrays{i})
        s = i;
        switch method
            case 'first'
                arrays{i}(:,end) = arrays{i}(:,end)/arrays{i}(1,end);
            case 'max'
                arrays{i}(:,end) = arrays{i}(:,end)/max(arrays{i}(:,end));
            case 'mean'
                arrays{i}(:,end) = arrays{i}(:,end)/mean(arrays{i}(:,end));
        end
    end
end

% Plot first non-empty array
axes(handle);
plot(handle, arrays{s}(:,1), arrays{s}(:,end));
hold(handle, 'on');

% Loop through remaining arrays, plotting non-empty ones
for i = 2:length(arrays)
    if ~isempty(arrays{i})
        plot(handle, arrays{i}(:,1), arrays{i}(:,end));
    else
        plot(handle, NaN,NaN);
    end
end

% Finish plot
hold(handle, 'off');

% Clean up 
clear s i;
