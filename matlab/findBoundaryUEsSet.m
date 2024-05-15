function [boundaryUEsSet, UEsSetStartAngle] = findBoundaryUEsSet(isCounterClockwise, UEsSet, UEsSetStartAngle)
    % isCounterClockwise: 是否用逆時針演算(否則為順時針)
    % UEsSet: 所有UE的集合
    % UEsSetStartAngle: 做時針排序時，旋轉到的角度
    % boundaryUEsSet: 產生邊緣UE的集合

    % 無法構成包
    if size(UEsSet,1) <= 2
        boundaryUEsSet = UEsSet;
        return
    end

    % 1. 凸包
    boundaryUEsSet = convhull(UEsSet);
    boundaryUEsSet = UEsSet(boundaryUEsSet,:);
    boundaryUEsSet(1,:) = [];

    % 2. 邊緣
    % xArrayFromUEsSet = UEsSet(:,1); % UE的x座標陣列
    % yArrayFromUEsSet = UEsSet(:,2); % UE的y座標陣列
    % boundaryUEsSet = boundary(xArrayFromUEsSet,yArrayFromUEsSet,0); % 邊界上的UE集合
    % boundaryUEsSet = UEsSet(boundaryUEsSet,:);
    % boundaryUEsSet(1,:) = [];

    % 做逆時針排序
    center = [mean(UEsSet(:, 1)), mean(UEsSet(:, 2))]; % 圖形中心
    vectorInCenter = boundaryUEsSet - repelem(center,size(boundaryUEsSet, 1),1); % 圖形中心到所有UE形成的向量
    % 向量轉角度
    angles = atan2(vectorInCenter(:,2),vectorInCenter(:,1)) * 180 / pi; % 所有UE對圖形中心的角度(deg)
    % 對角度做位移
    anglesWithOffset = angles - UEsSetStartAngle;
    indexOfAngleIsNegative = find(anglesWithOffset < 0);
    anglesWithOffset(indexOfAngleIsNegative) = anglesWithOffset(indexOfAngleIsNegative)+360;
    if isCounterClockwise
        [anglesWithOffset, index] = sort(anglesWithOffset);
    else
        [anglesWithOffset, index] = sort(anglesWithOffset, 'descend');
    end
    angles = angles(index,:);
    boundaryUEsSet = boundaryUEsSet(index,:);
    UEsSetStartAngle = angles(size(angles, 1),1);
end