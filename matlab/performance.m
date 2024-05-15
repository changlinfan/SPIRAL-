% 效能分析
function [totalDataTransferRatesOfUAVBSs, dataTransferRates, satisfiedRate,fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config)
    numOfUEsConnected = zeros(size(UAVBSsSet, 1), 1); % 每台UAVBS連線到的UE數量
    for i = 1:size(numOfUEsConnected, 1)
        numOfUEsConnected(i, 1) = size(find(indexArrayOfUEsServedByUAVBS == i), 1);
    end
    arrayOfBandwidths = getBandwidths(numOfUEsConnected, config); % UAV服務一台UE的頻寬
    possibility = getPossibility(UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, config); % LoS及NLoS機率
    averagePathLoss = getAveragePathLoss(UAVBSsSet, UEsPositionOfUAVBSIncluded, possibility, UAVBSsR, config); % 平均路徑損失
    SINR = signalToInterferencePlusNoiseRatio(locationOfUEs, UEsPositionOfUAVBSIncluded, averagePathLoss, indexArrayOfUEsServedByUAVBS, arrayOfBandwidths, config); % [SINR1; SINR2;...]
    dataTransferRates = getDataTransferRate(SINR, indexArrayOfUEsServedByUAVBS, arrayOfBandwidths); % [dataTransferRates1; dataTransferRates2;...]
    totalDataTransferRatesOfUAVBSs = getTotalDataTransferRatesOfUAVBSs(dataTransferRates, indexArrayOfUEsServedByUAVBS); % [totalDataTransferRatesOfUAVBSs1; totalDataTransferRatesOfUAVBSs2;...]

    % 往回檢查速率上限
    overflowIndex = find(totalDataTransferRatesOfUAVBSs > maxDataTransferRateOfUAVBS);
    totalDataTransferRatesOfUAVBSs(overflowIndex, 1) = maxDataTransferRateOfUAVBS;
    for i = 1:size(overflowIndex, 1)
        indexOfUAVBS = overflowIndex(i, 1);
        indexOfUEConnected = find(indexArrayOfUEsServedByUAVBS == indexOfUAVBS); % 該超過速率的UAV所連線到的UE
        numOfUE = size(indexOfUEConnected, 1); % 連線到的UE數量
        newDataTransferRate = maxDataTransferRateOfUAVBS / numOfUE; % 重新分配後的速率
        dataTransferRates(indexOfUEConnected, 1) = newDataTransferRate;
    end

    indexOfSatisfied = find(dataTransferRates > minDataTransferRateOfUEAcceptable); % 滿意的UE
    satisfiedRate = size(indexOfSatisfied, 1) / size(dataTransferRates, 1); % 滿意度
    fairness = (sum(numOfUEsConnected, 1) ^ 2) / (size(numOfUEsConnected, 1) * sum(numOfUEsConnected.^2, 1)); % 公平性
    % fairness = (sum(totalDataTransferRatesOfUAVBSs,1)^2)/(size(totalDataTransferRatesOfUAVBSs,1)*sum(totalDataTransferRatesOfUAVBSs.^2,1)); % 公平性
end