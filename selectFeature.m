function selectFeature()
    measures = {'gpdc', 'ddtf', 'pcoh', 'ggc', 'dtf', 'icoh'};
    r_ids = [727;729;731;732;766;790;792;802;811;812;814;823;828;830;839;843;856;870;879;905;911;913;915;919;];
    nr_ids = [730;749;752;784;821;824;826;827;838;847;848;850;855;874;876;877;881;896;906;920;924;];

    [input_root, inputs, output_root] = getPath(false, 'file', true); % LOAD ZERO PADDED DATA
    patients_count = size(inputs, 2);

    fprintf('Time & frequency aggregation...');
    C = containers.Map;
    for index = 1:patients_count
        filename = inputs(index);
        patient_number = str2double(filename{1}(1:3));

        if isempty(strncmp(patient_number, r_ids, 3)) && isempty(strncmp(patient_number, nr_ids, 3))
            continue;
        end

        path = strcat(input_root, '\', filename);
        fprintf(strcat('-', num2str(patient_number)));
        S = load(path{1}); % load gpdc, ddtf, pcoh, dtf, ggc, icoh
        for measure = measures
            C(strcat(num2str(index), measure{1})) = timeFrequencyAggregation(S.(measure{1}));%for each meseure and for each patient
        end
    end
    fprintf('\nDone.');
    fprintf('\nConstructing R & NR...');
    Rs = containers.Map;
    NRs = containers.Map;
    for measure = measures
        fprintf(strcat('\n', measure{1}, ':'));
        r_index = 1;
        nr_index = 1;
        R = zeros(33, 33, 4, size(r_ids, 1));
        NR = zeros(33, 33, 4, size(nr_ids, 1));
        for index = 1:patients_count
            filename = inputs(index);
            patient_number = str2double(filename{1}(1:3));
            if strmatch(patient_number, r_ids)
                fprintf(strcat(num2str(patient_number), ':R-'));
                R(:,:,:,r_index) = C(strcat(num2str(index), measure{1}));
                r_index = r_index + 1;
            else
                fprintf(strcat(num2str(patient_number), ':NR - '));
                NR(:,:,:,r_index) = C(strcat(num2str(index), measure{1}));
                nr_index = nr_index + 1;
            end
        end
        Rs(measure{1}) = R;
        NRs(measure{1}) = NR;
    end
    fprintf('\nDone.');

    save(strcat(output_root, '\Rs_NRs.mat'), 'Rs', 'NRs');
    FEATURES = containers.Map;
    for measure = measures
        R_M = mean(Rs(measure{1}), 4);
        NR_M = mean(NRs(measure{1}), 4);

        fprintf('\nSelecting significant channels on each frequency for "%s"\n', measure{1});
        selected_channels = nan;
        for frequency = 1:4
            significance_level = 0.05;
            h = [];
            while size(find(h == 1), 2) < 3
                h = ttest2(R_M(:,:,frequency), NR_M(:,:,frequency), 'Alpha', significance_level);
                significance_level = significance_level + 0.001;
            end
            fprintf('max significance level: %f\n', significance_level);
            selected_channels{frequency} = find(h == 1);
        end
        FEATURES(measure{1}) = selected_channels;
        disp('Done.');
    end
    save(strcat(output_root, '\FEATURES.mat'), 'FEATURES');
end
