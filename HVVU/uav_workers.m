clear;
load('D:\workers.mat');
load('D:\uav_node.mat');
for i = 1:length(uav_node)
    uav_node_ID(i,1)=uav_node(i).ID;
end

% 初始化计数器
counter = zeros(size(workers));

% 遍历每个 worker
for i = 1:numel(workers)
    % 获取当前 worker 的 node_ID
    node_ID = workers(i).node_ID;
    % 初始化匹配信息的 uav_ID 列
    workers(i).uav_ID = [];
    
    % 遍历当前 worker 的 node_ID
    for j = 1:numel(node_ID)
        % 获取当前 node_ID
        current_node_ID = node_ID(j);
        
        % 查找匹配的 uav_node_ID
        matching_indices = find(uav_node_ID == current_node_ID);
        
        % 如果有匹配，增加计数器，并记录对应的行数
        if ~isempty(matching_indices)
            counter(i) = counter(i) + 1;
            % 记录匹配信息到 uav_ID 列
            workers(i).uav_ID(end+1) = j;
        end
    end
end

% 输出每个 worker 匹配的数量
for i = 1:numel(counter)
    disp(['Worker ', num2str(i), ' matches: ', num2str(counter(i))]);
end


% 遍历每个 worker
for i = 1:numel(workers)
    if workers(i).malicious==1;
        F_data = 0;
    % 获取当前 worker 的 uav_ID
    uav_ID = workers(i).uav_ID;
    
    % 遍历当前 worker 的 uav_ID
    for j = 1:numel(uav_ID)
        % 获取当前 uav_ID
        current_uav_ID = uav_ID(j);
        
        % 获取当前 uav_ID 对应的 node_data_info 中的 double 表
        node_data = workers(i).node_data_info{current_uav_ID};
        
        % 检查是否有小于 0 的值
        if any(node_data < 0)
            F_data=F_data+1;
            disp(['Worker ', num2str(i), ', uav_ID ', num2str(current_uav_ID), ': There are negative values in the node data.']);
        else
            disp(['Worker ', num2str(i), ', uav_ID ', num2str(current_uav_ID), ': All values in the node data are non-negative.']);

        end
    end
if counter(i)==0;
    counter(i)=1;
end

    workers(i).verify_score=exp(-log(10)*(F_data/counter(i)));
    end
end


for i = 1:numel(workers)
    % 获取当前 worker 的 verify_score 列
    verify_score = workers(i).verify_score;
    
    % 将 NaN 值替换为数值 1
    verify_score(isnan(verify_score)) = 1;
    
    % 更新 workers 结构体中的 verify_score 列
    workers(i).verify_score = verify_score;
end

for i=1:length(workers)
    workers(i).Finally_score=workers(i).verify_score*workers(i).score_com;
end

for i=1:length(workers)
    workers(i).cov=((workers(i).Finally_score/workers(i).bid)*(length(workers(i).node_ID)/1000))*100%;
end



% 提取cov字段值
cov_values = [workers.cov];

% 对cov字段值进行排序并获取排序后的索引
[sorted_cov, sorted_index] = sort(cov_values, 'descend');

% 初始化sort列
[workers.sort] = deal(0);

% 将排序后的索引映射到原始workers数组，存储在sort列中
for i = 1:numel(workers)
    workers(i).sort = sorted_index(i);
end

% 显示结果，这里只是示例
disp([workers.sort]); % 显示排序后的sort列值


%% 计算bid
% 初始化前50个排名的workers的bid总和
total_bid = 0;

% 计算前50个排名的workers的bid总和
for i = 1:50
    total_bid = total_bid + workers(workers(i).sort).bid; % 累加对应的bid值
end

% 输出结果
disp(['前50个排名的workers的bid总和为: ', num2str(total_bid)]);



%% 区分恶意和正常

% 将workers转换为表以便操作
T = struct2table(workers);

% 找出malicious为0的行
non_malicious = T(T.malicious == 0, :);

% 找出malicious为1的行
malicious = T(T.malicious == 1, :);

% 创建新的结构体存储malicious为0的workers
non_malicious_workers.ID = non_malicious.ID;
non_malicious_workers.Finally_score = non_malicious.Finally_score;

% 创建新的结构体存储malicious为1的workers
malicious_workers.ID = malicious.ID;
malicious_workers.Finally_score = malicious.Finally_score;


