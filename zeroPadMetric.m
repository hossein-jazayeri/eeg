function metric = zeroPadMetric(metric, channel_number)
    metric = padarray(metric, [1 1], 'pre');
    metric([1 channel_number],:) = metric([channel_number 1],:);
    metric(:,[1 channel_number]) = metric(:,[channel_number 1]);
end