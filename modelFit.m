function modelFit()
    [input_root, inputs, output_root] = getPath(false, 'folder', true);
    input_size = size(inputs, 2);
    for index = 1:input_size
        patient_number = inputs(index);
        patient_input_path = strcat(patient_number, '.set');
        EEG = pop_loadset('filename', patient_input_path, 'filepath', input_root);

        EEG = pop_est_selModelOrder(EEG, {'winlen', 2, 'winstep', 0.03});
        EEG = pop_est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', 10);
        EEG = pop_est_validateMVAR(aic_EEG, 'checkConsistency', [], 'checkResidualVariance', []);
        Conn = est_mvarConnectivity(EEG, EEG.CAT.MODEL, 'freqs', (1:28),'connmethods', {'GPDC', 'dDTF', 'pCoh'});
        gpdc = Conn.GPDC;
        ddtf = Conn.dDTF;
        ddtf = Conn.pCoh;
        icoh = Conn.iCoh;
        dtf = Conn.DTF;
        ggc = Conn.GGC;
        save(strcat(output_root, '\', patient_number, '.mat'), 'gpdc', 'ddtf', 'pcoh', 'dtf', 'icoh', 'ggc');
    end
end
