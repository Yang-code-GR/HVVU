
clc;
clear;
close all;
% load('D:\kmeans20231219.mat');
load('D:\workers000.mat');
load('D:\data.mat');
load('D:\node2000.mat');
tic;
% 在20轮循环中
A=0;
B=0;
C=0;
D=0;
E=0;
F=0;
G=0;
H=0;

for round = 1:2
     
    if round>1
        for i=1:length(workers)
            % 删除不需要的列
            workers(i).node_hash_new=[];
            workers(i).exchange_partner = [];
            workers(i).exchange_node = [];
        end
    end

    for i = 1:length(workers)
        % 获取第 i 个节点的 node_data 和 ID

        workerID_i = workers(i).ID(1);

        % 获取第 i 个节点的 node_data
        selectedNodes_i = workers(i).node_data;

        % 如果该节点有当前轮次的数据
        if length(selectedNodes_i) >= round
            % 选择第 round 个数据作为新的通信中心
            centerIndex = mod(round - 1, size(selectedNodes_i, 1)) + 1;
            center = selectedNodes_i(centerIndex, :);

            % 更新通信中心的位置
            workers(i).communication_range.center = center;

            % 检查通信范围是否重叠并交换 node_hash
            for j = 1:length(workers)
                if i ~= j % 避免自我比较
                    % 获取第 j 个节点的 node_data
                    selectedNodes_j = workers(j).node_data;
                    workerID_j = workers(j).ID(1);

                    % 检查该节点是否有足够的数据
                    if length(selectedNodes_j) >= round
                        % 检查通信范围是否重叠
                        distance = norm(workers(i).communication_range.center - workers(j).communication_range.center);
                        overlap = (distance <= (workers(i).communication_range.radius + workers(j).communication_range.radius));

                        if overlap


                            % 交换 node_hash 的前 'round' 行
                            rowsToSwap = min(round, size(workers(j).node_hash, 1));
                            % 追加交换后的数据到 node_hash_new 列
                            workers(i).node_hash_new = [workers(j).other_hash;workers(i).node_hash_new; workers(j).node_hash(1:rowsToSwap, :)];
                            workers(j).node_hash_new = [workers(i).other_hash;workers(j).node_hash_new; workers(i).node_hash(1:rowsToSwap, :)];
                            % 交换 node_hash 的前 'round' 行
                            rowsToSwap = min(round, size(workers(j).node_ID, 1));
                            % 追加交换后的node_ID到 exchange_node 列
                            workers(i).exchange_node = [workers(j).other_nodeID;workers(i).exchange_node; workers(j).node_ID(1:rowsToSwap, :)];
                            workers(j).exchange_node = [workers(i).other_nodeID;workers(j).exchange_node; workers(i).node_ID(1:rowsToSwap, :)];

                            % 交换 workers 的 ID
                            workers(i).exchange_partner = [workers(j).other_workers;workers(i).exchange_partner; repmat(workerID_j, rowsToSwap, 1)];
                            workers(j).exchange_partner = [workers(i).other_workers;workers(j).exchange_partner; repmat(workerID_i, rowsToSwap, 1)];




                        end
                    end
                end
            end
        end
    end


    % 假设workers是一个包含500个结构体的数组
    for i = 1:length(workers)
        % 复制列的内容
        workers(i).other_hash = [workers(i).other_hash;workers(i).node_hash_new];
        workers(i).other_workers = [workers(i).other_workers ;workers(i).exchange_partner];
        workers(i).other_nodeID =[ workers(i).other_nodeID;workers(i).exchange_node];



    end


    for i = 1:length(workers)
        exchangeNode = workers(i).other_nodeID;
        exchangePartner = workers(i).other_workers;
        nodeHashNew = workers(i).other_hash;

        % 将 exchangeNode 和 exchangePartner 合并为一个表
        dataTable = table(exchangeNode, exchangePartner, 'VariableNames', {'exchangeNode', 'exchangePartner'});

        % 获取唯一的行
        [uniqueRows, idx, ~] = unique(dataTable, 'stable', 'rows');

        % 找出被删除的行的索引
        deletedIndices = setdiff(1:size(dataTable, 1), idx);

        % 存储被删除的行索引
        %         workers(i).deleted_indices = deletedIndices;

        % 将结果重新赋值给原始变量
        workers(i). other_nodeID= uniqueRows.exchangeNode;
        workers(i).other_workers = uniqueRows.exchangePartner;

        % 这里假设 node_hash_new 是 cell 类型，直接赋值
        workers(i).other_hash = nodeHashNew;

        if ~isempty(deletedIndices)
            workers(i).other_hash(deletedIndices) = [];
        end
        % 找到 exchange_partner 中与当前节点相同 ID 的行的逻辑索引
        logicalIndexToDelete = workers(i).other_workers == workers(i).ID;

        % 使用逻辑索引删除行
        workers(i).other_hash(logicalIndexToDelete, :) = [];
        workers(i).other_nodeID(logicalIndexToDelete, :) = [];
        workers(i).other_workers(logicalIndexToDelete, :) = [];


    end


end       
%% 删除未评分的workers
% 循环遍历每个工人
for i = 1:length(workers)
    % 找到 'score' 矩阵中第二列等于0.5的行的索引
    idx1 = find(workers(i).score(:, 2) == 0.5);
    % idx2 = find(workers(i).ID==workers(i).score(1));
    % 从 'score' 中删除相应的行
    workers(i).score(idx1, :) = [];
    %   workers(i).score(idx2, :) = [];

end
for i = 1:length(workers)
    % 找到 'score' 矩阵中第二列等于0.5的行的索引
     idx2 = find(workers(i).ID==workers(i).score(:,1));

       workers(i).score(idx2, :) = [];

end

%%
tem=0;
for z=1:200
    for i=1:length(workers)
        if ~isempty(workers(i).score)
            for j=1:numel(workers(i).score)/2
                if workers(i).score(j,1)==z

                    tem=tem+1;
                    workers(z).score_com=workers(z).score_com+workers(i).score(j,2);

                end
            end
        end

    end
                  if tem==0;
                      tem=1;
                  end
     workers(z).score_com=workers(z).score_com/tem;
                 
    tem=0;
end


%% 创建一个数组用于存储排序结果
sortedResults = zeros(length(workers), 2);
sortedResults(:, 1) = [workers(:).ID];
sortedResults(:, 2) = [workers(:).score_com];
sortedResults = sortrows(sortedResults, -2);  % 按第二列降序排序

% 将排序结果存储到workers结构体的workers_sort列
for i = 1:length(workers)
    workers(i).workers_sort = sortedResults(i, :);
end



%%

 save('D:\workers.mat','workers');