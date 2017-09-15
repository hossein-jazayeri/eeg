function [X, y] = doubleInputSizeExcludeDiagonal(Rs, NRs, Rs_dataset_size, NRs_dataset_size, NZ_channels_size)
    X = [];
    
    for i = 1:Rs_dataset_size
        Ri = Rs(:,:,1,i);
        right = [];
        left = [];
        for j = 1:NZ_channels_size
            right = [right Ri(j,j+1:end)];
            left = [left Ri(j,1:j-1)];
        end

        X = [X; right];
        X = [X; left];
    end

    for i = 1:NRs_dataset_size
        Ri = NRs(:,:,1,i);
        right = [];
        left = [];
        for j = 1:NZ_channels_size
            right = [right Ri(j,j+1:end)];
            left = [left Ri(j,1:j-1)];
        end

        X = [X; right];
        X = [X; right];
    end

    y = [ones(2 * Rs_dataset_size, 1);zeros(2 * NRs_dataset_size, 1)];
end
