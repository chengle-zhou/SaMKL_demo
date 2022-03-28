function [result]=FusionTwo(label)
correct = zeros(1,size(label,2));
tol =size(label,1);
result= zeros(1,tol);
for i =1:tol
    result(i) = majorityvote(label(i,:));
    [~,ind]=find(label(i,:)==result(i));
    if(ind~=0)
        correct(ind) =correct(ind)+1;
    end
end

[~,id] = find(result==0);
[~,l] = max(correct);
result(id)=label(id,l);
end