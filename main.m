clear; close all; clc;

d = dialog('Position', [300 300 250 220], 'WindowStyle', 'normal');
uicontrol('Parent', d, 'Position', [10 185 230 25], 'String', 'Pre process', 'Callback', 'preProcess');
uicontrol('Parent', d, 'Position', [10 150 230 25], 'String', 'Model fitting & extract connectivity', 'Callback', 'modelFit');
uicontrol('Parent', d, 'Position', [10 115 230 25], 'String', 'Zero padding', 'Callback', 'zeroPadding');
uicontrol('Parent', d, 'Position', [10 80 230 25], 'String', 'Select feature', 'Callback', 'selectFeature');
uicontrol('Parent', d, 'Position', [10 45 230 25], 'String', 'SVM', 'Callback', 'svm');
uicontrol('Parent', d, 'Position', [10 10 230 25], 'String', 'Close', 'Callback', 'delete(gcf)');

