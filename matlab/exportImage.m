function exportImage(file, locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config)
    backgroundColor = '#FFFFFF';
    UAVBSColor = '#61Cd81';
    UEColor = '#2F71F4';
    boundaryColor = '#242424';
    textColor = '#242424';
    connectLineColor = '#DE5137';
    clf(gcf);
    set(gcf,'outerposition', get(0,'screensize')); % 視窗最大
    set(gcf,'visible', 'off'); % on/off
    set(gca, 'Color', backgroundColor);
    hold on;
    % boundaryUEsSet = convhull(locationOfUEs); % 凸包上的UE集合
    xArrayFromLocationOfUEs = locationOfUEs(:, 1); % UE的x座標陣列
    yArrayFromLocationOfUEs = locationOfUEs(:, 2); % UE的y座標陣列

    % 邊界線
    % plot(xArrayFromLocationOfUEs(boundaryUEsSet), yArrayFromLocationOfUEs(boundaryUEsSet), 'Color', boundaryColor, 'LineStyle', "--");

    % UEs所屬的UAVBS
    % for i = 1:size(indexArrayOfUEsServedByUAVBS, 2)
    %     for j = 1:size(indexArrayOfUEsServedByUAVBS{1, i}, 1)
    %         text(indexArrayOfUEsServedByUAVBS{1, i}(j, 1), indexArrayOfUEsServedByUAVBS{1, i}(j, 2),'\leftarrow ' + string(i));
    %     end
    % end

    % 連接線
    % for i = 1:size(UAVBSsSet, 1) - 1
    %     x = transpose(UAVBSsSet(i:i+1, 1));
    %     y =  transpose(UAVBSsSet(i:i +1, 2));
    %     line(x, y, 'Color', connectLineColor, 'Linestyle', '-');
    % end

    % UEs編號
    % for i = 1:size(locationOfUEs, 1)
    %     text(locationOfUEs(i, 1), locationOfUEs(i, 2), '\leftarrow ' + string(i));
    % end

    % UAVBSs的涵蓋範圍
    for i = 1:size(UAVBSsSet, 1)
        x = UAVBSsSet(i, 1);
        y = UAVBSsSet(i, 2);
        rectangle('Position', [x - UAVBSsR(i, 1), y - UAVBSsR(i, 1), 2 * UAVBSsR(i, 1), 2 * UAVBSsR(i, 1)], 'Curvature', [1, 1], 'EdgeColor', UAVBSColor, 'LineWidth', 1);
    end

    % 所有UAVBSs的點
    scatter(UAVBSsSet(:,1), UAVBSsSet(:,2), 80, "filled", "square", 'MarkerFaceColor', UAVBSColor);

    % 所有UEs的點
    scatter(xArrayFromLocationOfUEs, yArrayFromLocationOfUEs, 20, "filled", "^", 'MarkerEdgeColor', UEColor, 'MarkerFaceColor', UEColor);

    % UAVBSs編號
    for i = 1:size(UAVBSsSet, 1)
        x = UAVBSsSet(i, 1);
        y = UAVBSsSet(i, 2);
        text(x, y, string(i)+' ', 'HorizontalAlignment', 'right', 'FontSize', 14, 'FontWeight', 'bold', 'Color', textColor);
    end

    % 圖表設定
    axis equal;
    minPosition = min(locationOfUEs);
    maxPosition = max(locationOfUEs);
    maxR = config("maxR");
    axis([minPosition(1,1) - maxR, maxPosition(1, 1) + maxR, minPosition(1, 2) - maxR, maxPosition(1, 2) + maxR]); % axis([xmin,xmax,ymin,ymax])
    hold off;
    exportgraphics(gcf, file + '.jpg', 'Resolution', 150, 'BackgroundColor', backgroundColor); % 130
    % saveas(gcf, file + '.eps','epsc');
end