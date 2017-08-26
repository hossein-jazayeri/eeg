function zeroPadding()
    rejected_channels{727} = [1 2 14 20 25 28];
    rejected_channels{729} = [1 2 5 8 14 19 23 25 28];
    rejected_channels{730} = [1 2 5 8 13 14 20 24 25 28 30 31 33];
    rejected_channels{731} = [1 2 9 14 19 24 26 28];
    rejected_channels{732} = [1 2 9 10 14 19 28];
    rejected_channels{749} = [1 2 5 8 14 20 24 28];
    rejected_channels{752} = [1 2 4 8 10 13 14 18 20 24 28];
    rejected_channels{766} = [1 2 9 14 19 24 28];
    rejected_channels{784} = [1 2 9 14 19 24 25 28 33];
    rejected_channels{790} = [1 2 10 14 19 28];
    rejected_channels{792} = [1 2 5 9 14 19 20 25 28 29 30 31 32 33];
    rejected_channels{802} = [1 2 12 14 20 24 28];
    rejected_channels{811} = [1 2 3 10 14 20 24 28];
    rejected_channels{812} = [1 2 8 10 12 13 14 15 20 26];
    rejected_channels{814} = [1 2 4 8 10 13 15 20 25 26];
    rejected_channels{821} = [1 2 9 14 19 28 33];
    rejected_channels{823} = [1 2 5 10 14 23 25 28];
    rejected_channels{824} = [1 2 14 19 23 25 28];
    rejected_channels{826} = [1 2 19 20 25 26];
    rejected_channels{827} = [1 2 19 20 25 26];
    rejected_channels{828} = [1 2 9 10 14 19 26 28];
    rejected_channels{830} = [1 2 9 10 14 19 24 28];
    rejected_channels{838} = [1 2 14 19 24 28];
    rejected_channels{839} = [1 2 9 10 14 19 28];
    rejected_channels{843} = [1 2 9 10 14 24];
    rejected_channels{847} = [1 2 8 10 13 15 19 24];
    rejected_channels{848} = [1 2 5 6 9 10 14 19];
    rejected_channels{850} = [1 2 14 19 24 28];
    rejected_channels{855} = [1 2 5 9 10 14 19 24 28];
    rejected_channels{856} = [1 2 14 19 24];
    rejected_channels{870} = [1 2 5 9 10 14 19 24 28];
    rejected_channels{874} = [1 2 5 10 14 15 19 24 28];
    rejected_channels{876} = [1 2 9 14 19 24 28];
    rejected_channels{877} = [1 2 9 14 20 28];
    rejected_channels{879} = [1 2 5 9 10 14 19 26 28];
    rejected_channels{881} = [1 2 14 19 24 28];
    rejected_channels{896} = [1 2 14 19 20 24 28];
    rejected_channels{905} = [1 2 9 10 14 19 24 28];
    rejected_channels{906} = [1 2 14 25];
    rejected_channels{911} = [1 2 5 10 14 25 28];
    rejected_channels{913} = [1 2 14 19 24 28];
    rejected_channels{915} = [1 2 10 14 19 24 28];
    rejected_channels{919} = [1 2 5 14 19 20 23 25 28];
    rejected_channels{920} = [1 2 9 10 14 19 24 26 28];
    rejected_channels{924} = [1 2 9 10 14 19 24 28 33];

    [input_root, inputs, output_root] = getPath(false, 'file', true); % get CONN root
    input_size = size(inputs, 2);
    for index = 1:input_size
        filename = inputs(index);
        fprintf('zero padding %s ...', filename{1});
        path = strcat(input_root, '\', filename);
        load(path{1}); % load gpdc, ddtf, pcoh
        
        
        rc = rejected_channels{str2double(filename{1}(1:3))};
        rc_count = size(rc, 2);
        for rc_index = 1:rc_count
            channel_number = rc(rc_index);

            gpdc = zeroPadMetric(gpdc, channel_number);
            ddtf = zeroPadMetric(ddtf, channel_number);
            pcoh = zeroPadMetric(pcoh, channel_number);
            dtf = zeroPadMetric(dtf, channel_number);
            ggc = zeroPadMetric(ggc, channel_number);
            icoh = zeroPadMetric(icoh, channel_number);
        end

        path = strcat(output_root, '\', filename);
        save(path{1}, 'gpdc', 'ddtf', 'pcoh', 'dtf', 'ggc', 'icoh');
		fprintf(' Done\n');
    end
end
