function averagePathLoss = getAveragePathLoss(UAVBSsSet, UEsPositionOfUAVBSIncluded, possibility, UAVBSsR, config)
    % 此算式參照 The Coverage Overlapping Problem of Serving Arbitrary Crowds in 3D Drone Cellular Networks
    
    % config.frequency: 行動通訊的載波頻寬(Hz)
    % config.constant: 光的移動速率(m/s)
    % config.etaLos: Los的平均訊號損失
    % config.etaNLos: NLos的平均訊號損失

    averagePathLoss = cell(size(UAVBSsSet, 1));

    for UAVBSsIndex = 1:size(UAVBSsSet, 1)
        UAVBSsHeight = getHeightByArea(UAVBSsR(UAVBSsIndex, 1),  config);

        UAVandUEsHorDist = pdist2(UAVBSsSet(UAVBSsIndex, :), UEsPositionOfUAVBSIncluded{UAVBSsIndex}); % UAV及UE的平面歐幾里得距離
        UAVandUEsDist = sqrt(UAVandUEsHorDist.^2 + UAVBSsHeight^2); % UAV及UE的歐幾里得距離

        % 算式(5)
        Los = 20 * log10(4 * pi * config("frequency") * UAVandUEsDist./config("constant")) + config("etaLos");
        NLoS = 20 * log10(4 * pi * config("frequency") * UAVandUEsDist./config("constant")) + config("etaNLos");
        
        % 算式(6)
        averagePathLoss{UAVBSsIndex} = possibility{UAVBSsIndex}(:, 1).*(Los.') + possibility{UAVBSsIndex}(:, 2).*(NLoS.');
    end
end