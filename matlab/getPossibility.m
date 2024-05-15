function possibility = getPossibility(UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, config)
    % possibility: LoS及NLoS機率 {[Los,NLos;...],[Los,NLos;...],...}
    % config.a: 環境變數
    % config.b: 環境變數

    possibility = cell(size(UAVBSsSet(:,1),1));
    for i=1:size(UAVBSsSet(:,1),1) % UAV個數
        possibility{i} = zeros(size(UEsPositionOfUAVBSIncluded{i},1),2); % LoS及NLoS機率
        UAVBSsHeight = getHeightByArea(UAVBSsR(i,1), config); % UAVBS無人機的高度
        % 算式(2)
        UAVandUEsHorDist = pdist2(UAVBSsSet(i,:), UEsPositionOfUAVBSIncluded{i}); % 該UAV到UE的距離 [d1 d2 d3...;]
        for j=1:size(UAVandUEsHorDist,2)
            % 算式(1)
            possibility{i}(j,1) = 1 / (1 + config("a") * exp(-config("b") * (180 * atan(UAVBSsHeight / UAVandUEsHorDist(j)) / pi - config("a"))));
            possibility{i}(j,2) = 1 - possibility{i}(j,1);
        end
    end
end