function indexArrayOfUEsServedByUAVBS = includedPositionToIndex(UEsPositionOfUAVServedBy, locationOfUEs)
    % UEsPositionOfUAVServedBy: 所有無人機連線到的UE {[;;...],[;;...],...}
    % indexArrayOfUEsServedByUAVBS: 每位使用者連線到的無人機 [n1; n2;...]

    indexArrayOfUEsServedByUAVBS = zeros(size(locationOfUEs, 1), 1);
    for i = 1:size(locationOfUEs, 1)
        for j = 1:size(UEsPositionOfUAVServedBy, 2)
            if nnz(ismember(locationOfUEs(i,:), UEsPositionOfUAVServedBy{j}, 'rows'))
                indexArrayOfUEsServedByUAVBS(i,1) = j;
                break;
            end
        end
    end
end