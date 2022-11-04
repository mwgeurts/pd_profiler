## Portal Dosimetry Profiler

by Mark Geurts <mark.w.geurts@gmail.com>
<br>Copyright &copy; 2022, Aspirus Health

Portal Dosimetry Profiler is a MATLAB&reg; tool that can be used to create optimized PVA Beam Profile curves (.CDP) for Portal Dosimetry on a Varian&reg; TrueBeam&trade; system. MATLAB is a registered trademark of Mathworks. Varian and TrueBeam are trademarks of Varian Medical Systems, a Siemens Healthineers company.

Most recommendations are to use shallow depth water tank diagonal profiles when calibrating Dosimetry mode. While this typically works well for small fields and low energies, discrepancies are often observed for higher energies and larger fields which can impact Portal Dosimetry QA results. This tool will create a calibration curve that optimizes the MV panel response to your Portal Dosimetry calculation algorithm/model similar to the approaches presented in Bailey <sup>[1]</sup> and Hobson <sup>[2]</sup>.

## Installation and Use

Note this tool currently only optimizes line profile (.CDP) calibration files, and will not optimize 2D (.DXF) calibrations. Download the PDProfiler.mlapp and other repository files and run in MATLAB&reg; 2021 or later. Then follow the steps below for each beam energy you wish to optimize:

1. Import the provided DICOM RT Plan to calculate a planned image of an open field. Note, the provided plan is for standard MLC120 machines. Contact the author if you need an HD120 plan.
2. Deliver the field on your portal dosimeter and measure the panel response.
3. Obtain the calibration file used in PVA calibration.
4. Export the planned and measured Portal Dosimetry images in .DXF format.
5. Using this app, load the current Beam Profile calibration, planned image, and measured image into the tool.
6. The tool will scale the current calibration profile by the difference between the planned and measured open field image.

## License and Liability

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

THIS TOOL IS FOR RESEARCH USE ONLY AND SHOULD NOT BE USED IN PAIENT CARE. Any action you take upon the information from this tool is strictly at your own risk. The author and all affiliated institutions are not liable for any losses and damages in connection with the use of this application.

## References

1. Bailey DW, Kumaraswamy L, Podgorsak MB. An effective correction algorithm for off-axis portal dosimetry errors. Med Phys. 2009; 36(9): 4089–94. https://doi.org/10.1118/1.3187785
2. Hobson MA and Davis SD. Comparison between an in-house 1D profile correction method and a 2D correction provided in Varian's PDPC Package for improving the accuracy of portal dosimetry images. J of Appl Clin Med Phys. 2015; 16: 43-50. https://doi.org/10.1120/jacmp.v16i2.4973
