function zeroPadding()
    rejected_channels = [
        1 2 14 20 25 28 0 0 0 0 0 0 0 0;
        1 2 5 8 14 19 23 25 28 0 0 0 0 0;
        1 2 5 8 13 14 20 24 25 28 30 31 33 0;
        1 2 9 14 19 24 26 28 0 0 0 0 0 0;
        1 2 9 10 14 19 28 0 0 0 0 0 0 0;
        1 2 5 8 14 20 24 28 0 0 0 0 0 0;
        1 2 4 8 10 13 14 18 20 24 28 0 0 0;
        1 2 9 14 19 24 28 0 0 0 0 0 0 0;
        1 2 9 14 19 24 25 28 33 0 0 0 0 0;
        1 2 10 14 19 28 0 0 0 0 0 0 0 0;
        1 2 5 9 14 19 20 25 28 29 30 31 32 33;
        1 2 12 14 20 24 28 0 0 0 0 0 0 0;
        1 2 3 10 14 20 24 28 0 0 0 0 0 0;
        1 2 8 10 12 13 14 15 20 26 0 0 0 0;
        1 2 4 8 10 13 15 20 25 26 0 0 0 0;
        1 2 9 14 19 28 33 0 0 0 0 0 0 0;
        1 2 5 10 14 23 25 28 0 0 0 0 0 0;
        1 2 14 19 23 25 28 0 0 0 0 0 0 0;
        1 2 19 20 25 26 0 0 0 0 0 0 0 0;
        1 2 19 20 25 26 0 0 0 0 0 0 0 0;
        1 2 9 10 14 19 26 28 0 0 0 0 0 0;
        1 2 9 10 14 19 24 28 0 0 0 0 0 0;
        1 2 14 19 24 28 0 0 0 0 0 0 0 0;
        1 2 9 10 14 19 28 0 0 0 0 0 0 0;
        1 2 9 10 14 24 0 0 0 0 0 0 0 0;
        1 2 8 10 13 15 19 24 0 0 0 0 0 0;
        1 2 5 6 9 10 14 19 0 0 0 0 0 0;
        1 2 14 19 24 28 0 0 0 0 0 0 0 0;
        1 2 5 9 10 14 19 24 28 0 0 0 0 0;
        1 2 14 19 24 0 0 0 0 0 0 0 0 0;
        1 2 5 9 10 14 19 24 28 0 0 0 0 0;
        1 2 5 10 14 15 19 24 28 0 0 0 0 0;
        1 2 9 14 19 24 28 0 0 0 0 0 0 0;
        1 2 9 14 20 28 0 0 0 0 0 0 0 0;
        1 2 5 9 10 14 19 26 28 0 0 0 0 0;
        1 2 14 19 24 28 0 0 0 0 0 0 0 0;
        1 2 14 19 20 24 28 0 0 0 0 0 0 0;
        1 2 9 10 14 19 24 28 0 0 0 0 0 0;
        1 2 14 25 0 0 0 0 0 0 0 0 0 0;
        1 2 5 10 14 25 28 0 0 0 0 0 0 0;
        1 2 14 19 24 28 0 0 0 0 0 0 0 0;
        1 2 10 14 19 24 28 0 0 0 0 0 0 0;
        1 2 5 14 19 20 23 25 28 0 0 0 0 0;
        1 2 9 10 14 19 24 26 28 0 0 0 0 0;
        1 2 9 10 14 19 24 28 33 0 0 0 0 0;
    ];

    [input_root, inputs, output_root] = getPath(false, 'file', true); % get CONN root
    input_size = size(inputs, 2);
    for index = 1:input_size
        filename = inputs(index);
        fprintf('zero padding %s', filename{1});
        path = strcat(input_root, '\', filename);
        load(path{1}); % load gpdc, ddtf, pcoh
        
        rc = rejected_channels(index,:);
        rc_count = size(find(rc), 2);
        for rc_index = 1:rc_count
            rc_value = rc(rc_index);

            gpdc = padarray(gpdc, [1 1], 'pre');
            gpdc([1 rc_value],:) = gpdc([rc_value 1],:);
            gpdc(:,[1 rc_value]) = gpdc(:,[rc_value 1]);

            ddtf = padarray(ddtf, [1 1], 'pre');
            ddtf([1 rc_value],:) = ddtf([rc_value 1],:);
            ddtf(:,[1 rc_value]) = ddtf(:,[rc_value 1]);

            pcoh = padarray(pcoh, [1 1], 'pre');
            pcoh([1 rc_value],:) = pcoh([rc_value 1],:);
            pcoh(:,[1 rc_value]) = pcoh(:,[rc_value 1]);
        end

        path = strcat(output_root, '\', filename);
        save(path{1}, 'gpdc', 'ddtf', 'pcoh');
		fprintf(' Done\n');
    end
end
