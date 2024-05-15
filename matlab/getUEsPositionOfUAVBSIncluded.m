function UEsPositionOfUAVBSIncluded = getUEsPositionOfUAVBSIncluded(UAVBSsR, locationOfUEs, UAVBSsSet)
    UEsPositionOfUAVBSIncluded = cell(size(UAVBSsSet,1),1);

    for i=1:size(UAVBSsSet,1)
        UEsPositionOfUAVBSIncluded{i} = zeros(0,2);
        for j=1:size(locationOfUEs,1)
            if pdist2(UAVBSsSet(i,:), locationOfUEs(j,:)) <= UAVBSsR(i,1)
                UEsPositionOfUAVBSIncluded{i}(size(UEsPositionOfUAVBSIncluded{i},1)+1,:) = locationOfUEs(j,:);
            end
        end
    end
end