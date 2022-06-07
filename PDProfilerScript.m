% Define input files
targetIntensityProfileCDP = './6X_Open Field - 00_Intensity Profile.cdp';
currentCalibrationCDP = './6X_COMPOSITE_20CM.cdp';
measuredImageDXF = './TB1344_6X.dxf';

% Define output file
newCalibrationCDP = './6X_NEW_CALIBRATION.cdp';

% Load profiles from W2CAD files
targetProfile = LoadCDP(targetIntensityProfileCDP);
currentCalibration = LoadCDP(currentCalibrationCDP);

% Load DXF measured image, clipping outer edges
[~, measuredResolution, measuredImage] = LoadDXF(measuredImageDXF);
measuredImage = measuredImage(11:end-11, 11:end-11);

% Find symmetric center profile of measured image
[~, measuredProfile] = ImageSymmetricCenter(measuredImage);

% Calculate new calibration profile from target/measured profile difference
newProfile = currentCalibration;
newProfile(:,4) = currentCalibration(:,4) ./ interp1(targetProfile(:,1), ...
    targetProfile(:,4), currentCalibration(:,1), 'linear', targetProfile(end,4)) ...
    .* interp1((0:length(measuredProfile)-1)*measuredResolution(1), measuredProfile, ...
    currentCalibration(:,1), 'linear', targetProfile(end,4));

% Renormalize to current calibration value
newProfile(:,4) = newProfile(:,4) * currentCalibration(1,4)/newProfile(1,4);

% Save new calibration profile to W2CAD format, using header from current
%SaveCDP(newProfile, newCalibrationCDP, currentCalibrationCDP);


