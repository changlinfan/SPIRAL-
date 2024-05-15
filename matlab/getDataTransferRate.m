function dataTransferRates = getDataTransferRate(SINR, indexArrayOfUEsServedByUAVBS, arrayOfBandwidths)
    % SINR: 每個UE的SINR []
    % bandwidth: 總頻寬

    dataTransferRates = SINR;
    dataTransferRates = dataTransferRates+1;
    dataTransferRates = log2(dataTransferRates);
    for i=1:size(arrayOfBandwidths,1)
        dataTransferRates(find(indexArrayOfUEsServedByUAVBS == i),1) = dataTransferRates(find(indexArrayOfUEsServedByUAVBS == i),1)*arrayOfBandwidths(i,1);
    end
end