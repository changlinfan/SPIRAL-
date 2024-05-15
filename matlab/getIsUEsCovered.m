function isUEsCovered = getIsUEsCovered(locationOfUEs, newUEsSet, isUEsCovered)
    % isUEsCovered: 地面UE是否被覆盖[bool;bool;...]

    commonRows = ismember(locationOfUEs, newUEsSet, 'rows');
    isUEsCovered(commonRows, 1) = true;
end