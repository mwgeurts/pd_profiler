% Define input files
targetProfileDXF = './10X_PDIP.dxf';
currentCalibrationCDP = './10X_COMPOSITE_20CM.cdp';
measuredImageDXF = './TB1344_10X.dxf';

% Define output file
newCalibrationCDP = './10X_NEW_CALIBRATION.cdp';

% Load and sort profiles from W2CAD files
currentCalibration = sortrows(LoadCDP(currentCalibrationCDP));

% Load target DXF image 
[~, targetResolution, targetImage] = LoadDXF(targetProfileDXF);

% Extract radial profile
[x, y] = pol2cart(repmat(pi/4, [1 size(targetImage,1)]), ...
            0:size(targetImage,1)-1);
x = x + size(targetImage,2)/2 + 0.5;
y = y + size(targetImage,1)/2 + 0.5;
targetProfile = zeros(size(targetImage,1), 2);
targetProfile(:,2) = interp2(targetImage, x, y, 'linear', NaN);
targetProfile(:,1) = (0:size(targetProfile,1)-1)*targetResolution(1);

% Load Measured DXF
[~, measuredResolution, measuredImage] = LoadDXF(measuredImageDXF);
measuredImage = measuredImage(11:end-11, 11:end-11);

% Find symmetric center profile of measured image
[~, measuredProfile(:,2)] = ImageSymmetricCenter(measuredImage);
measuredProfile(:,1) = (0:size(measuredProfile,1)-1)*measuredResolution(1);

% Calculate new calibration profile from target/measured profile difference
newProfile = currentCalibration;
newProfile(:,end) = currentCalibration(:,end) .* interp1(targetProfile(:,1), ...
    targetProfile(:,end), currentCalibration(:,1), 'linear', targetProfile(end,end)) ...
    ./ interp1(measuredProfile(:,1), measuredProfile(:,2), ...
    currentCalibration(:,1), 'linear', targetProfile(end,end));

% Renormalize to current calibration value
newProfile(:,end) = newProfile(:,end) * currentCalibration(1,end)/newProfile(1,end);

% Save new calibration profile to W2CAD format, using header from current
SaveCDP(newProfile, newCalibrationCDP, currentCalibrationCDP);


