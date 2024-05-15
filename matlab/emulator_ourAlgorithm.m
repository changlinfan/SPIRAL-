function data = emulator_ourAlgorithm(minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS)
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
    [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = ourAlgorithm(locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
    indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
    % 效能分析
    [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    satisfiedRateData(1,  2) = satisfiedRate;
    fairnessData(1,  2) = fairness;
    tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
    dataRate(1, 2) = tempDataRate;
    k2 = size(UAVBSsSet,1);
    numberOfUAVBS(1, 2) =  k2;
    energyEfficiency(1, 2) = (tempDataRate / k2);
    % 繪圖
    exportImage(outputDir+'/ourAlgorithm', locationOfUEs, UAVBSsSet, UAVBSsR, UEsPositionOfUAVBSIncluded, config);

    save(outputDir + "/data.mat", "satisfiedRateData", "fairnessData", "dataRate", "numberOfUAVBS", "energyEfficiency");
    keys = ["satisfiedRateData"; "fairnessData"; "dataRate"; "numberOfUAVBS"; "energyEfficiency"; "k"];
    values = {satisfiedRateData(1, 2); fairnessData(1, 2); dataRate(1, 2); numberOfUAVBS(1, 2); energyEfficiency(1, 2); k2};
    map = containers.Map(keys, values);
    data = jsonencode(map);
end