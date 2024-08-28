function NewChrIx = Sus(FitnV,Nsel)
%输入：
%FitnV 个体的是适应度值
%Nsel 被选个体的数目
%输出：
%NewChrIx 被选择个体的索引号
[Nind,ans] = size(FitnV);%Nind为FitnV的行数也就是个体数 ans为列数1
cumfit = cumsum(FitnV);%对适应度累加 例如 1 2 3 累加后 1 3 6 用来计算累积概率
trials = cumfit(Nind)/Nsel * (rand + (0:Nsel-1)');%cumfit(Nind)表示的是矩阵cumfit的第Nind个元素 A.'是一般转置，A'是共轭转置 rand返回一个在区间 (0,1) 内均匀分布的随机数
%cumfit(Nind)/Nsel平均适应度 * （rand +(0:Nsel-1)'）从0开始到89的转置矩阵（行矩阵变列矩阵）加上每一项加上一个0-1的随机数
%生成随机数矩阵 用来筛选
Mf = cumfit(:,ones(1,Nsel));%将生成的累积概率 复制90份 生成一个100*90的矩阵
Mt = trials(:,ones(1,Nind))';
[NewChrIx,ans] = find(Mt<Mf & [zeros(1,Nsel);Mf(1:Nind-1,:)]<= Mt);%寻找满足条件的个体 返回返回数组 X 中每个元素的行和列下标
[ans,shuf] = sort(rand(Nsel,1));%生成Nsel*1的随机数矩阵  按升序对 A 的元素进行排序 返回选择的shuf 随机打乱个体顺序 保证后续遗传算子操作的随机性
NewChrIx = NewChrIx(shuf);%返回shuf索引的矩阵元素