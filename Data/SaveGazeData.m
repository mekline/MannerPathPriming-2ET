function SaveGazeData(GazeData, description)
% This function takes the GazeData objects that Tobii SDK produces
% and parses it as a long-form csv (ala tidyverse)
% NOTE: This ONLY saves the point-in-display info, not pupilary/origin
% info, so add that if you want it (and save the .mats for completeness)
%
% Usage: in addition to 

global DATAFOLDER EXPERIMENT SUBJECT

assert(nargin == 2, 'Provide both some GazeData and a description of that time period');
assert(length(GazeData) > 0, 'Calibration data is empty');
assert(isa(GazeData(1),'GazeData'), 'Not gaze data, is this calibration data instead?')

gazeCell = {'subjectID', 'device_time_stamp','system_time_stamp', 'description','L_valid','L_x','L_y','R_valid','R_x','R_y'}; %Can't preallocate rows because each point may have a different n of samples


for i=1:length(GazeData)
    thisPoint = GazeData(i);
    %Check if data was collected for each eye
    if length(thisPoint.LeftEye.GazePoint.OnDisplayArea)==2
        Lx = thisPoint.LeftEye.GazePoint.OnDisplayArea(1);
        Ly = thisPoint.LeftEye.GazePoint.OnDisplayArea(2);
    else
        Lx = NaN;
        Ly = NaN;
    end
    
    if length(thisPoint.RightEye.GazePoint.OnDisplayArea)==2
        Rx = thisPoint.RightEye.GazePoint.OnDisplayArea(1);
        Ry = thisPoint.RightEye.GazePoint.OnDisplayArea(2);
    else
        Rx = NaN;
        Ry = NaN;
    end
  
    %Make a full row for each sample
    gazeCell(end+1,:) = {'pilot',...
        thisPoint.DeviceTimeStamp,...
        thisPoint.SystemTimeStamp,...
        description,...
        thisPoint.LeftEye.GazePoint.Validity,...
        Lx,...
        Ly,...
        thisPoint.RightEye.GazePoint.Validity,...
        Rx,...
        Ry};  
end

gazeTable = cell2table(gazeCell(2:end,:));
gazeTable.Properties.VariableNames = gazeCell(1,:);

%And save the folder!
filename = ['gaze_MPPCREATION_pilot_0725_All_of_Practice_1.csv'];
writetable(gazeTable, filename);


end
