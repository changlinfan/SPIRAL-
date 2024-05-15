function data = emulator_random(rangeOfPosition, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS)
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
    [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = randomAlgorithm(locationOfUEs, rangeOfPosition, config);
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
    indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
    % 效能分析
    [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    satisfiedRateData(1, 5) =  satisfiedRate;
    fairnessData(1, 5) =fairness;
    tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
    dataRate(1, 5) = tempDataRate;
    tempNumberOfUAVBS = size(UAVBSsSet,1);
    numberOfUAVBS(1, 5) =  tempNumberOfUAVBS;
    energyEfficiency(1, 5) =  (tempDataRate / tempNumberOfUAVBS);
    % 繪圖
    exportImage(outputDir + '/randomAlgorithm', locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);

    save(outputDir + "/data.mat", "satisfiedRateData", "fairnessData", "dataRate", "numberOfUAVBS", "energyEfficiency");
    keys = ["satisfiedRateData"; "fairnessData"; "dataRate"; "numberOfUAVBS"; "energyEfficiency"];
    values = {satisfiedRateData(1, 5); fairnessData(1, 5); dataRate(1, 5); numberOfUAVBS(1, 5); energyEfficiency(1, 5)};
    map = containers.Map(keys, values);
    data = jsonencode(map);
end