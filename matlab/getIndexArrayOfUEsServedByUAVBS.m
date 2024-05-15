function indexArrayOfUEsServedByUAVBS = getIndexArrayOfUEsServedByUAVBS(UEsPositionOfUAVBSIncluded, locationOfUEs, UAVBSsSet)
    % UEsPositionOfUAVBSIncluded: UAVBS涵蓋住的所有UE座標(包含連線與未連線) {[],[],...}

    % 列出每個UE被涵蓋住的所有UAV
    UAVIndexArrayOfUECoveredBy = cell(size(locationOfUEs, 1),1); % UE被涵蓋住的所有UAV索引 {[id1,id2,...];[id1,id2,...];...}
    for i=1:size(locationOfUEs, 1)
        UAVIndexArrayOfUECoveredBy{i,1} = [];
        for j=1:size(UEsPositionOfUAVBSIncluded, 1)
            if nnz(ismember(locationOfUEs(i,:), UEsPositionOfUAVBSIncluded{j,1},'rows'))
                UAVIndexArrayOfUECoveredBy{i,1}(1,size(UAVIndexArrayOfUECoveredBy{i,1},2)+1) = j;
            end
        end
    end

    % 將每位使用者分配給一台無人機服務
    indexArrayOfUEsServedByUAVBS = zeros(size(locationOfUEs, 1), 1); % [id1; id2; id3;...]
    % UAVIndexArrayOfUECoveredBy
    for i=1:size(locationOfUEs, 1)
        distances = pdist2(UAVBSsSet(UAVIndexArrayOfUECoveredBy{i,1},:), locationOfUEs(i,:));
        [~, index] = min(distances,[],1);
        indexArrayOfUEsServedByUAVBS(i,1) = UAVIndexArrayOfUECoveredBy{i,1}(1,index);
    end
end