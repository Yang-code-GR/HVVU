
%% 生成
% 节点坐标文档
clc
clear all
close all

%%
R  = 300;   %生成节点的坐标范围（-R，R）
N = 1000; %节点个数
number = 1;
fid = fopen('D:\MatLab\mobile crowdsensing\network300.txt','w');
while (number<=N)
    node_x = rand*2*R -R;
    node_y = rand*2*R -R;
    %      if sqrt(node_x*node_x + node_y* node_y) <=R
    line1 = ['WSN.node[',num2str(number) ,'].x=' ,num2str(node_x)];
    line2 = ['WSN.node[',num2str(number) ,'].y=' ,num2str(node_y)];
    fprintf(fid,'%s\r\n',line1);
    fprintf(fid,'%s\r\n',line2);
    number = number + 1;
    %      end

end
fclose(fid);
%%
sensornum=2000;  % 节点个数
node_x = [];
node_y = [];
n=1;  % 控制结构体node 的序号
fid = fopen('D:\MatLab\mobile crowdsensing\network300.txt','rt');
while ~feof(fid)
    node(n).ID=n;            % 用结构体node存放每个节点的ID


    line1 = fgetl(fid);      % fgetl读取文件中的行，并删除换行符
    line2 = fgetl(fid);
    ps = regexp(line1,'=');  % regexp匹配正则表达式（区分大小写）%找等于号在line1的几处开始
    ps = ps +1;
    str1 = line1(ps:end);    % 从ps位置到结尾的字符串赋给str1
    str2 = line2(ps:end);
    x = str2num(str1);       % str2num - 将字符数组或字符串转换为数值数组
    y = str2num(str2);
    node_x = [node_x,x];     % 循环更新一维数组node_x，新元素内容放后面
    node_y = [node_y,y];
    node(n).x=node_x(n);     % 用结构体node存放每个节点的x坐标   node(1).x   node(2).x   node(3).x  node(4).x  ......
    node(n).y=node_y(n);     % 用结构体node存放每个节点的y坐标   node(1).y   node(2).y   node(3).y  node(4).y  ......

    node(n).index_cluster=0;
    %     node(n).data=0;
    %     node(n).data=100*rand();
    num_data = randi([15, 20]);
    data = 100*rand(1,num_data);
    node(n).data={data};
    node(n).hash=0;
    n=n+1;
end

 %% 绘制节点分布图 
figure
hold on;
% axis([-320 320 -320 320]);             %设置显示范围。
xRange = [-320, 320];
yRange = [-320, 320];
set(gcf,'position',[360,55,720,720]);  %设置图窗大小,窗口大小[左边距，下边距，图窗高，图窗宽]

title('固定传感器节点分布图');
for i = 1:length(node)
    pt = scatter(node(i).x,node(i).y);
    pt.Marker = '.';
    pt.MarkerFaceColor = 'b';  % '0.9333    0.8353    0.7176';
    pt.MarkerEdgeColor = 'b';  % '0.9333    0.8353    0.7176';
    pt.SizeData  = 200;
    bh = text(node(i).x,node(i).y,num2str(node(i).ID));%,, ); %text - 向数据点添加文本描述  num2str - 将数字转换为字符数组
    bh.FontSize = 5;                        % 字体大小
    bh.HorizontalAlignment = 'center';      % 水平相对于位置点
    bh.VerticalAlignment = 'top';           % 垂直相对于位置点
    bh.Color = 'black ';
    

end

% ****** 标记数据中心，坐标（0,0)
s = scatter(0,0,'filled');
s.Marker = 'pentagram';
s.MarkerFaceColor = 'red';
s.SizeData  = 150;
text(0,0,'MCS平台','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','cap', 'Color','black');
title('固定传感器节点分布图');



%% 计算数据包的哈希值
% 导入java的MessageDigest类
import java.security.*;

% 初始化MessageDigest为SHA-256哈希
md = MessageDigest.getInstance('SHA-256');

for i = 1:length(node)
    % 获取第五列的数据并转换为一个字符串
    % 假设cell数组中的数据都是数值型的
    data = strjoin(cellfun(@num2str, node(i).data, 'UniformOutput', false), ',');
    
    % 计算哈希值
    md.update(uint8(data));
    hashValue = md.digest();
    
    node(i).hash = {hashValue'};
end
%% 保存相关mat文件
save('D:\node2000.mat','node');



