clear;
load('D:\cluster.mat');
%%
numNodes = 40; % 总节点数
numSelected = 16; % 需要选择的节点数
% 从 1 到 numNodes 中随机选择 numSelected 个不重复的索引
selectedIndices = randperm(numNodes, numSelected);
% 根据选定的索引从 cluster 中获取选定的节点坐标
C = cluster(selectedIndices, :);
C(17,:)=0;
x = C(:,1);
y = C(:,2);
%%
NIND = 100;   %种群大小
MAXGEN = 100; %最大迭代次数
Pc = 0.9; %交叉概率，相当于基因遗传的时候染色体交叉
Pm = 0.05; %染色体变异
GGAP = 0.9; %这个是代沟，通过遗传方式得到的子代数为父代数*GGAP
D = Distance(C); %通过这个函数可以计算i,j两点之间的距离
N = size(D,1); %计算有多少个坐标点
%% 初始化种群
Chrom = InitPop(NIND,N); %100个随机排列
pause(0.0001)
%输出随机解的路线和总距离
disp('初始种群中的一个随机值')
OutputPath(Chrom(1,:));%其中一个个体
Rlength = PathLength(D,Chrom(1,:));
disp(['总距离:',num2str(Rlength)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
% 创建图形窗口用于实时绘制迭代过程的路线图
figure;
title('优化过程')
xlabel('城市横坐标')
ylabel('城市纵坐标')
xRange = [-320, 320];
yRange = [-320, 320];
set(gcf,'position',[360,55,720,720]);
hold on;
% 绘制初始种群的路线
% DrawPath(Chrom(1,:),C);
% drawnow;
%% 优化
gen = 0;
trace = zeros(1,MAXGEN);
ObjV = PathLength(D,Chrom);%计算当前路线长度，即上面随机产生的那些个体路径
preObjV = min(ObjV);%当前最优解
while gen<MAXGEN
    %计算适应度
    ObjV = PathLength(D,Chrom); %计算路线长度
    pause(0.0001);
    preObjV = min(ObjV);
    trace(1,gen+1)=preObjV;
    FitnV = Fintness(ObjV);
    %选择
    SelCh = Select(Chrom,FitnV,GGAP);
    %交叉操作
    SelCh = Recombin(SelCh,Pc);
    %变异
    SelCh = Mutate(SelCh,D,Pm);
    %重插入
    Chrom = Reins(Chrom,SelCh,ObjV);
    %逆转
    SelCh = Reverse(SelCh,D);
    gen = gen + 1;   
    % 实时绘制迭代过程的路线图
    clf;
    hold on;
    DrawPath(Chrom(1,:),C);
    title(['种群容量：' num2str(NIND) '     ' '迭代次数：' num2str(gen) '     ' '最优路径长度：' num2str(preObjV)]);
    drawnow;
end
% %画出最优解的路线图
ObjV = PathLength(D,Chrom);     %计算路线长度
[minObjV,minInd] = min(ObjV);
% figure(1);
% hold on;
% DrawPath(Chrom(minInd(1),:),C);
figure();
xRange = [-320, 320];
yRange = [-320, 320];
set(gcf,'position',[360,55,720,720]);
plot([1:MAXGEN],trace(1,:));
title('距离变化趋势')
xlabel('迭代次数')
ylabel('距离')

%% 输出最优解的路线和距离
% disp('最优解:')
p = OutputPath(Chrom(minInd(1),:));
p = str2num(p);
disp(['旅行商走过的总距离:',num2str(ObjV(minInd(1)))]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')



%%
% 按照随机序列 p 的顺序重新排序节点坐标 C
C_new = C(p, :);
%绘制连接节点的箭头并记录每条线的坐标
figure(1);
hold on;
line_coords = zeros(size(C_new, 1)-1, 4);
for i = 1:size(C_new, 1)-1
    x = [C_new(i, 1), C_new(i+1, 1)];
    y = [C_new(i, 2), C_new(i+1, 2)];
    arrow_x = x(2) - x(1);
    arrow_y = y(2) - y(1);
    quiver(x(1), y(1), arrow_x, arrow_y, 0, 'Color', 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'LineStyle', '-', 'MarkerSize', 2, 'MarkerEdgeColor', 'b');
    line_coords(i, :) = [x, y];
end
figure(1);
hold on;





