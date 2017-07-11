clear ; close all; clc

root_folder = 'D:\ProjectData\';
patients = dir(root_folder);
patients = {patients([patients.isdir]).name};
patients = patients(~ismember(patients,{'.','..'}));
c = size(patients, 2);

rejected_channels = zeros(c, 3);
rejected_channels(1,:)  = [1 5 0];
rejected_channels(2,:)  = [2 13 0];
rejected_channels(3,:)  = [1 10 0];
rejected_channels(4,:)  = [1 2 15];
rejected_channels(5,:)  = [1 2 0];
rejected_channels(6,:)  = [1 5 20];
rejected_channels(7,:)  = [1 0 0];
rejected_channels(8,:)  = [1 2 20];
rejected_channels(9,:)  = [12 0 0];
rejected_channels(10,:) = [1 4 5];
rejected_channels(11,:) = [1 2 5];
rejected_channels(12,:) = [17 0 0];
rejected_channels(13,:) = [1 0 0];
rejected_channels(14,:) = [1 30 0];
rejected_channels(15,:) = [1 8 13];
rejected_channels(16,:) = [1 2 14];
rejected_channels(17,:) = [1 2 0];
rejected_channels(18,:) = [1 5 0];
rejected_channels(19,:) = [1 2 0];
rejected_channels(20,:) = [1 19 20];
rejected_channels(21,:) = [19 33 0];
rejected_channels(22,:) = [1 2 0];
rejected_channels(23,:) = [1 2 0];
rejected_channels(24,:) = [1 2 0];
rejected_channels(25,:) = [1 29 0];
rejected_channels(26,:) = [1 2 12];
rejected_channels(27,:) = [2 0 0];
rejected_channels(28,:) = [1 0 0];
rejected_channels(29,:) = [2 20 0];
rejected_channels(30,:) = [1 12 0];
rejected_channels(31,:) = [1 2 19];
rejected_channels(32,:) = [1 2 0];
rejected_channels(33,:) = [1 2 0];
rejected_channels(34,:) = [1 2 0];
rejected_channels(35,:) = [1 30 33];
rejected_channels(36,:) = [1 2 0];
rejected_channels(37,:) = [1 2 9];
rejected_channels(38,:) = [2 0 0];
rejected_channels(39,:) = [1 0 0];
rejected_channels(40,:) = [12 13 29];
rejected_channels(41,:) = [0 0 0];
rejected_channels(42,:) = [1 26 0];
rejected_channels(43,:) = [1 0 0];
rejected_channels(44,:) = [0 0 0];
rejected_channels(45,:) = [0 0 0];

for index = 1:c
    patient_number = patients(index);
    path = strcat(root_folder, patient_number, '\');
    
    fprintf('Proccessing patient number %s\n', patient_number{1});
    
    r = load(strcat(path{1}, 'gpdc.mat'));
    gpdc = r.gpdc;
    disp('GPDC loaded');
    
    r = load(strcat(path{1}, 'ddtf.mat'));
    ddtf = r.ddtf;
    disp('dDTF loaded');
    
    r = load(strcat(path{1}, 'pcoh.mat'));
    pcoh = r.pcoh;
    disp('pCoh loaded');

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
    disp('Uniformed');
    
    save(strcat(path{1}, 'gpdc_uniformed.mat'), 'gpdc');
    save(strcat(path{1}, 'ddtf_uniformed.mat'), 'ddtf');
    save(strcat(path{1}, 'pcoh_uniformed.mat'), 'pcoh');
    disp('Stored');
end