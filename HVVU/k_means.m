%%
 clear all
 load('D:\node2000.mat');
%%
for i = 1:length(node)
    data(i,1) = node(i).x;
    data(i,2) = node(i).y;
end
%  data=[node_x;node_y]';
cluster_num = 40;
[index_cluster,cluster] = kmeans_func(data,cluster_num);

%% 标记节点属于哪个簇
for i=1:length(index_cluster)
    node(i).index_cluster=index_cluster(1,i);
end

% 画出聚类效果
figure(1);
hold on;
axis([-320 320 -320 320]);             %设置显示范围。
set(gcf,'position',[360,55,720,720]);  %设置图窗大小,窗口大小[左边距，下边距，图窗高，图窗宽]
title('节点进行k-means分区图');

a=unique(index_cluster); %找出分类出的个数
C=cell(1,length(a));
for i=1:length(a)
   C(1,i)={find(index_cluster==a(i))};
end
for j=1:cluster_num
    data_get=data(C{1,j},:);
    scatter(data_get(:,1),data_get(:,2),50,'filled','MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.4);
    hold on
end

%% 绘制聚类中心
plot(cluster(:,1), cluster(:,2), 'k^', 'LineWidth', 4, 'MarkerFaceColor', 'black', 'MarkerSize', 2);
hold on;

% 绘制簇头序号
for i = 1:size(cluster, 1)
    x = cluster(i, 1);
    y = cluster(i, 2);
    text(x, y-10, num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 8, 'Color', 'black');
end
%%
% ****** 标记数据中心，坐标（0,0)
s = scatter(0,0,'filled');
s.Marker = 'pentagram';
s.MarkerFaceColor = 'red';
s.SizeData  = 150;
text(0,0,'MCS平台','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','cap', 'Color','black'); 
title('节点进行k-means分区图');


%%
 save('D:\node2000.mat','node');
 save('D:\data.mat','data');
 save('D:\cluster.mat','cluster');

