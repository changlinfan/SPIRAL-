function [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = voronoiAlgorithm(locationOfUEs, r_UAVBS, config)
    % locationOfUEs: 所有UE的位置 []
    % UAVBSsSet: 所有無人機的位置 []
    % UEsPositionOfUAVServedBy: 所有無人機連線到的UE {[;;...],[;;...],...}
    % UAVBSsR: 所有無人機的半徑 [;;...]

    % Initialization
    UEsPositionOfUAVServedBy = {};
    UAVBSsSet = [];

    % 凸包上選擇最多5個UE作為初始無人機位置
    [boundaryUEsSet, ~] = findBoundaryUEsSet(true, locationOfUEs, 0);
    uncoveredUEsSet = locationOfUEs;
    for i = 1:min(size(boundaryUEsSet, 1), 5)
        newUAVBSLocation = boundaryUEsSet(randi(size(boundaryUEsSet, 1)), :);
        UAVBSsSet = [UAVBSsSet; newUAVBSLocation];
        distances = pdist2(uncoveredUEsSet, newUAVBSLocation);
        indexes = find(distances(:, 1) <= r_UAVBS);
        UEsPositionOfUAVServedBy{1, i} = uncoveredUEsSet(indexes, :);
        uncoveredUEsSet = setdiff(uncoveredUEsSet, UEsPositionOfUAVServedBy{1, i}, 'rows');
        boundaryUEsSet = setdiff(boundaryUEsSet, UEsPositionOfUAVServedBy{1, i}, 'rows');
        if i > size(boundaryUEsSet, 1)
            break;
        end
    end

    while 1
        if size(uncoveredUEsSet, 1) == 0
            UAVBSsR = (zeros(size(UAVBSsSet, 1), 1) + 1) * r_UAVBS;
            return;
        end

        % 選擇覆蓋最多UE的無人機作為新的無人機位置
        newCoveredUEsNumber = 0;
        newUAVBSLocation = [0 0];
        newServeUEs = [];

        % 執行voronoi
        [vx, vy] = voronoi(UAVBSsSet(:, 1), UAVBSsSet(:, 2));

        % 找出覆蓋最多UE的無人機
        for i = 1:size(vx, 2)
            distances = pdist2(uncoveredUEsSet, [vx(1, i), vy(1, i)]);
            indexes = find(distances(:, 1) <= r_UAVBS);
            if size(indexes, 1) > newCoveredUEsNumber
                newCoveredUEsNumber = size(indexes, 1);
                newUAVBSLocation = [vx(1, i), vy(1, i)];
                newServeUEs = uncoveredUEsSet(indexes, :);
            end
        end

        % 如果沒有覆蓋到任何UE，則隨機選擇一個UE作為新的無人機位置
        if newCoveredUEsNumber == 0
            randomIndex = randi([1 size(uncoveredUEsSet, 1)], 1, 1);
            newUAVBSLocation = uncoveredUEsSet(randomIndex, :);
            distances = pdist2(uncoveredUEsSet, newUAVBSLocation);
            indexes = find(distances(:, 1) <= r_UAVBS);
            newServeUEs = uncoveredUEsSet(indexes, :);
        end

        % 更新資訊
        UAVBSsSet = [UAVBSsSet; newUAVBSLocation];
        UEsPositionOfUAVServedBy{1, size(UEsPositionOfUAVServedBy, 2) + 1} = newServeUEs;
        uncoveredUEsSet = setdiff(uncoveredUEsSet, newServeUEs, 'rows');
    end
    
end