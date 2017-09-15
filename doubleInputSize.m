function [X, y] = doubleInputSize(Rs, NRs, R_dataset_size, NR_dataset_size, nonzero_channels_size)
    X = [];

    for i = 1:R_dataset_size
        Ri = Rs(:,:,1,i);
        right = [];
        left = [];
        for j = 1:nonzero_channels_size
            right = [right Ri(j,j:end)];
            left = [left Ri(j,1:j)];
        end

        X = [X; right];
        X = [X; left];
    end

    for i = 1:NR_dataset_size
        Ri = NRs(:,:,1,i);
        right = [];
        left = [];
        for j = 1:nonzero_channels_size
            right = [right Ri(j,j:end)];
            left = [left Ri(j,1:j)];
        end

        X = [X; right];
        X = [X; right];
    end

    y = [ones(2 * R_dataset_size, 1);zeros(2 * NR_dataset_size, 1)];
end
