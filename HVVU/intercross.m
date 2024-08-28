function [a,b] = intercross(a,b)
%输入：
%a和b为两个待交叉的个体
%输出：
%a和b为交叉后得到的两个个体
L = length(a);
%随机产生交叉区段
r1 = randsrc(1,1,[1:L]); % 这里先随机选出两个位置，位置不能超过
r2 = randsrc(1,1,[1:L]); % 
if r1~=r2
    a0 = a;
    b0 = b;
    s = min([r1,r2]);
    e = max([r1,r2]);
    for i = s:e
        a1 = a;
        b1 = b;
        %第一次互换
        a(i) = b0(i);
        b(i) = a0(i);
        %寻找相同的城市
        x = find(a==a(i)); % 如果有相同的城市，x会得到包含i的两个值，y同理
        y = find(b==b(i));
        %第二次互换产生新的解
        i1 = x(x~=i);      % 将位置不是i但相同的城市标记出来
        i2 = y(y~=i);
        if ~isempty(i1)
            a(i1)=a1(i);
        end
        if ~isempty(i2)
            b(i2)=b1(i);   % 注意，原文这里有误，应该是b(i2)
        end
    end
end
% 这里增加一段代码，r1=r2时，两个个体只在一点交叉
if r1 == r2
    a0 = a;
    b0 = b;
    a(r1) = b0(r1);
    b(r1) = a0(r1);
    x = find(a==a(r1));
    y = find(b==b(r1));
    i1 = x(x~=r1);
    i2 = y(y~=r1);
    if ~isempty(i1)
        a(i1) = a0(r1);
    end
    if ~isempty(i2)
        b(i2) = b0(r1);
    end
end