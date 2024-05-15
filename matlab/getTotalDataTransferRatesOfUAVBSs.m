function totalDataTransferRatesOfUAVBSs = getTotalDataTransferRatesOfUAVBSs(dataTransferRates, indexArrayOfUEsServedByUAVBS)
    numOfUAVBSs = max(indexArrayOfUEsServedByUAVBS); % 無人機數量
    totalDataTransferRatesOfUAVBSs = zeros(numOfUAVBSs, 1);
    for i=1:numOfUAVBSs
        indexOfUEsThatServedByUAVBS = find(indexArrayOfUEsServedByUAVBS == i); % UAVi服務的所有UE的索引值
        totalDataTransferRatesOfUAVBSs(i,1) = sum(dataTransferRates(indexOfUEsThatServedByUAVBS,1),1);
    end
end