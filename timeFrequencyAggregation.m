function C = timeFrequencyAggregation(measure)
	chunk = 1;
    step_size = 67;
	[c1, c2, f, t] = size(measure);
	measure_time_segments = zeros(c1, c2, f, size(1:step_size:t, 2));
	for ts = 1:size(measure_time_segments, 4)
		measure_time_segments(:,:,:,ts) = median(measure(:,:,:,chunk:chunk+step_size-1:end), 4);
		chunk = chunk + step_size;
	end

	measure_time_segments_mean = mean(measure_time_segments, 4);

	C = cat(...
		3, ...
		mean(measure_time_segments_mean(:,:,1:3), 3), ...
		mean(measure_time_segments_mean(:,:,4:7), 3), ...
		mean(measure_time_segments_mean(:,:,8:13), 3), ...
		mean(measure_time_segments_mean(:,:,14:end), 3) ...
	);
end
