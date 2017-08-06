function svm()
	[filename, path] = uigetfile('D:\Zahra\DATA\FEATURES.mat', 'Select FEATURES');
    load(strcat(path, filename)); % load selected channels to (GPDC|DDTF|PCOH)_FEATURES variable [4x33]

	[filename, path] = uigetfile('D:\Zahra\DATA\R_NR.mat', 'Select R_NR');
    load(strcat(path, filename)); % load (GPDC|DDTF|PCOH)_R_NR -> channel,channel,frequency,patient

	for measure = {'gpdc', 'ddtf', 'pcoh'}
		if strmatch(measure, 'gpdc')
			R = GPDC_R;
			NR = GPDC_NR;
			features = GPDC_FEATURES;
		elseif strmatch(measure, 'ddtf')
			R = DDTF_R;
			NR = DDTF_NR;
			features = DDTF_FEATURES;
			elseif strmatch(measure, 'pcoh')
			R = PCOH_R;
			NR = PCOH_NR;
			features = PCOH_FEATURES;
		end	
	
		R_M = mean(cat(5, permute(R, [4, 3, 1, 2]), permute(R, [4, 3, 2, 1])), 5); % patient,frequency,channel,channel
		NR_M = mean(cat(5, permute(NR, [4, 3, 1, 2]), permute(NR, [4, 3, 2, 1])), 5); % patient,frequency,channel,channel
		R_P = permute(R_M, [1 3 4 2]); % patient,channel,channel,frequency
		NR_P = permute(NR_M, [1 3 4 2]); % patient,channel,channel,frequency

		R_size = size(R_P, 1);NR_size = size(NR_P, 1);F_size = size(R_P, 4);C_size = size(R_P, 2);
		R_train_size = floor(R_size * 0.7);NR_train_size = floor(NR_size * 0.7);

		for frequency = 1:F_size
			nonzero_channels = nonzeros(features(frequency,:))';
			Rs = R_P(:, nonzero_channels, nonzero_channels, frequency);
			NRs = NR_P(:, nonzero_channels, nonzero_channels, frequency);

			nonzero_channels_size = size(nonzero_channels, 2);
			features_size = (nonzero_channels_size * (nonzero_channels_size + 1)) / 2;
			X = zeros(R_train_size + NR_train_size, features_size);
			X_test = zeros(R_size + NR_size - R_train_size - NR_train_size, features_size);

			for i = 1:R_size
				Ri = permute(Rs(i,:,:), [2, 3, 1]);
				Xi = [];
				for j = 1:nonzero_channels_size
					Xi = [Xi Ri(j,j:end)];
				end
				if i <= R_train_size
					X(i,:) = Xi;
				else
					X_test(i - R_train_size,:) = Xi;
				end
			end
			for i = 1:NR_size
				Ri = permute(NRs(i,:,:), [2, 3, 1]);
				Xi = [];
				for j = 1:nonzero_channels_size
					Xi = [Xi Ri(j,j:end)];
				end
				if i <= NR_train_size
					X(R_train_size + i,:) = Xi;
				else
					X_test(i + R_size - R_train_size - NR_train_size,:) = Xi;
				end
			end

			y = [ones(1, R_train_size) zeros(1, NR_train_size)]';
			y_test = [ones(1, R_size - R_train_size) zeros(1, NR_size - NR_train_size)]';

			model = fitcsvm(X, y, 'Standardize', true);
			fprintf('Accuracy of frequency %d train: %f, test: %f\n', frequency, ...
				mean(double(predict(model, X) == y)) * 100, ...
				mean(double(predict(model, X_test) == y_test)) * 100);
		end
	end
end
