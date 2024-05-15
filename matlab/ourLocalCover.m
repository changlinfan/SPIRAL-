function [u, Pprio, r] = ourLocalCover(u, Pprio, Psec, locationOfUEs, isUEsCovered, maxNumOfUE, config)
    % u: 當前無人機位置，向量形式[x,y]
    % Pprio: 無人機涵蓋的UE
    % Psec: 未被覆蓋的UE

    r = 0;
    % 演算法第1行
    while ~isempty(Psec)
        % 從Psec移除大於2r的UE
        distances = pdist2(Psec, u);
        indexes = find(distances(:, 1) > 2 * config("maxR"));
        Psec(indexes, :) = [];

        if ~isempty(Psec)
            % 把最近且合法的UE加入範圍
            distances = pdist2(Psec, u);
            [~, indexOfShortestDistances] = min(distances, [], 1); % 最近UE的index
            newPprio = Pprio;
            newPprio(size(newPprio, 1) + 1, :) = Psec(indexOfShortestDistances, :);
            [newR, newU, ~] = ExactMinBoundCircle(newPprio); % 計算新的半徑及中心

            distancesBetweenUEsAndU = pdist2(locationOfUEs, newU);
            indexOfNewPprio = find(distancesBetweenUEsAndU <= newR);
            newPprio = union(locationOfUEs(indexOfNewPprio, :), newPprio, 'rows');

            % 判斷是否合法
            if newR > config("maxR")
                return;
            end

            % newPprio = locationOfUEs(find(pdist2(locationOfUEs, newU) <= newR),:);

            % 判斷是否超出覆蓋數量
            commonRows = ismember(locationOfUEs, newPprio, 'rows');
            if sum(isUEsCovered(commonRows, 1), "all") > config('maxNumOfOverlay')
                return;
            end
            
            Pprio = newPprio;
            Psec = setdiff(Psec, Pprio, 'rows');
            u = newU;
            r = newR;
            if size(Pprio, 1) >= maxNumOfUE
                return;
            end
        end
    end
end