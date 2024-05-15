function [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = ourAlgorithm(locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config)
    % config.minHeight: 法定最低高度
    % config.maxHeight: 法定最高高度
    % maxNumOfUE: 無人機符合滿意度之下，能服務的最大UE數量
    % locationOfUEs: 所有UE的位置 []
    % UAVBSsSet: 所有無人機的位置 []
    % UEsPositionOfUAVServedBy: 所有無人機連線到的UE {[;;...],[;;...],...}
    % UAVBSsR: 所有無人機的半徑 [;;...]

    maxNumOfUE = (maxDataTransferRateOfUAVBS/minDataTransferRateOfUEAcceptable); % 無人機符合滿意度之下，能服務的最大UE數量
    

    angle = 90; % 旋轉排序的起始角度(0~360deg)

    % Initialization
    uncoveredUEsSet = locationOfUEs;
    UAVBSsSet = [];
    UAVBSsR = [];
    centerUE = [];
    UEsPositionOfUAVServedBy = {};
    isUEsCovered = false(size(locationOfUEs,1), 1);

    % 演算法第1行
    [uncoveredBoundaryUEsSet, angle] = findBoundaryUEsSet(false, uncoveredUEsSet, angle); % 找出邊緣並以逆時針排序
    while ~isempty(uncoveredBoundaryUEsSet)
        % 演算法第2行
        % uncoveredInnerUEsSet = setdiff(uncoveredUEsSet, uncoveredBoundaryUEsSet, 'rows');
        centerUE = uncoveredBoundaryUEsSet(1, :);

        % 涵蓋
        [newPositionOfUAVBS, newUEsSet, r] = ourLocalCover(centerUE, centerUE, setdiff(uncoveredUEsSet, centerUE, 'rows'), locationOfUEs, isUEsCovered, maxNumOfUE, config);

        r = max(r, config("minR"));

        isUEsCovered = getIsUEsCovered(locationOfUEs, newUEsSet, isUEsCovered);
        % sum(isUEsCovered,"all")

        % 演算法第5行
        % 更新結果
        UAVBSsSet(size(UAVBSsSet, 1) + 1,:) = newPositionOfUAVBS;
        uncoveredUEsSet = setdiff(uncoveredUEsSet, newUEsSet, 'rows');
        UAVBSsR(size(UAVBSsR, 1) + 1,1) = r;
        UEsPositionOfUAVServedBy{1, size(UEsPositionOfUAVServedBy, 2) + 1} = newUEsSet;

        % 演算第6行
        % 以不更改排序的情況下移除未覆蓋邊緣集合裡已覆蓋的邊緣點
        commonRows = ismember(uncoveredBoundaryUEsSet, newUEsSet, 'rows');
        uncoveredBoundaryUEsSet(commonRows, :) = [];
        if isempty(uncoveredBoundaryUEsSet)
            [uncoveredBoundaryUEsSet, angle] = findBoundaryUEsSet(false, uncoveredUEsSet, angle);
        end
    end
end