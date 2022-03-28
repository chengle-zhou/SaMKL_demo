function [indexes]=train_random_select(y,train_num)
% function to ramdonly select training samples and testing samples from the
% whole set of ground truth.
% alltrain is the ground truth

K = max(y);

% generate the  training set£¨²úÉúÑµÁ·¼¯£©
indexes = [];
indexes_c=[];

% Value = [22,22,22,22,22,22,22,22,22,22,22,22,22];% 10%(1056)
Value = train_num;% 10%(1056)
% Value = [20,20,20,20,20,20,20,20,20,20,20,20,20];% 10%(1056)
% Value = [10,10,10,10,10,10,10,10,10,10,10,10,10];% 10%(1056)
for i=1:K
    index1 = find(y == i);
    per_index1 = randperm(length(index1));   
    Number=per_index1(1:Value(i));
    indexes_c=[indexes_c;index1(Number)'];   
end  
  indexes = indexes_c(:);