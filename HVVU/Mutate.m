function SelCh = Mutate(SelCh,D,Pm)
%变异操作
%输入：
%SelCh  被选择的个体
%Pm  变异概率
%输出：
%SelCh  变异后的个体
index = SelCh;
col = size(SelCh,2); %返回SelCh的列数
%lenSelCh = [];
lenSelCh = PathLength(D,SelCh);
[NSel,L] = size(SelCh);
for i = 1:NSel
    if Pm >= rand
        R = randperm(L);
        index(i,R(1:2)) = index(i,R(2:-1:1)); % 将个体i中R(1)和R(2)这两个位置的城市互换
        p = [index(i,:) index(i,1)];
        i1 = p(1:end-1);
        i2 = p(2:end);
        DIndexi = sum(D((i1-1)*col+i2));              % 计算出变异后个体的路径距离
        if DIndexi < lenSelCh(i)                 % 如果变异后路径距离比变异前更小，则保留变异
            SelCh(i,:) = index(i,:);
        end
    end
end
