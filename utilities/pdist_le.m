function dist = pdist_le(X,Y,metrics)
% X: n * m matric, n is the number of vector, m is the number of dimension
% Y: n * m matric, n is the number of vector, m is the number of dimension
% 所有距离值与欧式几何距离用法相同，不需要作任何调整

if strcmp('ED',metrics)
    ed = pdist2(X,Y,'euclidean'); % Euclidean (ED)
    dist = ed;
    
elseif strcmp('CC',metrics)
    cc = pdist2(X,Y,'correlation');  % Correlation Coefficient (CC)
    dist = cc;
    
elseif strcmp('SAM',metrics)
    sam = acos(1 - pdist2(X,Y,'cosine'));  % Spectral Angle Match (SAM)
    dist = sam;
    
elseif strcmp('SGA',metrics)
    % Spectral Gradient Angle (SGA)
    x = X(:,2:end) - X(:,1:end-1);
    y = Y(:,2:end) - Y(:,1:end-1);
    sga = acos(1 - pdist2(x,y,'cosine'));
    dist = sga;
    
elseif strcmp('SID',metrics)
    % Spectral Information Divergence (SID)
    p = X./repmat(sum(X,2),[1,size(X,2)]); % spetral probability matric
    q = Y./repmat(sum(Y,2),[1,size(Y,2)]);
    Ix = -log(p); Iy = -log(q);  % self-information
    Ix_temp = kron(Ix,ones(size(Iy,1),1));
    p_ext = kron(p,ones(size(q,1),1));
    Iy_temp = repmat(Iy,[size(Ix,1),1]);
    q_ext = repmat(q,[size(p,1),1]);
    Dxy = sum(p_ext.*(Iy_temp - Ix_temp),2); % relative entropy
    Dyx = sum(q_ext.*(Ix_temp - Iy_temp),2);
    sid = reshape(Dxy+Dyx,[size(X,1),size(Y,1)]);
    dist = sid;
end


