
%%
remainingIndices = setdiff(1:numNodes, selectedIndices);
remainingPoints = cluster(remainingIndices, :);
%%
% 初始化新的折线
new_addcluster = [];
newLineCoords = line_coords;
% 遍历 remainingPoints 中的每个节点
for i = 1:size(remainingPoints, 1)
    point = remainingPoints(i, :);
    minDist = Inf;
    nearestLineIndex = 0;
    nearestEndpoint = 0;
    % 遍历每条直线，找到距离最近的直线和对应的线段一端
    for j = 1:size(line_coords, 1)
        x1 = line_coords(j, 1);
        x2 = line_coords(j, 2);
        y1 = line_coords(j, 3);
        y2 = line_coords(j, 4);
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
end

%% 绘制新的折线
for i = 1:size(newLineCoords, 1)
    x1 = newLineCoords(i, 1);
    x2 = newLineCoords(i, 2);
    y1 = newLineCoords(i, 3);
    y2 = newLineCoords(i, 4);
    plot([x1, x2], [y1, y2], 'red','LineStyle', '--', 'LineWidth', 3,'Marker', 'none', 'MarkerFaceColor', 'none');
end



%% 计算新路线的距离
newTable = newLineCoords(:, [1, 3, 2,4]);
% 计算所有行中两点的距离
distances = sqrt((newTable(:,1) - newTable(:,3)).^2 + (newTable(:,2) - newTable(:,4)).^2);

% 求所有行中距离的和
total_distance = sum(distances);

% 输出结果
disp('Distances:');
disp(distances);
disp('Total Distance:');
disp(total_distance);