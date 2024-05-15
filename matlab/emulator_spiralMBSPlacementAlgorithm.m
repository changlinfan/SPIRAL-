function data = emulator_spiralMBSPlacementAlgorithm(r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS)
    outputDir = "../static";

    % 載入環境參數
    [~, ~, ~, ~, ~, config] = loadEnvironment();

    % 確保輸出的資料夾存在
    checkOutputDir(outputDir);

    % 讀檔讀取UE
    locationOfUEs = load(outputDir+"/locationOfUEs.mat").locationOfUEs;

    data = load(outputDir+"/data.mat");
    satisfiedRateData = data.satisfiedRateData;
    fairnessData = data.fairnessData;
    dataRate = data.dataRate;
    numberOfUAVBS = data.numberOfUAVBS;
    energyEfficiency = data.energyEfficiency;

    % 演算法
    [UAVBSsSet, ~] = spiralMBSPlacementAlgorithm(locationOfUEs, r_UAVBS);
    UAVBSsR = zeros(size(UAVBSsSet,1),1); % UAVBSs的半徑
    for i=1:size(UAVBSsR,1)
        UAVBSsR(i,1) = r_UAVBS;
    end
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
    indexArrayOfUEsServedByUAVBS = getIndexArrayOfUEsServedByUAVBS(UEsPositionOfUAVBSIncluded, locationOfUEs, UAVBSsSet); % 每位使用者連線到的無人機 [n1; n2;...]
    % 效能分析
    [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    satisfiedRateData(1,1) = satisfiedRate;
    fairnessData(1,1) = fairness;
    tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
    dataRate(1,1) = tempDataRate;
    k1 = size(UAVBSsSet,1);
    numberOfUAVBS(1,1) = k1;
    energyEfficiency(1,1) = tempDataRate / k1;
    % 繪圖
    exportImage(outputDir+'/spiralMBSPlacementAlgorithm', locationOfUEs, UAVBSsSet, UAVBSsR, UEsPositionOfUAVBSIncluded, config);

    save(outputDir + "/data.mat", "satisfiedRateData", "fairnessData", "dataRate", "numberOfUAVBS", "energyEfficiency");
    keys = ["satisfiedRateData"; "fairnessData"; "dataRate"; "numberOfUAVBS"; "energyEfficiency"; "k"];
    values = {satisfiedRateData(1, 1); fairnessData(1, 1); dataRate(1, 1); numberOfUAVBS(1, 1); energyEfficiency(1, 1); k1};
    map = containers.Map(keys, values);
    data = jsonencode(map);
end