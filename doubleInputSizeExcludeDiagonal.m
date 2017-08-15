function [X, y, X_test, y_test] = doubleInputSizeExcludeDiagonal(Rs, NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, train_ratio)
    X = [];
    X_test = [];
    R_train_size = floor(Rs_dataset_size * train_ratio);
    NR_train_size = floor(NRs_dataset_size * train_ratio);

    for i = 1:Rs_dataset_size
        Ri = Rs(:,:,1,i);
        right = [];
        left = [];
        for j = 1:NZ_channels_size
            right = [right Ri(j,j+1:end)];
            left = [left Ri(j,1:j-1)];
        end

        if i <= R_train_size
            X = [X; right];
            X = [X; left];
        else
            X_test = [X_test; right];
            X_test = [X_test; left];
        end
    end

    for i = 1:NRs_dataset_size
        Ri = NRs(:,:,1,i);
        right = [];
        left = [];
        for j = 1:NZ_channels_size
            right = [right Ri(j,j+1:end)];
            left = [left Ri(j,1:j-1)];
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
    y_test = [ones(1, 2 * (Rs_dataset_size - R_train_size)) zeros(1, 2 * (NRs_dataset_size - NR_train_size))]';
end
