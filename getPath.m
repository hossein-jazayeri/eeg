function [input_root, inputs, output_root, standard_10_5, standard_10_10] = getPath(getBrainLocations)
    input_root = uigetdir('C:\Users\Hossein Jazayeri\Documents\MATLAB\', 'Select input directory');
    inputs = dir(input_root);
    inputs = {inputs([inputs.isdir]).name};
    inputs = inputs(~ismember(inputs,{'.','..'}));
    
    output_root = uigetdir('C:\Users\Hossein Jazayeri\Documents\MATLAB\', 'Select output directory');
    
    if getBrainLocations
        [standard_10_5_file_name, standard_10_5_path] = uigetfile('D:\Software\Matlab R2017a\eeglab13_6_5b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp', 'Select standard-10-5-cap385.elp file');
        standard_10_5 = strcat(standard_10_5_path, standard_10_5_file_name);
        [standard_10_10_file_name, standard_10_10_path] = uigetfile('D:\Software\Matlab R2017a\eeglab13_6_5b\sample_locs\Standard-10-10-Cap33.locs', 'Select Standard-10-10-Cap33.locs file');
        standard_10_10 = strcat(standard_10_10_path, standard_10_10_file_name);
    end
end