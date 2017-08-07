clear all;close all;
load('C:\Users\Hossein Jazayeri\Documents\MATLAB\eeg\data\FEATURES.mat');
load('C:\Users\Hossein Jazayeri\Documents\MATLAB\eeg\data\R_NR.mat');



Xy1 = DDTF_Xy{1};Xy2 = DDTF_Xy{2};Xy3 = DDTF_Xy{3};Xy4 = DDTF_Xy{4};
%mean(double(trainedModel.predictFcn(DDTF_X_test{2}) == DDTF_y_test{2}) * 100)