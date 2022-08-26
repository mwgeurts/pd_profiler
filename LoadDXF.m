function [offset, res, image, field] = LoadDXF(filename, varargin)
% LoadCDP loads a image from an DXF file. This function accepts up to two
% arguments: a string containing the file name and an boolean indicating 
% whether to return the full image (false or not specified) or clipped to 
% the field edge (true). The function will return four variables: [N x 1] 
% array of image offsets, [N x 1] array of axis resolutions, an ND array of 
% image values, and a two element vector field size [X, Y].
%
% Example usage for a 2D image:
% 
%  [offset, res, image, field] = LoadDXF('path/to/DXF_file.dxf');
%  imagesc(image);
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

% Open read handle to text file
fid = fopen(filename, 'rt');

% Initialize return variables
field = zeros(1,2);

% Loop through lines of text
while ~feof(fid)
    
    % Read next line
    tline = fgetl(fid);
    
    % If line contains dimensions, initialize return variables
    if length(tline) > 11 && strcmp(tline(1:11), 'Dimensions=')
        offset = zeros(sscanf(tline, 'Dimensions=%i'), 1);
        res = offset;
        dims = offset;
    
    % If line contains image dimensions, set dimensions array
    elseif length(tline) > 4 && strcmp(tline(1:4), 'Size')
        x = sscanf(tline, 'Size%i=%i');
        dims(x(1)) = x(2);
    
    % If line contains image resolution, set return variable
    elseif length(tline) > 3 && strcmp(tline(1:3), 'Res')
        x = sscanf(tline, 'Res%i=%f');
        res(x(1)) = x(2);
    
    % If line contains image offsets, set return variable
    elseif length(tline) > 6 && strcmp(tline(1:6), 'Offset')
        x = sscanf(tline, 'Offset%i=%f');
        offset(x(1)) = x(2);

    % If line contains field size, set return variable
    elseif length(tline) > 6 && strcmp(tline(1:5), 'CollX')
        x = sscanf(tline, 'CollX%i=%f');
        field(1) = field(1) + abs(x(2));
    elseif length(tline) > 6 && strcmp(tline(1:5), 'CollY')
        x = sscanf(tline, 'CollY%i=%f');
        field(2) = field(2) + abs(x(2));
    
    % If line contains data flag, read to end of file
    elseif length(tline) >= 6 && strcmp(tline(1:6), '[Data]')
        image = reshape(fscanf(fid, '%f'), dims');
        clear x dims;
        break;
    end
end

% Close file handle and clean up
fclose(fid);
clear tline fid;

% If an input flag is provided, clip the image to the field edges
if nargin > 1 && varargin{1}

    % Return only the indices of image with at least 10 values above 30%
    image = image(sum(image > max(max(image)) * 0.3, 2) > 10, ...
        sum(image > max(max(image)) * 0.3, 1) > 10);
    clear x y;
end
