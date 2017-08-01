function selectFeature()
    max_significance_level = 0.051;
    r_ids = [727;729;731;732;766;790;792;802;811;812;814;823;828;830;839;843;856;870;879;905;911;913;915;919;];
    nr_ids = [730;749;752;784;821;824;826;827;838;847;848;850;855;874;876;877;881;896;906;920;924;];
    max_features_count = 33;

    [input_root, inputs, output_root] = getPath(false);
    patients_count = size(inputs, 2);
    r_index = 1;
    nr_index = 1;
    R  = zeros(33, 33, 4, size(r_ids, 1));
    NR = zeros(33, 33, 4, size(nr_ids, 1));

    disp('Constructing R & NR...');
    for index = 1:patients_count
        patient_number = inputs(index);

        if isempty(strmatch(str2num(patient_number{1}), r_ids)) && isempty(strmatch(str2num(patient_number{1}), nr_ids))
            continue;
        end

        load(strcat(input_root, '\', patient_number, '.mat')); % load gpdc, ddtf, pcoh

        start = 1;
        [c1, c2, f, t] = size(M); % foreach gpdc, ddtf, pcoh as M
        M_TS = zeros(c1, c2, f, size(1:20:t, 2));
        for ts = 1:size(M_TS, 4)
            M_TS(:,:,:,ts) = median(M(:,:,:,start:start+20-1:end), 4);
            start = start + 20;
        end

        M_TS_M = mean(M_TS, 4);

        C = cat(...
            3, ...
            median(M_TS_M(:,:,1:3), 3), ...
            median(M_TS_M(:,:,4:7), 3), ...
            median(M_TS_M(:,:,8:13), 3), ...
            median(M_TS_M(:,:,14:end), 3) ...
        );

        if strmatch(patient_number, r_ids)
            disp(strcat(patient_number, ' is responder'));
            R(:,:,:,r_index) = C;
            r_index = r_index + 1;
        else
            disp(strcat(patient_number, ' is non-responder'));
            NR(:,:,:,nr_index) = C;
            nr_index = nr_index + 1;
        end
    end
    disp('Done');
    
    save(strcat(output_root, '\', measure, '_R_NR.mat'), 'R', 'NR');

    R_M = mean(R, 4);
    NR_M = mean(NR, 4);
    features = zeros(4, max_features_count);

    disp('Selecting features for each frequency...');
    for frequency = 1:4
        significance_level = 0.05;
        while significance_level < max_significance_level
            test_decision = ttest2(R_M(:,:,frequency), NR_M(:,:,frequency), 'Alpha', significance_level);
            features_count = size(find(test_decision == 1), 2);
            significance_level = significance_level + 0.001;
        end

        padd_size = max_features_count - size(find(test_decision == 1), 2);
        if padd_size > 0
            features(frequency, :) = padarray(find(test_decision == 1), [0 padd_size], 'post')';
        else
            features(frequency, :) = find(test_decision == 1, features_count);
        end
    end

    save(strcat(output_root, '\', measure, '_features.mat'), 'features');

    fprintf('max significance level: %f\n', significance_level);
end
