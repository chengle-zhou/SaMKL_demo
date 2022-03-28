function K = makekernel(x,xsup,kerneloption)

[n1 n2]=size(x);
[n n3]=size(xsup);
ps  =  zeros(n1,n);			% produit scalaire

[nk,nk2]=size(kerneloption);
    if nk ~=nk2
        if nk>nk2
            kerneloption=kerneloption';
        end;
    else
        kerneloption=ones(1,n2)*kerneloption;
    end;
    
    if length(kerneloption)~=n2 & length(kerneloption)~=n2+1 
        error('Number of kerneloption is not compatible with data...');
    end;
    
    
    metric = diag(1./kerneloption.^2);
    ps = x*metric*xsup'; 
    [nps,pps]=size(ps);
    normx = sum(x.^2*metric,2);
    normxsup = sum(xsup.^2*metric,2);
    ps = -2*ps + repmat(normx,1,pps) + repmat(normxsup',nps,1) ; 
    
    
    K = exp(-ps/2);