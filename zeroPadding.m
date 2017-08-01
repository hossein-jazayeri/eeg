function zeroPadding()
    rejected_channels  = [
        1 5 0;
        2 13 0;
        1 10 0;
        1 2 15;
        1 2 0;
        1 5 20;
        1 0 0;
        1 2 20;
        12 0 0;
        1 4 5;
        1 2 5;
        17 0 0;
        1 0 0;
        1 30 0;
        1 8 13;
        1 2 14;
        1 2 0;
        1 5 0;
        1 2 0;
        1 19 20;
        19 33 0;
        1 2 0;
        1 2 0;
        1 2 0;
        1 29 0;
        1 2 12;
        2 0 0;
        1 0 0;
        2 20 0;
        1 12 0;
        1 2 19;
        1 2 0;
        1 2 0;
        1 2 0;
        1 30 33;
        1 2 0;
        1 2 9;
        2 0 0;
        1 0 0;
        12 13 29;
        0 0 0;
        1 26 0;
        1 0 0;
        0 0 0;
        0 0 0;
    ];

    [input_root, inputs, output_root] = getPath(false);
    input_size = size(inputs, 2);
    for index = 1:input_size
        patient_number = inputs(index);
        load(strcat(input_root, '\', patient_number, '.mat')); % load gpdc, ddtf, pcoh
        
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

        save(strcat(output_root, '\', patient_number, '.mat'), 'gpdc', 'ddtf', 'pcoh');
    end
end
