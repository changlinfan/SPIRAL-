function doOurAlgorithm_withDrawStep()
    backgroundColor = '#FFFFFF';
    UAVBSColor = '#61Cd81';
    UEColor = '#2F71F4';
    textColor = '#242424';
    % connectLineColor = '#DE5137';
    clf(gcf);
    set(gcf,'outerposition', get(0,'screensize')); % 視窗最大
    set(gcf,'visible', 'on'); % on/off
    set(gca, 'Color', backgroundColor);
    hold on;

    outputDir = "./out"; % 輸出檔放置的資料夾
   
    % 載入環境參數
    [ue_size, rangeOfPosition, r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS, config] = loadEnvironment_withDrawStep();

    % 確保輸出的資料夾存在
    % checkOutputDir(outputDir); 

    % 生成UE及寫檔
    locationOfUEs = UE_generator(ue_size, rangeOfPosition);
    locationOfUEs = locationOfUEs(:,1:2);
    save(outputDir+"/locationOfUEs_demo.mat", "locationOfUEs");

    % 讀檔讀取UE
    % locationOfUEs = load(outputDir+"/TANET/locationOfUEs.mat").locationOfUEs;
    % locationOfUEs = load(outputDir+"/locationOfUEs.mat").locationOfUEs;

    % 演算法
    [UAVBSsSet, UAVBSsR, UEsPositionOfUAVServedBy] = ourAlgorithm_withDrawStep(locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    
    UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet); % 該UAVBS涵蓋住的所有UE座標(包含連線與未連線)
    indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs); % 每位使用者連線到的無人機 [n1; n2;...]

    % 效能分析
    % [totalDataTransferRatesOfUAVBSs, dataTransferRates, satisfiedRate, fairness] = performance(indexArrayOfUEsServedByUAVBS, UAVBSsSet, UEsPositionOfUAVBSIncluded, UAVBSsR, locationOfUEs, maxDataTransferRateOfUAVBS, minDataTransferRateOfUEAcceptable, config);
    % satisfiedRate
    % fairness

    % disp('k = ' + string(size(UAVBSsSet, 1)));

    % 繪圖
    % exportImage(outputDir + '/ourAlgorithm', locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config);

    xArrayFromLocationOfUEs = locationOfUEs(:,1); % UE的x座標陣列
    yArrayFromLocationOfUEs = locationOfUEs(:,2); % UE的y座標陣列
    % UAVBSs的涵蓋範圍
    for i=1:size(UAVBSsSet,1)
        x = UAVBSsSet(i,1);
        y = UAVBSsSet(i,2);
        rectangle('Position', [x-UAVBSsR(i,1),y-UAVBSsR(i,1),2*UAVBSsR(i,1),2*UAVBSsR(i,1)], 'Curvature', [1,1], 'EdgeColor', UAVBSColor, 'LineWidth', 1);
    end

    % 所有UAVBSs的點
    scatter(UAVBSsSet(:,1), UAVBSsSet(:,2), 80, "filled", "square", 'MarkerFaceColor', UAVBSColor);

    % 所有UEs的點
    scatter(xArrayFromLocationOfUEs, yArrayFromLocationOfUEs, 20, "filled", "^", 'MarkerFaceColor', UEColor); % , 'MarkerEdgeColor', UEColor,

    % UAVBSs編號
    for i=1:size(UAVBSsSet,1)
        x = UAVBSsSet(i,1);
        y = UAVBSsSet(i,2);
        text(x, y, string(i)+' ', 'HorizontalAlignment', 'right', 'FontSize', 14, 'FontWeight', 'bold', 'Color', textColor);
    end

    % 圖表設定
    axis equal;
    minPosition = min(locationOfUEs);
    maxPosition = max(locationOfUEs);
    maxR = config("maxR");
    axis([minPosition(1,1)-maxR, maxPosition(1,1)+maxR, minPosition(1,2)-maxR, maxPosition(1,2)+maxR]); % axis([xmin,xmax,ymin,ymax])
    hold off;
    % exportgraphics(gcf, file + '.jpg', 'Resolution', 150, 'BackgroundColor', backgroundColor); % 130
    % saveas(gcf, file + '.eps','epsc');
end