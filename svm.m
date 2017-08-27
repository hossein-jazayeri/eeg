function svm()
	%[filename, path] = uigetfile('D:\Zahra\DATA\FEATURES.mat', 'Select FEATURES');
    %load(strcat(path, filename)); % load selected channels to (GPDC|DDTF|PCOH)_FEATURES variable [4x33]

	%[filename, path] = uigetfile('D:\Zahra\DATA\R_NR.mat', 'Select R_NR');
    %load(strcat(path, filename)); % load (GPDC|DDTF|PCOH)_R_NR -> channel,channel,frequency,patient

    for measure = {'gpdc', 'pcoh', 'ddtf', 'ggc', 'dtf', 'icoh'}
        if strncmp(measure, 'gpdc', 4)
            Rs = GPDC_R;
            NRs = GPDC_NR;
            features = GPDC_FEATURES;
        elseif strncmp(measure, 'ddtf', 4)
            Rs = DDTF_R;
            NRs = DDTF_NR;
            features = DDTF_FEATURES;
        elseif strncmp(measure, 'pcoh', 4)
            Rs = PCOH_R;
            NRs = PCOH_NR;
            features = PCOH_FEATURES;
        elseif strncmp(measure, 'ggc', 4)
            Rs = GGC_R;
            NRs = GGC_NR;
            features = GPDC_FEATURES;
        elseif strncmp(measure, 'dtf', 4)
            Rs = DTF_R;
            NRs = DTF_NR;
            features = DDTF_FEATURES;
        elseif strncmp(measure, 'icoh', 4)
            Rs = ICOH_R;
            NRs = ICOH_NR;
            features = PCOH_FEATURES;
        end

        Rs_dataset_size = size(Rs, 4);
        NRs_dataset_size = size(NRs, 4);
        F_size = size(Rs, 3);
        
        for frequency = 1:F_size
            NZ_channels = nonzeros(features(frequency,:))';
            NZ_channels_size = size(NZ_channels, 2);
            NZ_Rs = Rs(NZ_channels, NZ_channels, frequency, :);
            NZ_NRs = NRs(NZ_channels, NZ_channels, frequency, :);

            %[X, y, X_test, y_test] = doubleInputSize(NZ_Rs, NZ_NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, 0.7);
            %[X, y, X_test, y_test] = doubleInputSizeExcludeDiagonal(NZ_Rs, NZ_NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, 0.7);
            [X, y, X_test, y_test] = correspondingsMeanExcludeDiagonal(NZ_Rs, NZ_NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, 0.7);

            model = fitcsvm(X, y, 'Standardize', true);
            fprintf('measure: "%s", frequency: "%d", train accuracy: "%f", test accuracy: "%f"\n', measure{1}, frequency, ...
                mean(double(predict(model, X) == y)) * 100, ...
                mean(double(predict(model, X_test) == y_test)) * 100);
        end
    end
    
    % Expose all variables to main scope
    A = who;
    for i = 1:length(A)
        assignin('base', A{i}, eval(A{i}));
    end
end
