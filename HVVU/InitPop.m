%% 生成初始种群
function Chrom = InitPop(NIND,N)
%输入：
%NIND：种群大小
%N：个体染色体长度（城市个数）
%输出：初始种群
Chrom = zeros(NIND,N); % 定义存储种群的变量
for i = 1:NIND
    Chrom(i,:) = randperm(N);
end