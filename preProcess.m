function preProcess()
    [input_root, inputs, output_root, standard_10_5, standard_10_10] = getPath(true);
    input_size = size(inputs, 2);
    for index = 1:input_size
        patient_number = inputs(index);
        patient_input_path = strcat(input_root, '\', patient_number, '\');
        file_name = strcat('TMSRestEEG_', patient_number, '_01.vhdr');
        EEG = pop_loadbv(patient_input_path{1}, file_name{1});

        EEG = pop_select( EEG,'nochannel',{'LeftMast' 'RightMast'});
        EEG = pop_chanedit(EEG, 'lookup', standard_10_5, 'load', {standard_10_10 'filetype' 'autodetect'});
        EEG = pop_resample( EEG, 256);
        EEG = pop_rejcont(EEG, 'freqlimit', [20 40], 'taper', 'hamming');

        EEG = prepPipeline(EEG, struct('referenceChannels', [1:33], 'evaluationChannels', [1:33], 'rereferencedChannels', [1:33], 'lineFrequencies', [60  120], ...
            'Fs', 256, 'ignoreBoundaryEvents', true, 'cleanupReference', true, 'keepFiltered', false, 'removeInterpolatedChannels', true, ...
            'reportingLevel', 'Verbose', 'reportMode', 'normal'));

        EEG = pre_prepData(EEG, 'SignalType', 'Channels');

        patient_output_path = strcat(output_root, '\', patient_number, '.set');
        save(patient_output_path{1}, 'EEG');
    end
end