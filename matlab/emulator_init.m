function emulator_init(ue_size, rangeOfPosition)
    outputDir = "../static";

    % 確保輸出的資料夾存在
    checkOutputDir(outputDir); 
    % 生成UE及寫檔
    locationOfUEs = UE_generator(ue_size, rangeOfPosition);
    locationOfUEs = locationOfUEs(:,1:2);

    satisfiedRateData = zeros(1, 6);
    fairnessData = zeros(1, 6);
    dataRate = zeros(1, 6);
    numberOfUAVBS = zeros(1, 6);
    energyEfficiency = zeros(1, 6);

    save(outputDir + "/data.mat", "satisfiedRateData", "fairnessData", "dataRate", "numberOfUAVBS", "energyEfficiency");
    save(outputDir + "/locationOfUEs.mat", "locationOfUEs");
end