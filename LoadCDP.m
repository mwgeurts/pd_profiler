function profile = LoadCDP(varargin)
% LoadCDP loads a profile from a W2CAD file. This function accepts one or
% two arguments: a string containing the file name, and (optionally) an
% integer index of the profile to measure (if there are multiple profiles
% in the W2CAD file). The function will return an [n x 4] array of profile
% values.
%
% Example usage:
% 
%  profile = LoadCDP('path/to/W2CADfile.cdp');
%  profile = LoadCDP('path/to/W2CADfile.cdp', 3);
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

% Validate inputs
if nargin == 0
    warning("LoadCDP usage: profile = LoadCDP('path/to/W2CADfile.cdp');");
    return;
end

% Open read handle to text file
fid = fopen(varargin{1}, 'rt');

% Initialize profiles cell array
profiles = {};

% Loop through lines of text
while ~feof(fid)
    
    % Read next line
    tline = fgetl(fid);
    
    % If line contains start of measurement (STOM) flag
    if length(tline) >= 5 && strcmp(tline(1:5), '$STOM')
        
        % Add entry to profiles
        profiles{length(profiles)+1} = double.empty(0, 4); %#ok<AGROW>
        
        % Loop until end flag is found
        while ~feof(fid)
           
            % Read next line
            tline = fgetl(fid);
            
            % If end of measurement (ENOM) flag found, break
            if length(tline) >= 5 && strcmp(tline(1:5), '$ENOM')
                break;
                
            % Otherwise, if profile data, add to array
            elseif length(tline) > 1 && strcmp(tline(1), '<')
                profiles{length(profiles)} = [profiles{length(profiles)}  
                    sscanf(tline, '<%f %f %f %f>')'];
            end
        end
    end
end

% Close file handle and clean up
fclose(fid);
clear tline fid;

% Return the requested profile
if nargin > 1 && length(profiles) > varargin{2}
    profile = profiles{varargin{2}};
elseif length(profiles) == 1
    profile = profiles{1};
else
    error('Not enough profiles were found in the requested file');
end

% Remove empty columns from profile
% profile = profile(:,any(profile));