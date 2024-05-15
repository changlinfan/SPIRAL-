function arrayOfBandwidths = getBandwidths(numOfUEsConnected, config)
    arrayOfBandwidths = zeros(size(numOfUEsConnected, 1), 1);
    for i = 1:size(arrayOfBandwidths, 1)
        arrayOfBandwidths(i, 1) = config("bandwidth") / numOfUEsConnected(i, 1); % 單一UE分配到的頻寬
    end
end