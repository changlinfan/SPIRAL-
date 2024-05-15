function doKmeans()
    outputDir = "./out/專題成果/模擬圖"; % 輸出檔放置的資料夾
   
    % 載入環境參數
    [ue_size, rangeOfPosition, r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS, config] = loadEnvironment();

    % 確保輸出的資料夾存在
    checkOutputDir(outputDir); 
    
    % 生成UE及寫檔
    % locationOfUEs = UE_generator(ue_size, rangeOfPosition);
    % locationOfUEs = locationOfUEs(:,1:2);
    % save(outputDir+"/locationOfUEs.mat", "locationOfUEs");

    % 讀檔讀取UE
    locationOfUEs = load(outputDir+"/locationOfUEs.mat").locationOfUEs;

    % [UAVBSsSet, ~] = spiralMBSPlacementAlgorithm(locationOfUEs, r_UAVBS);

    % [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = ourAlgorithm(locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    % k = size(UAVBSsSet, 1)

    % k = 36; % our
    k = 16; % spiral

    % 演算法
    [indexArrayOfUEsServedByUAVBS, UAVBSsSet] = kmeans(locationOfUEs ,k);
    UAVBSsR = zeros(k, 1);
    for i = 1:k
        [indexOfUEs] = find(indexArrayOfUEsServedByUAVBS == i);
        r = pdist2(locationOfUEs(indexOfUEs, :), UAVBSsSet(i, :));
        UAVBSsR(i,1) = max([r;config("minR")], [], "all");
        UAVBSsR(i,1) = min([UAVBSsR(i,1);config("maxR")], [], "all");
    end

    % numOfUEsConnected = tabulate(indexArrayOfUEsServedByUAVBS); % 每台UAVBS連線到的UE數量
    % numOfUEsConnected = numOfUEsConnected(:,2);

    % 效能分析
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet);
    [~, ~, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    satisfiedRate
    fairness

    % 繪圖
    % exportImage(outputDir+'/kmeans_our', locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);
    exportImage(outputDir+'/kmeans_sMBSP', locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);

    % JOSN
    % json = exportJSON(locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);
    % fileID = fopen(outputDir+'/data.json','w');
    % fprintf(fileID, '%s', json);
    % fclose(fileID);
end