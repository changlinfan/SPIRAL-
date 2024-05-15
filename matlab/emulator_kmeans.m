function data = emulator_kmeans(index, k, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS)
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
    [indexArrayOfUEsServedByUAVBS, UAVBSsSet] = kmeans(locationOfUEs ,k);
    UAVBSsR = zeros(k, 1);
    for i = 1:k
        [indexOfUEs] = find(indexArrayOfUEsServedByUAVBS == i);
        r = pdist2(locationOfUEs(indexOfUEs, :), UAVBSsSet(i, :));
        UAVBSsR(i,1) = max([r;config("minR")], [], "all");
        UAVBSsR(i,1) = min([UAVBSsR(i,1);config("maxR")], [], "all");
    end
    % 效能分析
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet);
    [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    satisfiedRateData(1, index) = satisfiedRate;
    fairnessData(1, index) =  fairness;
    tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
    dataRate(1, index) = tempDataRate;
    numberOfUAVBS(1, index) = k;
    energyEfficiency(1, index) = (tempDataRate / k);
    % 繪圖
    exportImage(outputDir + ['/kmeans_' num2str(index,'%01d')], locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);

    save(outputDir + "/data.mat", "satisfiedRateData", "fairnessData", "dataRate", "numberOfUAVBS", "energyEfficiency");
    keys = ["satisfiedRateData"; "fairnessData"; "dataRate"; "numberOfUAVBS"; "energyEfficiency"];
    values = {satisfiedRateData(1, index); fairnessData(1, index); dataRate(1, index); numberOfUAVBS(1, index); energyEfficiency(1, index)};
    map = containers.Map(keys, values);
    data = jsonencode(map);
end