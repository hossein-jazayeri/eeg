function [X, y, X_test, y_test] = correspondingsMeanExcludeDiagonal(Rs, NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size, train_ratio)
    X = [];
    X_test = [];
    R_train_size = floor(Rs_dataset_size * train_ratio);
    NR_train_size = floor(NRs_dataset_size * train_ratio);

    R_M = mean(cat(5, permute(Rs, [4, 3, 1, 2]), permute(Rs, [4, 3, 2, 1])), 5); % patient,frequency,channel,channel
    NR_M = mean(cat(5, permute(NRs, [4, 3, 1, 2]), permute(NRs, [4, 3, 2, 1])), 5); % patient,frequency,channel,channel
    R_P = permute(R_M, [3 4 2 1]); % channel,channel,frequency,patient
    NR_P = permute(NR_M, [3 4 2 1]); % channel,channel,frequency,patient

    for i = 1:Rs_dataset_size
        Ri = R_P(:,:,1,i);
        Xi = [];
        for j = 1:NZ_channels_size
            Xi = [Xi Ri(j,j+1:end)];
        end
        if i <= R_train_size
            X = [X; Xi];
        else
            X_test = [X_test; Xi];
        end
    end
    for i = 1:NRs_dataset_size
        Ri = NR_P(:,:,1,i);
        Xi = [];
        for j = 1:NZ_channels_size
            Xi = [Xi Ri(j,j+1:end)];
        end
        if i <= NR_train_size
            X = [X; Xi];
        else
            X_test = [X_test; Xi];
        end
    end

    y = [ones(1, R_train_size) zeros(1, NR_train_size)]';
    y_test = [ones(1, Rs_dataset_size - R_train_size) zeros(1, NRs_dataset_size - NR_train_size)]';
end
