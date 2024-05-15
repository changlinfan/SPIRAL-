function doCompareOverlay()
    outputDir = "./out"; % 輸出檔放置的資料夾
    
    % 載入環境參數
    [ue_size, rangeOfPosition, r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS, config] = loadEnvironment();
 
    % 確保輸出的資料夾存在
    checkOutputDir(outputDir); 

    satisfiedRateData = zeros(10, 1);
    fairnessData = zeros(10, 1);
    % satisfiedRateData = load(outputDir+"/10m/satisfiedRateData_varyingN_100times.mat").satisfiedRateData;
    % fairnessData = load(outputDir+"/10m/fairnessData_varyingN_100times.mat").fairnessData;

    for times = 1:10
        % 生成UE及寫檔
        locationOfUEs = UE_generator(ue_size, rangeOfPosition);
        locationOfUEs = locationOfUEs(:,1:2);
                    
        % 讀檔讀取UE
        % locationOfUEs = load(outputDir+"/locationOfUEs_5.mat").locationOfUEs;

        for maxNumOfOverlay = 10:10:100
            config('maxNumOfOverlay') = maxNumOfOverlay;

            
            % 演算法
            [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = ourAlgorithm(locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
            indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]
            % 效能分析
            [~, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
            satisfiedRateData(maxNumOfOverlay/10,1) = satisfiedRateData(maxNumOfOverlay/10,1) + satisfiedRate;
            fairnessData(maxNumOfOverlay/10,1) = fairnessData(maxNumOfOverlay/10,1) + fairness;
        
        end
    end
    save(outputDir+"/satisfiedRateData_varyingOverlay_10times.mat", "satisfiedRateData");
    save(outputDir+"/fairnessData_varyingOverlay_10times.mat", "fairnessData");
    satisfiedRateData
end