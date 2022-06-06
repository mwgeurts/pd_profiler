function [offset, res, image] = LoadDXF(filename)
% LoadCDP loads a image from an DXF file. This function accepts one
% argument: a string containing the file name. The function will return
% three variables: [N x 1] array of image offsets, [N x 1] array of axis 
% resolutions, and an ND array of image values
%
% Example usage for a 2D image:
% 
%  [offset, res, image] = LoadDXF('path/to/DXFfile.dxf');
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
