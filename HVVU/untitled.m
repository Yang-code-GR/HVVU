figure(1);
hold on;

%%

remainingIndices = setdiff(1:numNodes, selectedIndices);
remainingPoints = cluster(remainingIndices, :);

%%

% 初始化新的折线
newLineCoords = line_coords;

% 遍历 remainingPoints 中的每个节点
for i = 1:size(remainingPoints, 1)
    point = remainingPoints(i, :);
    minDist = Inf;
    nearestLineIndex = 0;
    nearestEndpoint = 0;
    
    % 遍历每条直线，找到距离最近的直线和对应的线段一端
    for j = 1:size(newLineCoords, 1)
        x1 = newLineCoords(j, 1);
        x2 = newLineCoords(j, 2);
        y1 = newLineCoords(j, 3);
        y2 = newLineCoords(j, 4);
        
        % 计算节点与直线的距离
        dist = pointToLineDistance(point, x1, y1, x2, y2);
        
        if dist < minDist
            minDist = dist;
            nearestLineIndex = j;
            
            % 判断距离最近的端点是线段的哪一端
            dist1 = sqrt((x1 - point(1))^2 + (y1 - point(2))^2);
            dist2 = sqrt((x2 - point(1))^2 + (y2 - point(2))^2);
            if dist1 < dist2
                nearestEndpoint = 1;  % 线段的起点是距离最近的端点
            else
                nearestEndpoint = 2;  % 线段的终点是距离最近的端点
            end
        end
    end
    
    % 如果距离小于10，将节点加入最近的直线段作为折线
    if minDist < 20
        x1 = newLineCoords(nearestLineIndex, 1);
        x2 = newLineCoords(nearestLineIndex, 2);
        y1 = newLineCoords(nearestLineIndex, 3);
        y2 = newLineCoords(nearestLineIndex, 4);
        
        % 将节点插入到线段的合适位置
        if nearestEndpoint == 1
            newLineCoords(nearestLineIndex, :) = [x1, point(1), y1, point(2)];
        else
            newLineCoords(nearestLineIndex, :) = [point(1), x2, point(2), y2];
        end
    else
        % 将节点添加为新的直线段
        newLineCoords = [newLineCoords; point(1), point(1), point(2), point(2)];
    end
end

% 对新的折线按照节点的顺序进行排序
[~, sortIndices] = sort(newLineCoords(:, 1));
newLineCoords = newLineCoords(sortIndices, :);

% 连接线段的另一端
newLineCoords(end, 2) = newLineCoords(1, 1);
newLineCoords(end, 4) = newLineCoords(1, 3);

%% 绘制新的折线
for i = 1:size(newLineCoords, 1)
    x1 = newLineCoords(i, 1);
    x2 = newLineCoords(i, 2);
    y1 = newLineCoords(i, 3);
    y2 = newLineCoords(i, 4);
    plot([x1, x2], [y1, y2], 'red','LineStyle', '--', 'LineWidth', 3,'Marker', 'none', 'MarkerFaceColor', 'none');
end