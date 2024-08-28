clear;
load('D:\data.mat');
load('D:\node2000.mat');
%创建一个结构体数组来存储500个work变量
workers = struct( 'ID', cell(1, 200), 'name', cell(1, 200),'malicious',cell(1,200));
% 为每个work变量分配名字和ID
for i = 1:length(workers)
    workers(i).ID = i;
    workers(i).name = sprintf('work_%d', i);
    workers(i).malicious=0;
    workers(i).node_ID=0;
    workers(i).node_data=0;
    workers(i).node_data_info=0;
    workers(i).node_hash=0;
    workers(i).communication_range = struct('center', [randi([-320, 320]), randi([-320, 320])], 'radius', randi([3, 5]));
    workers(i).selectedNodes = [];
    workers(i).selectedIndices = [];
    workers(i).other_hash=[];
    workers(i).other_workers=[];
    workers(i).other_nodeID=[];

    workers(i).node_hash_new = [];
    workers(i).exchange_partner = [];
    workers(i).exchange_node = [];
    workers(i).verify_score = 1;
    workers(i).uav_ID = 0;
    workers(i).bid= 0;

end
%%
for i = 1:numel(workers)
    % 生成0.8到1.2之间的随机数
    random_bid = 0.8 + rand() * (1.2 - 0.8);
    
    % 将随机数赋值给bid字段
    workers(i).bid = random_bid;
end
%% 标记10%—20%的workers为恶意的
n = round(randi([40,40]) / 100 * length(workers));
idx = randperm(length(workers), n);
[workers(idx).malicious]=deal(1);

%%
% 绘制最后一个worker的通信范围
lastWorker = workers(end);  % 获取最后一个worker
figure(1);
center = lastWorker.communication_range.center;
radius = lastWorker.communication_range.radius;
theta = linspace(0, 2*pi, 100);
x = center(1) + radius * cos(theta);
y = center(2) + radius * sin(theta);   
plot(x, y);

%%
% 为每个worker选择15到20个节点
for i = 1:length(workers)
    center = workers(i).communication_range.center;
    % 计算节点到center的欧氏距离
    distances = vecnorm(data - center, 2, 2);
    % 根据距离筛选节点
    selectedIndices = find(distances <= 100);
    selectedNodes = data(selectedIndices, :);
    % 随机选择15到20个节点
    numNodes = randi([14, 15]);
    if numel(selectedIndices) > numNodes
        selectedIndices = selectedIndices(randperm(numel(selectedIndices), numNodes));
        selectedNodes = data(selectedIndices, :);
    end
    % 存储选中的节点数据到worker中
    workers(i).selectedNodes = selectedNodes;
    workers(i).selectedIndices = selectedIndices;
end


%% 存储workers收集的数据信息
ID = [node.ID]';
data_info=[node.data]';
hash=[node.hash]';
for i=1:length(workers)
    selected_nodes = workers(i).selectedIndices;
    % 提取节点的坐标、ID、和数据信息
    selected_data = data(selected_nodes, :);
    selected_ID = ID(selected_nodes);
    selected_data_info = data_info(selected_nodes);
    selected_hash=hash(selected_nodes);
    workers(i).node_ID=selected_ID;
    workers(i).node_data=selected_data;
    workers(i).node_data_info=selected_data_info;
    workers(i).node_hash=selected_hash;
%         indices = setdiff(1:length(workers), i);
%     workers(i).score = [indices' ones(numel(indices), 1)*0.5];
indices = 1:length(workers);
workers(i).score = [indices' ones(numel(indices), 1) * 0.5];
 workers(i).score_com=0;
 workers(i).workers_sort = 0;
 workers(i).Finally_score=0;
workers(i).cov= 0;
workers(i).sort= 0;
end

%% worekrs提供虚假数据
for i = 1:length(workers)
    % 检查是否为恶意节点
    if workers(i).malicious == 1
        % 获取cell表
        cellTable = workers(i).node_data_info;
        % 随机选择3-5个double表
        numTables = randi([14, 14]);
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
            dataTable(selectedData) = -1 * dataTable(selectedData);
            % 保存更改后的double表
            cellTable{selectedTables(j)} = dataTable;
        end
        % 保存更改后的cell表
        workers(i).node_data_info = cellTable;
    end
end
%%
% 导入java的MessageDigest类
import java.security.*;
% 初始化MessageDigest为SHA-256哈希
md = MessageDigest.getInstance('SHA-256');
% 遍历workers结构体
for i = 1:length(workers)
    % 获取第六列的cell表
    cellTable = workers(i).node_data_info;
    % 遍历cell表
    for j = 1:length(cellTable)
        % 获取double表
        dataTable = cellTable{j};
        % 如果double表中有数据小于0
        if any(dataTable(:) < 0)
            % 将double表转换为字符串
            dataStr = sprintf('%f', dataTable(:)');
            % 计算哈希值
            md.update(uint8(dataStr));
            hashValue = md.digest()';
            % 将哈希值存储到第七列的int8表中
            workers(i).node_hash{j} = int8(hashValue);
        end
    end
end

save('D:\workers000.mat','workers');