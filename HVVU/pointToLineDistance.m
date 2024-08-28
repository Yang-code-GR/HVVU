function distance = pointToLineDistance(point, x1, y1, x2, y2)
    % 判断点是否在垂线上，如果是，计算点到线的垂线距离，如果不是，计算点到线两端的距离，取最小值作为最短距离
    % point: 节点坐标 [x, y]
    % x1, y1, x2, y2: 直线的两个端点坐标
    
    % 计算直线的斜率
    slope = (y2 - y1) / (x2 - x1);
    
    % 判断点是否在垂线上
    if isinf(slope) || isnan(slope)
        % 如果直线是垂直线
        distance = abs(point(1) - x1);
    else
        % 计算直线的截距
        intercept = y1 - slope * x1;
        
        % 计算垂线的斜率
        perpendicularSlope = -1 / slope;
        
        % 计算垂线的截距
        perpendicularIntercept = point(2) - perpendicularSlope * point(1);
        
        % 计算垂足的坐标
        perpendicularX = (perpendicularIntercept - intercept) / (slope - perpendicularSlope);
        perpendicularY = perpendicularSlope * perpendicularX + perpendicularIntercept;
        perpendicularPoint = [perpendicularX, perpendicularY];
        
        % 判断垂足是否在线段上
        if perpendicularX >= min(x1, x2) && perpendicularX <= max(x1, x2) && perpendicularY >= min(y1, y2) && perpendicularY <= max(y1, y2)
            % 如果垂足在线段上
            distance = norm(point - perpendicularPoint);
        else
            % 如果垂足不在线段上
            dist1 = norm(point - [x1, y1]);
            dist2 = norm(point - [x2, y2]);
            distance = min(dist1, dist2);
        end
    end
end