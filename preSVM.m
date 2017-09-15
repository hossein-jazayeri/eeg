function preSVM()
    measures = {'gpdc', 'pcoh', 'ddtf', 'ggc', 'dtf', 'icoh'};
	[filename, path] = uigetfile('D:\Zahra\DATA\FEATURES.mat', 'Select FEATURES');
    load(strcat(path, filename)); % load selected channels to FEATURES variable [4x33]

	[filename, path] = uigetfile('D:\Zahra\DATA\Rs_NRs.mat', 'Select Rs_NRs');
    S = load(strcat(path, filename)); % load Rs & NRs -> channel,channel,frequency,patient
    Xy = containers.Map;
    fprintf('measure | frequency | train accuracy | test accuracy\n');
    for measure = measures
        Rs = S.Rs(measure{1});
        NRs = S.NRs(measure{1});
        features = FEATURES(measure{1});

        Rs_dataset_size = size(Rs, 4);
        NRs_dataset_size = size(NRs, 4);
        F_size = size(Rs, 3);

        for frequency = 1:F_size
            NZ_channels = features{frequency};
            NZ_channels_size = size(NZ_channels, 2);
            NZ_Rs = Rs(NZ_channels, NZ_channels, frequency, :);
            NZ_NRs = NRs(NZ_channels, NZ_channels, frequency, :);

            %[X, y, X_test, y_test] = doubleInputSize(NZ_Rs, NZ_NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, 0.7);
            [X, y, X_test, y_test] = doubleInputSizeExcludeDiagonal(NZ_Rs, NZ_NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, 0.7);
            %[X, y, X_test, y_test] = correspondingsMeanExcludeDiagonal(NZ_Rs, NZ_NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, 0.7);

            Xy(strcat(measure{1}, num2str(frequency))) = [[X;X_test] [y;y_test]];

            model = svmtrain(X, y);
            fprintf('%s          %d           %.1f%%           %.1f%%\n', measure{1}, frequency, ...
                mean(double(svmclassify(model, X) == y)) * 100, mean(double(svmclassify(model, X_test) == y_test)) * 100);
        end
    end

    Xy_gpdc_1 = Xy('gpdc1');Xy_gpdc_2 = Xy('gpdc2');Xy_gpdc_3 = Xy('gpdc3');Xy_gpdc_4 = Xy('gpdc4');
    Xy_ggc_1 = Xy('ggc1');Xy_ggc_2 = Xy('ggc2');Xy_ggc_3 = Xy('ggc3');Xy_ggc_4 = Xy('ggc4');
    Xy_ddtf_1 = Xy('ddtf1');Xy_ddtf_2 = Xy('ddtf2');Xy_ddtf_3 = Xy('ddtf3');Xy_ddtf_4 = Xy('ddtf4');
    Xy_dtf_1 = Xy('dtf1');Xy_dtf_2 = Xy('dtf2');Xy_dtf_3 = Xy('dtf3');Xy_dtf_4 = Xy('dtf4');
    Xy_icoh_1 = Xy('icoh1');Xy_icoh_2 = Xy('icoh2');Xy_icoh_3 = Xy('icoh3');Xy_icoh_4 = Xy('icoh4');
    Xy_pcoh_1 = Xy('pcoh1');Xy_pcoh_2 = Xy('pcoh2');Xy_pcoh_3 = Xy('pcoh3');Xy_pcoh_4 = Xy('pcoh4');
    
    % Expose all variables to main scope
    A = who;
    for i = 1:length(A)
        assignin('base', A{i}, eval(A{i}));
    end
end
