% Define input files
targetIntensityProfileCDP = './10X_Open Field - 00_Intensity Profile.cdp';
currentCalibrationCDP = './10X_COMPOSITE_20CM.cdp';
measuredImageDXF = './TB1344_10X.dxf';

% Define output file
newCalibrationCDP = './10X_NEW_CALIBRATION.cdp';

% Load and sort profiles from W2CAD files
targetProfile = sortrows(LoadCDP(targetIntensityProfileCDP));
currentCalibration = sortrows(LoadCDP(currentCalibrationCDP));

% Load DXF measured image, clipping outer edges
[~, measuredResolution, measuredImage] = LoadDXF(measuredImageDXF);
measuredImage = measuredImage(11:end-11, 11:end-11);

% Find symmetric center profile of measured image
[~, measuredProfile(:,2)] = ImageSymmetricCenter(measuredImage);
measuredProfile(:,1) = (0:length(measuredProfile)-1)*measuredResolution(1);

% Calculate new calibration profile from target/measured profile difference
newProfile = currentCalibration;
newProfile(:,4) = currentCalibration(:,4) .* interp1(targetProfile(:,1), ...
    targetProfile(:,4), currentCalibration(:,1), 'linear', targetProfile(end,4)) ...
    ./ interp1(measuredProfile(:,1), measuredProfile(:,2), ...
    currentCalibration(:,1), 'linear', targetProfile(end,4));

% Renormalize to current calibration value
newProfile(:,4) = newProfile(:,4) * currentCalibration(1,4)/newProfile(1,4);

% Save new calibration profile to W2CAD format, using header from current
SaveCDP(newProfile, newCalibrationCDP, currentCalibrationCDP);


