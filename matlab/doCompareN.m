function doCompareN()
    outputDir = "./out"; % 輸出檔放置的資料夾
    
    % 載入環境參數
    [~, rangeOfPosition, r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS, config] = loadEnvironment();
 
    % 確保輸出的資料夾存在
    checkOutputDir(outputDir); 

    satisfiedRateData = zeros(5, 6);
    fairnessData = zeros(5, 6);
    dataRate = zeros(5, 6);
    numberOfUAVBS = zeros(5, 6);
    energyEfficiency = zeros(5, 6);
    % satisfiedRateData = load(outputDir+"/satisfiedRateData_varyingN_100times.mat").satisfiedRateData;
    % fairnessData = load(outputDir+"/fairnessData_varyingN_100times.mat").fairnessData;

    for times = 1:100
        for ue_size = 200:200:1000
            disp(string(ue_size)+"/1000");
            % 生成UE及寫檔
            locationOfUEs = UE_generator(ue_size, rangeOfPosition);
            locationOfUEs = locationOfUEs(:, 1:2);
        
            % 讀檔讀取UE
            % locationOfUEs = load(outputDir+"/locationOfUEs_5.mat").locationOfUEs;
        
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
            satisfiedRateData(ue_size/200,1) = satisfiedRateData(ue_size/200,1)+satisfiedRate;
            fairnessData(ue_size/200,1) = fairnessData(ue_size/200,1)+fairness;
            tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
            dataRate(ue_size/200,1) = dataRate(ue_size/200,1)+tempDataRate;
            k1 = size(UAVBSsSet,1);
            numberOfUAVBS(ue_size/200,1) = numberOfUAVBS(ue_size/200,1) + k1;
            energyEfficiency(ue_size/200,1) = energyEfficiency(ue_size/200,1) + (tempDataRate / k1);

            % 演算法
            [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = ourAlgorithm(locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
            indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
            % 效能分析
            [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            satisfiedRateData(ue_size/200,2) = satisfiedRateData(ue_size/200,2)+satisfiedRate;
            fairnessData(ue_size/200,2) = fairnessData(ue_size/200,2)+fairness;
            tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
            dataRate(ue_size/200,2) = dataRate(ue_size/200,2)+tempDataRate;
            k2 = size(UAVBSsSet,1);
            numberOfUAVBS(ue_size/200,2) = numberOfUAVBS(ue_size/200,2) + k2;
            energyEfficiency(ue_size/200,2) = energyEfficiency(ue_size/200,2) + (tempDataRate / k2);

            % 演算法
            [indexArrayOfUEsServedByUAVBS, UAVBSsSet] = kmeans(locationOfUEs ,k1);
            UAVBSsR = zeros(k1, 1);
            for i = 1:k1
                [indexOfUEs] = find(indexArrayOfUEsServedByUAVBS == i);
                r = pdist2(locationOfUEs(indexOfUEs, :), UAVBSsSet(i, :));
                UAVBSsR(i,1) = max([r;config("minR")], [], "all");
                UAVBSsR(i,1) = min([UAVBSsR(i,1);config("maxR")], [], "all");
            end
            % 效能分析
            UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet);
            [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            satisfiedRateData(ue_size/200,3) = satisfiedRateData(ue_size/200,3)+satisfiedRate;
            fairnessData(ue_size/200,3) = fairnessData(ue_size/200,3)+fairness;
            tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
            dataRate(ue_size/200,3) = dataRate(ue_size/200,3)+tempDataRate;
            numberOfUAVBS(ue_size/200,3) = numberOfUAVBS(ue_size/200,3) + k1;
            energyEfficiency(ue_size/200,3) = energyEfficiency(ue_size/200,3) + (tempDataRate / k1);

            % 演算法
            [indexArrayOfUEsServedByUAVBS, UAVBSsSet] = kmeans(locationOfUEs ,k2);
            UAVBSsR = zeros(k2, 1);
            for i = 1:k2
                [indexOfUEs] = find(indexArrayOfUEsServedByUAVBS == i);
                r = pdist2(locationOfUEs(indexOfUEs, :), UAVBSsSet(i, :));
                UAVBSsR(i,1) = max([r;config("minR")], [], "all");
                UAVBSsR(i,1) = min([UAVBSsR(i,1);config("maxR")], [], "all");
            end
            % 效能分析
            UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet);
            [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            satisfiedRateData(ue_size/200,4) = satisfiedRateData(ue_size/200,4)+satisfiedRate;
            fairnessData(ue_size/200,4) = fairnessData(ue_size/200,4)+fairness;
            tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
            dataRate(ue_size/200,4) = dataRate(ue_size/200,4)+tempDataRate;
            numberOfUAVBS(ue_size/200,4) = numberOfUAVBS(ue_size/200,4) + k2;
            energyEfficiency(ue_size/200,4) = energyEfficiency(ue_size/200,4) + (tempDataRate / k2);

            % 演算法
            [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = randomAlgorithm(locationOfUEs, rangeOfPosition, config);
            UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
            indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
            % 效能分析
            [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            satisfiedRateData(ue_size/200, 5) = satisfiedRateData(ue_size/200, 5)+satisfiedRate;
            fairnessData(ue_size/200, 5) = fairnessData(ue_size/200, 5)+fairness;
            tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
            dataRate(ue_size/200,5) = dataRate(ue_size/200,5)+tempDataRate;
            tempNumberOfUAVBS = size(UAVBSsSet,1);
            numberOfUAVBS(ue_size/200,5) = numberOfUAVBS(ue_size/200,5) + tempNumberOfUAVBS;
            energyEfficiency(ue_size/200,5) = energyEfficiency(ue_size/200,5) + (tempDataRate / tempNumberOfUAVBS);

            % 演算法
            [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = voronoiAlgorithm(locationOfUEs, r_UAVBS, config);
            UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
            indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
            % 效能分析
            [totalDataTransferRatesOfUAVBSs, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            satisfiedRateData(ue_size / 200, 6) = satisfiedRateData(ue_size / 200, 6) + satisfiedRate;
            fairnessData(ue_size / 200, 6) = fairnessData(ue_size / 200, 6) + fairness;
            tempDataRate = sum(totalDataTransferRatesOfUAVBSs, "all");
            dataRate(ue_size / 200, 6) = dataRate(ue_size / 200, 6)+tempDataRate;
            tempNumberOfUAVBS = size(UAVBSsSet,1);
            numberOfUAVBS(ue_size / 200, 6) = numberOfUAVBS(ue_size / 200, 6) + tempNumberOfUAVBS;
            energyEfficiency(ue_size / 200, 6) = energyEfficiency(ue_size / 200, 6) + (tempDataRate / tempNumberOfUAVBS);
        end
        save(outputDir+"/專題成果/6mbps/varyingN_100times.mat", "satisfiedRateData", "fairnessData", "dataRate", "numberOfUAVBS", "energyEfficiency", "times");
        disp(string(times)+"/100");
    end
    satisfiedRateData
end