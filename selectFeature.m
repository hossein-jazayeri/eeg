function selectFeature()
	max_FEATURES_count = 33;
    max_significance_level = 0.051;
    r_ids = [727;729;731;732;766;790;792;802;811;812;814;823;828;830;839;843;856;870;879;905;911;913;915;919;];
    nr_ids = [730;749;752;784;821;824;826;827;838;847;848;850;855;874;876;877;881;896;906;920;924;];

    [input_root, inputs, output_root] = getPath(false, 'file', true); % LOAD ZERO PADDED DATA
    patients_count = size(inputs, 2);

	r_index = 1; nr_index = 1;
	GPDC_R  = zeros(33, 33, 4, size(r_ids, 1));
	GPDC_NR = zeros(33, 33, 4, size(nr_ids, 1));
	DDTF_R  = zeros(33, 33, 4, size(r_ids, 1));
	DDTF_NR = zeros(33, 33, 4, size(nr_ids, 1));
	PCOH_R  = zeros(33, 33, 4, size(r_ids, 1));
	PCOH_NR = zeros(33, 33, 4, size(nr_ids, 1));
	
	disp('Constructing R & NR...');
	for index = 1:patients_count
		filename = inputs(index);
		patient_number = str2num(filename{1}(1:3));

		if isempty(strmatch(patient_number, r_ids)) && isempty(strmatch(patient_number, nr_ids))
			continue;
		end

		path = strcat(input_root, '\', filename);
		load(path{1}); % load gpdc, ddtf, pcoh

		GPDC_C = timeFrequencyAggregation(gpdc);
		DDTF_C = timeFrequencyAggregation(ddtf);
		PCOH_C = timeFrequencyAggregation(pcoh);
		
		if strmatch(patient_number, r_ids)
			disp(strcat(num2str(patient_number), ' is responder'));
			GPDC_R(:,:,:,r_index) = GPDC_C;
			DDTF_R(:,:,:,r_index) = DDTF_C;
			PCOH_R(:,:,:,r_index) = PCOH_C;
			r_index = r_index + 1;
		else
			disp(strcat(num2str(patient_number), ' is non-responder'));
			GPDC_NR(:,:,:,nr_index) = GPDC_C;
			DDTF_NR(:,:,:,nr_index) = DDTF_C;
			PCOH_NR(:,:,:,nr_index) = PCOH_C;
			nr_index = nr_index + 1;
		end
	end
	disp('Done');
	save(strcat(output_root, '\R_NR.mat'), 'GPDC_R', 'GPDC_NR', 'DDTF_R', 'DDTF_NR', 'PCOH_R', 'PCOH_NR');

	for measure = {'gpdc', 'ddtf', 'pcoh'}
		if strmatch(measure, 'gpdc')
			R_M = mean(GPDC_R, 4);
			NR_M = mean(GPDC_NR, 4);
		elseif strmatch(measure, 'ddtf')
			R_M = mean(DDTF_R, 4);
			NR_M = mean(DDTF_NR, 4);
			elseif strmatch(measure, 'pcoh')
			R_M = mean(PCOH_R, 4);
			NR_M = mean(PCOH_NR, 4);
		end
		FEATURES = zeros(4, max_FEATURES_count);

		fprintf('Selecting significant channels on each frequency for "%s"...', measure{1});
		for frequency = 1:4
			significance_level = 0.05;
			while significance_level < max_significance_level
				test_decision = ttest2(R_M(:,:,frequency), NR_M(:,:,frequency), 'Alpha', significance_level);
				FEATURES_count = size(find(test_decision == 1), 2);
				significance_level = significance_level + 0.001;
			end

			padd_size = max_FEATURES_count - size(find(test_decision == 1), 2);
			if padd_size > 0
				FEATURES(frequency, :) = padarray(find(test_decision == 1), [0 padd_size], 'post')';
			else
				FEATURES(frequency, :) = find(test_decision == 1, FEATURES_count);
			end
		end
		disp('Done');

		if strmatch(measure, 'gpdc')
			GPDC_FEATURES = FEATURES;
		elseif strmatch(measure, 'ddtf')
			DDTF_FEATURES = FEATURES;
		elseif strmatch(measure, 'pcoh')
			PCOH_FEATURES = FEATURES;
		end

		fprintf('max significance level: %f\n', significance_level);
	end
	save(strcat(output_root, '\FEATURES.mat'), 'GPDC_FEATURES', 'DDTF_FEATURES', 'PCOH_FEATURES');
end
