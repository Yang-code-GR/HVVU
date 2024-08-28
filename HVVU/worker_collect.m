
%% 导入数据
% coordinates = [node.x;node.y];
ID = [node.ID]';
data_info=[node.data]';
%% 计算距离矩阵
dist_matrix = pdist2(data, data);
%% 500个workers收集数据
for i=1:length(workers)
    % 找到距离最近的一组节点
    num_nodes = randi([11, 20]);                            % 每个worker随机选择需要的节点数量
    start_node = randi([1, 300]);                           % 随机选择一个起始节点
    [~, sorted_idx] = sort(dist_matrix(start_node, :));
    selected_nodes = sorted_idx(1:num_nodes);

    % 使用最短路径算法连接这些节点

    % graph = graph(dist_matrix(selected_nodes, selected_nodes));
    % tree = minspantree(graph);
    % [TreeEdges, ~] = findedge(tree);

    % 提取节点的坐标、ID、和数据信息
    selected_data = data(selected_nodes, :);
    selected_ID = ID(selected_nodes);
    selected_data_info = data_info(selected_nodes);

    workers(i).node_ID=selected_ID;
    workers(i).node_data=selected_data;
    workers(i).node_data_info=selected_data_info;


    % 绘图
%     path = [selected_data];
%     plot(path(:, 1), path(:, 2), '-o', 'LineWidth', 2);
end
 path = [selected_data];
 plot(path(:, 1), path(:, 2), '-o', 'LineWidth', 2);



%%
for i = 1:length(workers)
    % 检查是否为恶意节点
    if workers(i).malicious == 1
        % 获取cell表
        cellTable = workers(i).node_data_info;

        % 随机选择3-5个double表
        numTables = randi([3, 5]);
        selectedTables = randperm(length(cellTable), numTables);

        for j = 1:numTables
            % 获取double表
            dataTable = cellTable{selectedTables(j)};

            % 计算需要更改的数据数量
            numData = length(dataTable);
            numChange = randi([round(0.3 * numData), round(0.7 * numData)]);

            % 随机选择数据
            selectedData = randperm(numData, numChange);

            % 更改数据
            dataTable(selectedData) = dataTable(selectedData) * (1 + 0.5 * (rand(1) - 0.5));

            % 保存更改后的double表
            cellTable{selectedTables(j)} = dataTable;
        end

        % 保存更改后的cell表
        workers(i).node_data_info = cellTable;
    end
end

%%
% % 遍历 workers 结构体数组
% for idx = 1:numel(workers)
%     % 检查当前节点是否为恶意节点
%     if workers(idx).malicious == 1
%         % 获取当前节点的 cell 表
%         cellArray = workers(idx).node_data_info;
%         
%         % 随机选择 3-5 个 double 表
%         numTables = randi([3, 5]);
%         selectedTables = datasample(cellArray, numTables, 'Replace', false);
%         
%         % 遍历选中的每个 double 表
%         for i = 1:numel(selectedTables)
%             % 获取当前 double 表
%             doubleTable = selectedTables{i};
%             
%             % 确定要修改的数据范围（30%-70%）
%             numData = numel(doubleTable);
% %             numModified = round(numData * rand(1) * 0.4 + numData * 0.3);
%             numModified = round(numData * (rand(1) * 0.4 + 0.3));
%             % 随机选择要修改的数据索引
%             modifiedIndices = randperm(numData, numModified);
%             
%             % 修改选中的数据
%             for j = 1:numel(modifiedIndices)
%                 % 在这里添加您的修改逻辑，例如：
%                 doubleTable(modifiedIndices(j)) = doubleTable(modifiedIndices(j)) * (1 + 0.5 * (rand(1) - 0.5));
%             end
%             
%             % 将修改后的 double 表存回原来的位置
%             cellArray{selectedTables(i)} = doubleTable;
%         end
%         
%         % 将修改后的 cell 表存回原来的位置
%         workers(idx).cellTable = cellArray;
%     end
% end
%% 考虑恶意workers
% 
% % 找到所有malicious值为1的工作节点
% malicious_workers = workers([workers.malicious] == 1);
% 
% 
% % 在node_data_info列中，选取满足条件的节点数据
% for i = 1:length(malicious_workers)
%     data = malicious_workers(i).node_data_info;
%     data_length = length(data);
% 
%     % 计算要修改的数据范围（10% - 70%）
%     start_index = floor(data_length * 0.1) + 1;
%     end_index = floor(data_length * 0.7);
% 
%     % 修改满足条件的节点数据，将数据乘以一个随机因子(可修改)
%     for j = start_index:end_index
%         data(j) = data(j) * (1 + 0.5 * (rand(1) - 0.5));
%     end
% 
%     % 将修改后的数据保存回workers结构体中
% 
%     workers(malicious_workers(i).ID).node_data_info = data;
% end
% 


