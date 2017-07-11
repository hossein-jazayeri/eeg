clear ; close all; clc

ALLEEG = [];
root_folder = 'D:\ProjectData\';
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
    
    EEG = pop_chanedit(EEG, 'lookup', standard_10_5, 'load', {standard_10_10 'filetype' 'autodetect'});
    EEG = pop_eegfiltnew(EEG, 0, 1, 3300, true, [], 0); % Higth pass filter
    EEG = pop_eegfiltnew(EEG, 0, 54, 246, 0, [], 0); % Low pass filter
    EEG = pop_rejcont(EEG, 'freqlimit', [20 40], 'taper', 'hamming');
    EEG = pop_rejchan(EEG, 'elec', [1:33], 'threshold', 5, 'norm', 'on');
    
    % ica - mara - reject ica channels
    
    EEG = pre_prepData(EEG, 'SignalType', 'Channels');
    IC = est_selModelOrder(EEG);
    
    aic_EEG = EEG;
    hq_EEG = EEG;
    fpe_EEG = EEG;
    sbc_EEG = EEG;
    
    morder = floor(mean(IC.aic.popt));
    if morder >= 5
        aic_EEG.CAT.MODEL = est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', morder);
        [aic_whitestats, aic_pc, aic_stability] = est_validateMVAR(aic_EEG, 'checkConsistency', [], 'checkResidualVariance', []);
    end
    
    morder = floor(mean(IC.fpe.popt));
    if morder >= 5
        fpe_EEG.CAT.MODEL = est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', morder);
        [fpe_whitestats, fpe_pc, fpe_stability] = est_validateMVAR(fpe_EEG, 'checkConsistency', [], 'checkResidualVariance', []);
    end
    
    morder = floor(mean(IC.hq.popt));
    if morder >= 5
        hq_EEG.CAT.MODEL = est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', morder);
        [hq_whitestats, hq_pc, hq_stability] = est_validateMVAR(hq_EEG, 'checkConsistency', [], 'checkResidualVariance', []);
    end
    
    morder = floor(mean(IC.sbc.popt));
    if morder >= 5
        sbc_EEG.CAT.MODEL = est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', morder);
        [sbc_whitestats, sbc_pc, sbc_stability] = est_validateMVAR(sbc_EEG, 'checkConsistency', [], 'checkResidualVariance', []);
    end
    
    
    % compare whiteness
    % calc connectivity for model with most whiteness
    
    Conn = est_mvarConnectivity(EEG, EEG.CAT.MODEL, 'freqs', (1:20),'connmethods', {'GPDC'});
    
    gpdc = Conn.GPDC;
    save(strcat(path, 'gpdc.mat'), 'gpdc');
    
    ggc = Conn.GGC;
    save(strcat(path, 'ggc.mat'), 'ggc');
    
    ddtf = Conn.dDTF;
    save(strcat(path, 'ddtf.mat'), 'ddtf');
    
    save(strcat(path, 'eeg.mat'), 'EEG');
    
    [ALLEEG EEG index] = eeg_store(ALLEEG, EEG, str2num(patient));
end