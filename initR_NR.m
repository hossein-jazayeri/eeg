function [GPDC_R, GPDC_NR, DDTF_R, DDTF_NR, PCOH_R, PCOH_NR, GGC_R, GGC_NR, DTF_R, DTF_NR, ICOH_R, ICOH_NR] = ...
    initR_NR(r_size, nr_size, metrics)
    R = zeros(33, 33, 4, r_size);
    NR = zeros(33, 33, 4, nr_size);
    if strncmp(metrics, 'all', 3)
        GPDC_R = R;
        GPDC_NR = NR;

        DDTF_R = R;
        DDTF_NR = NR;

        PCOH_R = R;
        PCOH_NR = NR;

        DTF_R = R;
        DTF_NR = NR;

        GGC_R = R;
        GGC_NR = NR;

        ICOH_R = R;
        ICOH_NR = NR;
    end
end
