function modelFit()
    [input_root, inputs, output_root] = getPath(false);
    input_size = size(inputs, 2);
    for index = 1:input_size
        patient_number = inputs(index);
        patient_input_path = strcat(patient_number, '.set');
        EEG = pop_loadset('filename', patient_input_path, 'filepath', input_root);

        [IC, MODEL] = est_selModelOrder(EEG, {'winlen', 2, 'winstep', 0.03});
        for morder = [8, 10, 12, 14, 16, 18]
            % TODO: choose best order
            EEG.CAT.MODEL = est_fitMVAR(EEG, 'algorithm', 'Vieira-Morf', 'morder', morder);
            [whitestats, pc, stability] = est_validateMVAR(aic_EEG, 'checkConsistency', [], 'checkResidualVariance', []);
        end
        Conn = est_mvarConnectivity(EEG, EEG.CAT.MODEL, 'freqs', (1:20),'connmethods', {'GPDC', 'dDTF', 'pCoh'});
        gpdc = Conn.GPDC;
        ddtf = Conn.dDTF;
        ddtf = Conn.pCoh;
        save(strcat(output_root, '\', patient_number, '.mat'), 'gpdc', 'ddtf', 'pcoh');
    end
end
