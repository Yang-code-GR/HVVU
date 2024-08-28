
% function [outputA rg1,outputArg2] = kmeans_func(inputArg1,inputArg2)
% %KMEANS_FUNC 此处显示有关此函数的摘要
% %   此处显示详细说明
% outputArg1 = inputArg1;
% outputArg2 = inputArg2;
% end
% 



function [index_cluster,cluster] = kmeans_func(data,cluster_num)
%% 原理推导Kmeans聚类算法
 [m,n]=size(data);                                     %m=300,n=2
 cluster=data(randperm(m,cluster_num),:);%从m个点中随机选择cluster_num个点作为初始聚类中心点


%%
epoch_max=1000;%最大次数
therad_lim=0.001;%中心变化阈值
epoch_num=0;
while(epoch_num<epoch_max)
    epoch_num=epoch_num+1;
    % distance1存储每个点到各聚类中心的欧氏距离
    for i=1:cluster_num
        distance=(data-repmat(cluster(i,:),m,1)).^2;
         distance1(:,i)=sqrt(sum(distance'));
    end
    [~,index_cluster]=min(distance1');%index_cluster取值范围1~cluster_num
    % cluster_new存储新的聚类中心
    for j=1:cluster_num
        cluster_new(j,:)=mean(data(find(index_cluster==j),:));
    end
    %如果新的聚类中心和上一轮的聚类中心距离和大于therad_lim，更新聚类中心，否则算法结束
    if (sqrt(sum((cluster_new-cluster).^2))>therad_lim)
        cluster=cluster_new;
    else
        break;
    end
end
end

%%

