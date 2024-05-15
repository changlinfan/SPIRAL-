function [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = randomAlgorithm(locationOfUEs, rangeOfPosition, config)
    % config.minR: 法定最低半徑
    % config.maxR: 法定最高半徑
    % locationOfUEs: 所有UE的位置 []
    % UAVBSsSet: 所有無人機的位置 []
    % UEsPositionOfUAVServedBy: 所有無人機連線到的UE {[;;...],[;;...],...}
    % UAVBSsR: 所有無人機的半徑 [;;...]

    % Initialization
    UAVBSsSet = [];
    UAVBSsR = [];
    UEsPositionOfUAVServedBy = {};
    centerUE = [];
    uncoveredUEsSet = locationOfUEs;

    while ~isempty(uncoveredUEsSet)
        r = rand(1, 1) * (config("maxR") - config("minR")) + config("minR"); % 產生無人機半徑
        index = randi([1 size(uncoveredUEsSet, 1)], 1, 1); % 隨機選擇一個UE當中心點
        offset = rand(1, 2) * (2 * r) - r; % 產生無人機位置的offset
        newPositionOfUAVBS = uncoveredUEsSet(index, :) + offset; % 產生無人機位置

        % 更新結果
        distances = pdist2(uncoveredUEsSet, newPositionOfUAVBS);
        indexes = find(distances(:, 1) <= r);
        UAVBSsSet(size(UAVBSsSet, 1) + 1, :) = newPositionOfUAVBS;
        UAVBSsR(size(UAVBSsR, 1) + 1, 1) = r;
        UEsPositionOfUAVServedBy{1, size(UEsPositionOfUAVServedBy, 2) + 1} = uncoveredUEsSet(indexes, :);
        uncoveredUEsSet(indexes, :) = [];
    end
end