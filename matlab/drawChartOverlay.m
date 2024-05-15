function drawChartOverlay()
    outputDir = "./out"; % 輸出檔放置的資料夾
    
    % 確保輸出的資料夾存在
    checkOutputDir(outputDir); 

    % data = load(outputDir+"/satisfiedRateData_varyingOverlay_10times.mat").satisfiedRateData;
    % xlabelText = "Overlay";
    % ylabelText = "使用者滿意度(%)";
    % outputFile = "/satisfiedRate_varyingOverlay.jpg";
    % data = data*10;

    data = load(outputDir+"/fairnessData_varyingOverlay_10times.mat").fairnessData;
    data = data*10;
    xlabelText = "Overlay";
    ylabelText = "公平性";
    outputFile = "/fairness_varyingOverlay.jpg";

    x = 10:10:100;
    figure;
    plot(x,data(:,1),'b-square','LineWidth',2,'MarkerSize',10);
    xlabel(xlabelText,'FontName','標楷體');
    ylabel(ylabelText,'FontName','標楷體');
    % h = legend({'SPIRAL+(K_{N}^{SPIRAL+})','逆時針螺旋(K_{N}^{SMBSP})','kmeans(K_{N}^{k-means}=K_{N}^{SMBSP})','kmeans(K_{N}^{k-means}=K_{N}^{SPIRAL+})'},'Location','best');
    % set(h,'FontName','標楷體');
    grid on;
    exportgraphics(gcf, outputDir + outputFile, 'Resolution', 150, 'BackgroundColor', "#FFFFFF"); % 130
end