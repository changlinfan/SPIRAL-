function drawChartN()
    outputDir = "./out/專題成果/2mbps"; % 輸出檔放置的資料夾
    figure;
    xlabelText = "地面使用者的數量";

    % 確保輸出的資料夾存在
    checkOutputDir(outputDir); 

    
    % data = load(outputDir+"/varyingN_100times.mat").satisfiedRateData;
    % ylabelText = "使用者滿意度(%)";
    % outputFile = "/satisfiedRate_varyingN_100times.jpg";
    % maxlim = 100;

    % data = load(outputDir+"/varyingN_100times.mat").fairnessData;
    % data = data / 100;
    % ylabelText = "公平性";
    % outputFile = "/fairness_varyingN_100times.jpg";
    % maxlim = 1;

    data = load(outputDir+"/varyingN_100times.mat").dataRate;
    data = data / (10 ^ 6);
    ylabelText = "系統資料速率(Mbps)";
    outputFile = "/dataRate_varyingN_100times.jpg";
    maxlim = -1;

    % data = load(outputDir+"/varyingN_100times.mat").numberOfUAVBS;
    % data = data / 100;
    % ylabelText = "通訊無人機的數量";
    % outputFile = "/numberOfUAVBS_varyingN_100times.jpg";
    % maxlim = -1;

    % data = load(outputDir+"/varyingN_100times.mat").energyEfficiency;
    % data = data / 100;
    % ylabelText = "能源效率";
    % outputFile = "/energyEfficiency_varyingN_100times.jpg";
    % maxlim = -1;

    x = 200:200:1000;
    plot(x,data(:,2),'r-o',x,data(:,1),'b-square',x,data(:,3),'m-diamond',x,data(:,4),'g-^',x,data(:,5),'k-+',x,data(:,6),'c-x','LineWidth',2,'MarkerSize',10);
    xlabel(xlabelText,'FontName','標楷體');
    ylabel(ylabelText,'FontName','標楷體');
    h = legend({'SPIRAL+(K_{N}^{SPIRAL+})','逆時針螺旋(K_{N}^{SMBSP})','kmeans(K_{N}^{k-means}=K_{N}^{SMBSP})','kmeans(K_{N}^{k-means}=K_{N}^{SPIRAL+})','隨機','Voronoi'},'Location','best');
    set(h,'FontName','標楷體');
    grid on;
    if maxlim > 0
        ylim([0 maxlim]);
    end
    % exportgraphics(gcf, outputDir + outputFile, 'Resolution', 150, 'BackgroundColor', "#FFFFFF"); % 130
end