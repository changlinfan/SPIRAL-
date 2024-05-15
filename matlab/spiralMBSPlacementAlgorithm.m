function [UAVBSsSet, UEsPositionOfUAVBSIncluded] = spiralMBSPlacementAlgorithm(locationOfUEs, r_UAVBS)
    % locationOfUEs: 所有UE的位置 []
    % r_UAVBS: 無人機的涵蓋範圍半徑
    % UAVBSsSet: 所有無人機的位置 []
    % angle: 旋轉排序的起始角度(0~360deg)

    % Initialization
    angle = 90; % 旋轉排序的起始角度(0~360deg)
    uncoveredUEsSet = locationOfUEs;
    UAVBSsSet = [];
    centerUE = [];
    UEsPositionOfUAVBSIncluded = {};

    % 演算法第1行
    [uncoveredBoundaryUEsSet, angle] = findBoundaryUEsSet(true, uncoveredUEsSet, angle); % 找出邊緣並以逆時針排序
    while ~isempty(uncoveredUEsSet)
        % 演算法第2行
        uncoveredInnerUEsSet = setdiff(uncoveredUEsSet, uncoveredBoundaryUEsSet, 'rows');
        centerUE = uncoveredBoundaryUEsSet(1, :);

        % 演算法第3行
        % 涵蓋邊緣點
        [firstLocalCoverU, firstLocalCoverPprio] = localCover(r_UAVBS, centerUE, centerUE, setdiff(uncoveredBoundaryUEsSet, centerUE, 'rows'));

        % 演算法第4行
        % 涵蓋內點
        [secondLocalCoverU, secondLocalCoverPprio] = localCover(r_UAVBS, firstLocalCoverU, firstLocalCoverPprio, uncoveredInnerUEsSet);
        
        % 演算法第5行
        % 更新結果
        UAVBSsSet(size(UAVBSsSet, 1) + 1, :) = secondLocalCoverU;
        uncoveredUEsSet = setdiff(uncoveredUEsSet, secondLocalCoverPprio, 'rows');

        % 演算第6行
        % 以不更改排序的情況下移除未覆蓋邊緣集合裡已覆蓋的邊緣點
        uncoveredBoundaryUEsSet(ismember(uncoveredBoundaryUEsSet, secondLocalCoverPprio, 'rows'), :) = [];
        UEsPositionOfUAVBSIncluded{1, size(UEsPositionOfUAVBSIncluded, 2) + 1} = secondLocalCoverPprio;
        if isempty(uncoveredBoundaryUEsSet)
            [uncoveredBoundaryUEsSet, angle] = findBoundaryUEsSet(true, uncoveredUEsSet, angle);
        end
    end
end