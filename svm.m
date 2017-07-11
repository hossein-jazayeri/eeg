clear ; close all;

measure = input('What is the measure, gpdc, ddtf, or pcoh? ', 's');
all_channels = input('Use all channels y/n? [default:n] ', 's');
if isempty(all_channels)
    all_channels = 'n';
end

% load R & NR
load(strcat('C:\Users\Hossein Jazayeri\Documents\MATLAB\Data\', measure, '_R_NR.mat'));
R1 = permute(R, [4, 3, 1, 2]);
R2 = permute(R, [4, 3, 2, 1]);
R_M = mean(cat(5, R1, R2), 5); % patient,frequency,channel1,channel2
R_P = permute(R_M, [1, 3, 4, 2]);

NR1 = permute(NR, [4, 3, 1, 2]);
NR2 = permute(NR, [4, 3, 2, 1]);
NR_M = mean(cat(5, NR1, NR2), 5); % patient,frequency,channel1,channel2
NR_P = permute(NR_M, [1, 3, 4, 2]);

R_size = size(R_P, 1);NR_size = size(NR_P, 1);DS_size = R_size + NR_size;
R_train_size = floor(R_size * 0.7);NR_train_size = floor(NR_size * 0.7);

if strcmp(all_channels, 'y')
    channels(1,:) = linspace(1, size(R_P, 2), size(R_P, 2));
    channels(2,:) = linspace(1, size(R_P, 2), size(R_P, 2));
    channels(3,:) = linspace(1, size(R_P, 2), size(R_P, 2));
    channels(4,:) = linspace(1, size(R_P, 2), size(R_P, 2));
else
    if strcmp(measure, 'ddtf')
        channels(1,:) = [1 2 3 8 9 10 11 14 15 19 20 25 29 31 32 33 0]; % DELTA
        channels(2,:) = [1 2 3 8 9 10 14 15 19 20 25 31 32 33 0 0 0]; % THETA
        channels(3,:) = [1 2 3 8 10 11 19 20 25 31 32 33 0 0 0 0 0]; % ALPHA
        channels(4,:) = [1 2 3 4 7 8 12 13 16 17 18 21 22 24 26 28 33]; % BETA
    elseif strcmp(measure, 'pcoh')
        channels(1,:) = [1 2 3];
        channels(2,:) = [1 2 3];
        channels(3,:) = [1 2 3];
        channels(4,:) = [1 2 3];
    elseif strcmp(measure, 'gpdc')
        channels(1,:) = [1 2 3];
        channels(2,:) = [1 2 3];
        channels(3,:) = [1 2 3];
        channels(4,:) = [1 2 3];
    end
end

for frequency = 1:4
    nonzero_channels = nonzeros(channels(frequency,:))';
    Rs = R_P(:, nonzero_channels, nonzero_channels, frequency);
    NRs = NR_P(:, nonzero_channels, nonzero_channels, frequency);
    % remove bellow diagonal elements from Rs & NRs ...

    nonzero_channels_size = size(nonzero_channels, 2);
    X = zeros(R_train_size + NR_train_size, nonzero_channels_size * nonzero_channels_size);
    X_test = zeros(R_size + NR_size - R_train_size - NR_train_size, nonzero_channels_size * nonzero_channels_size);

    for i = 1:R_size
        if i <= R_train_size
            X(i,:) = Rs(i,:);
        else
            X_test(i - R_train_size,:) = Rs(i,:);
        end
    end
    for i = 1:NR_size
        if i <= NR_train_size
            X(R_train_size + i,:) = NRs(i,:);
        else
            X_test(i + R_size - R_train_size - NR_train_size,:) = NRs(i,:);
        end
    end

    y = [ones(1, R_train_size) zeros(1, NR_train_size)]';
    y_test = [ones(1, R_size - R_train_size) zeros(1, NR_size - NR_train_size)]';

    model = fitcsvm(X, y, 'Standardize', true);
    fprintf('Accuracy of frequency %d train: %f, test: %f\n', frequency, ...
        mean(double(predict(model, X) == y)) * 100, ...
        mean(double(predict(model, X_test) == y_test)) * 100);
end
