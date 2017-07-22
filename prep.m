clear ; close all; clc

root_folder = 'C:\Users\Hossein Jazayeri\Documents\MATLAB\Data\';
standard_10_5 = 'C:\Users\Hossein Jazayeri\Documents\MATLAB\eeglab14_1_1b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';
standard_10_10 = 'C:\Users\Hossein Jazayeri\Documents\MATLAB\eeglab14_1_1b\sample_locs\Standard-10-10-Cap33.locs';
patients = dir(root_folder);
patients = {patients([patients.isdir]).name};
patients = patients(~ismember(patients,{'.','..'}));
c = size(patients, 2);

for index = 1:c
    patient = patients(index);
    path = strcat(root_folder, patient, '\');
    file_name = strcat('TMSRestEEG_', patient, '_01.vhdr');
    EEG = pop_loadbv(path{1}, file_name{1});
    
    EEG = pop_select( EEG,'nochannel',{'LeftMast' 'RightMast'});
    EEG = pop_chanedit(EEG, 'lookup', standard_10_5, 'load', {standard_10_10 'filetype' 'autodetect'});
    EEG = pop_resample( EEG, 256);
    EEG = pop_rejcont(EEG, 'freqlimit', [20 40], 'taper', 'hamming');
    
    reportFile = strcat('.\Report\', patient, 'Report.pdf');
    summaryFile = strcat('.\Report\', patient, 'Summary.pdf');
    EEG = prepPipeline(EEG, struct('referenceChannels', [1:33], 'evaluationChannels', [1:33], 'rereferencedChannels', [1:33], 'lineFrequencies', [60  120], ...
        'Fs', 256, 'ignoreBoundaryEvents', true, 'cleanupReference', true, 'keepFiltered', false, 'removeInterpolatedChannels', true, ...
        'reportingLevel', 'Verbose', 'reportMode', 'normal', 'publishOn', true, 'sessionFilePath', reportFile{1}, 'summaryFilePath', summaryFile{1}));
    publishPrepReport(EEG, summaryFile{1}, reportFile{1}, 1, true);

    EEG = pre_prepData(EEG, 'SignalType', 'Channels');
    
    path = strcat(path, 'prep.set');
    save(path{1}, 'EEG');
end