function [X, y] = correspondingsMeanExcludeDiagonal(Rs, NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size)
    X = [];
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
        X = [X; Xi];
    end

    for i = 1:NRs_dataset_size
        Ri = NR_P(:,:,1,i);
        Xi = [];
        for j = 1:NZ_channels_size
            Xi = [Xi Ri(j,j+1:end)];
        end
        X = [X; Xi];
    end

    y = [ones(Rs_dataset_size, 1);zeros(NRs_dataset_size, 1)];
end
