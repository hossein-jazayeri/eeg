function svm()
	%[filename, path] = uigetfile('D:\Zahra\DATA\FEATURES.mat', 'Select FEATURES');
    %load(strcat(path, filename)); % load selected channels to (GPDC|DDTF|PCOH)_FEATURES variable [4x33]

	%[filename, path] = uigetfile('D:\Zahra\DATA\R_NR.mat', 'Select R_NR');
    %load(strcat(path, filename)); % load (GPDC|DDTF|PCOH)_R_NR -> channel,channel,frequency,patient
    
    load('C:\Users\Hossein Jazayeri\Documents\MATLAB\eeg\data\FEATURES.mat');
    load('C:\Users\Hossein Jazayeri\Documents\MATLAB\eeg\data\R_NR.mat');

	for measure = {'gpdc', 'pcoh', 'ddtf'}
        if strncmp(measure, 'gpdc', 4)
			R = GPDC_R;
			NR = GPDC_NR;
			features = GPDC_FEATURES;
		elseif strncmp(measure, 'ddtf', 4)
			R = DDTF_R;
			NR = DDTF_NR;
			features = DDTF_FEATURES;
        elseif strncmp(measure, 'pcoh', 4)
			R = PCOH_R;
			NR = PCOH_NR;
			features = PCOH_FEATURES;
        end

        R_size = size(R, 4);
        NR_size = size(NR, 4);
        F_size = size(R, 3);

        R_train_size = floor(R_size * 0.7);
        NR_train_size = floor(NR_size * 0.7);

        for frequency = 1:F_size
            nonzero_channels = nonzeros(features(frequency,:))';
            Rs = R(nonzero_channels, nonzero_channels, frequency, :);
            NRs = NR(nonzero_channels, nonzero_channels, frequency, :);

            nonzero_channels_size = size(nonzero_channels, 2);

            X = [];
            X_test = [];

            for i = 1:R_size
                Ri = Rs(:,:,1,i);
                right = [];
                left = [];
                for j = 1:nonzero_channels_size
                    right = [right Ri(j,j:end)];
                    left = [left Ri(j,1:j)];
                end

                if i <= R_train_size
                    X = [X; right];
                    X = [X; left];
                else
                    X_test = [X_test; right];
                    X_test = [X_test; left];
                end
            end

            for i = 1:NR_size
                Ri = NRs(:,:,1,i);
                right = [];
                left = [];
                for j = 1:nonzero_channels_size
                    right = [right Ri(j,j:end)];
                    left = [left Ri(j,1:j)];
                end

                if i <= NR_train_size
                    X = [X; right];
                    X = [X; right];
                else
                    X_test = [X_test; right];
                    X_test = [X_test; left];
                end
            end

            y = [ones(1, 2 * R_train_size) zeros(1, 2 * NR_train_size)]';
            y_test = [ones(1, 2 * (R_size - R_train_size)) zeros(1, 2 * (NR_size - NR_train_size))]';

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
