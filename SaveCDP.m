function SaveCDP(profile, filename, varargin)
% SaveCDP saves an input [n x 4] profile array to the filename string in
% W2CAD format. An optional third input argument containing a string
% filename to an existing W2CAD file may be included, in which case the
% header from this file will be copied to the output file.
%
% Note, this function can only write a single profile array to a W2CAD
% file.
%
% Example usage:
%  profile = [1:50; zeros(1,50); zeros(1,50); rand(1,50)]';
%  SaveCDP(profile, 'outputFile.cdp');
%
%  existingFile = 'existingFile.cdp';
%  SaveCDP(profile, 'outputFile.cdp', existingFile);
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

% Open write handle to text file
fid = fopen(filename, 'wt');

% If header filename is included, copy that file's header to output file
if nargin == 3
    fid2 = fopen(varargin{1}, 'rt');
    
    % Loop through lines of text
    while ~feof(fid2)
        
        % Read next line
        tline = fgetl(fid2);

        % Continue to write until data lines are found
        if length(tline) > 1 && strcmp(tline(1), '<')
            break;
        else
            fprintf(fid, '%s\n', tline);
        end
    end

    % Close file handle and clean up
    fclose(fid2);
    clear fid2 tline;

% Otherwise, write generic header
else
    fprintf(fid, '%s\n', '$NUMS 001');
    fprintf(fid, '%s\n', '$STOM');
end

% Write profile array
for i = 1:size(profile, 1)
    fprintf(fid, '<%+.1f %+.1f %+.1f %+.1f>\n', profile(i, 1:4));
end

% Write footer
fprintf(fid, '%s\n', '$ENOM');
fprintf(fid, '%s\n', '$ENOF');

% Close file handle and clean up
fclose(fid);
clear fid i;

