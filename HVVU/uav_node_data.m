load('D:\node2000.mat');
%% 记录uav采集的坐标点
uav_node = struct([]);
% 为每个work变量分配名字和ID
for i = 1:[]
    uav_node(i).ID = i;
    uav_node(i).node_x=0;
    uav_node(i).node_y=0;
    uav_node(i).node_index_cluster=0;
    uav_node(i).node_data=0;
    uav_node(i).node_hash=0;
end
% 提取C和new_addcluster在cluster中的索引标号
C_indices = find(ismember(cluster, C, 'rows'));
new_addcluster_indices = find(ismember(cluster, new_addcluster, 'rows'));
uav_cluster = [C_indices; new_addcluster_indices];
m=1;
%将node信息存储到uav中
for i=1:length(uav_cluster)
    for j=1:length(node)
        if(node(j).index_cluster==uav_cluster(i))
            uav_node(m).ID=node(j).ID;
            uav_node(m).node_x=node(j).x;
            uav_node(m).node_y=node(j).y;
            uav_node(m).node_index_cluster=node(j).index_cluster;
            uav_node(m).node_data=node(j).data;
            uav_node(m).node_hash=node(j).hash;
            m=m+1;
        end
    end
end
 save('D:\uav_node.mat','uav_node');