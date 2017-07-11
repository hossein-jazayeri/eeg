clear ; close all; clc

root_folder = 'D:\Zahra\ProjectData\';
standard_10_5 = 'C:\Program Files\MATLAB\eeglab13_6_5b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';
standard_10_10 = 'C:\Program Files\MATLAB\eeglab13_6_5b\sample_locs\Standard-10-10-Cap33.locs';
patients = dir(root_folder);
patients = {patients([patients.isdir]).name};
patients = patients(~ismember(patients,{'.','..'}));
[r c] = size(patients);

for index = 1:c
    patient = patients(index);
    path = strcat(root_folder, patient, '\');
    file_name = strcat('TMSRestEEG_', patient, '_01.vhdr');
    EEG = pop_loadbv(path{1}, file_name{1});
    
    EEG = pop_select( EEG,'nochannel',{'LeftMast' 'RightMast'});
    EEG = pop_chanedit(EEG, 'lookup', standard_10_5, 'load', {standard_10_10 'filetype' 'autodetect'});
    EEG = pop_resample( EEG, 256);
    
    % High pass filter
    EEG = pop_eegfilt(EEG, 1, 0, [], [0], 0, 0, 'fir1', 0);
   
    
    %clean line 60 120
    EEG = cleanline(EEG, 'bandwidth',2,'computepower',1,'linefreqs',[60 120] ,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',1);
    
    % Low pass filter
    EEG = pop_eegfiltnew(EEG, [], 54, 66, 0, [], 0);
    
    %refrencing
    EEG = pop_reref( EEG, []);
    
    %rejection
    EEG = pop_rejcont(EEG, 'freqlimit', [20 40], 'taper', 'hamming');
    EEG = pop_rejchan(EEG, 'elec', [1:33],'threshold', 5, 'norm', 'on');
   
    %SIFTing!
    EEG = pre_prepData(EEG, 'SignalType', 'Channels');
    %IC = est_selModelOrder(EEG);
    %morder = floor(mean(IC.aic.popt));
    %EEG.CAT.MODEL = est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', morder);
    %[aic_whitestats, aic_pc, aic_stability] = est_validateMVAR(EEG, 'checkConsistency', [], 'checkResidualVariance', []);
    % compare whiteness
    % calc connectivity for model with most whiteness
    %Conn = est_mvarConnectivity(EEG, EEG.CAT.MODEL, 'freqs', (1:20),'connmethods', {'GPDC'});
    %gpdc = Conn.GPDC;
    %save(strcat(path, 'gpdc.mat'), 'gpdc');
    
    %save preproccessing
    path = strcat(path, 'eeg2.set');
    save(path{1}, 'EEG');
end