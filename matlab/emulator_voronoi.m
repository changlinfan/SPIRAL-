function data = emulator_voronoi(r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS)
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
    [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = voronoiAlgorithm(locationOfUEs, r_UAVBS, config);
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
    indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
    % 效能分析
    [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    satisfiedRateData(1, 6) = satisfiedRate;
    fairnessData(1, 6) = fairness;
    tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
    dataRate(1, 6) = tempDataRate;
    tempNumberOfUAVBS = size(UAVBSsSet,1);
    numberOfUAVBS(1, 6) =  tempNumberOfUAVBS;
    energyEfficiency(1, 6) =(tempDataRate / tempNumberOfUAVBS);
    % 繪圖
    exportImage(outputDir + '/voronoi', locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);

    keys = ["satisfiedRateData"; "fairnessData"; "dataRate"; "numberOfUAVBS"; "energyEfficiency"];
    values = {satisfiedRateData(1, 6); fairnessData(1, 6); dataRate(1, 6); numberOfUAVBS(1, 6); energyEfficiency(1, 6)};
    map = containers.Map(keys, values);
    data = jsonencode(map);
end