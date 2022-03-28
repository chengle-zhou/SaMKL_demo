function rho = DensityPeak(img,para)
% n * m
% calculate the Euclidean distence matrix
percent = para.percent;
Dist = pdist_le(img,img,'SAM');
% Dist = pdist2(img,img,'euclidean');
M = size(Dist,1);
Pos = round(M*(M-1)*percent/100);
tri_u = triu(Dist,1);
sda = sort(tri_u(tri_u~=0));
if Pos ~= 0
    dc = sda(Pos);     %pos����Ϊ0��sdaҲ����Ϊ��
else
    Pos = 1;
    dc = sda(Pos);
end
% fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);
switch para.method
        % Gaussian kernel
    case 'gaussian'
        rho = sum(exp(-(Dist./dc).^2),2)-1;
        % "Cut off" kernel
    case 'cut_off'
        rho = sum((Dist-dc)<0, 2);
end
% [~,ordrho]=sort(rho,'descend');     %%%%% ordrho�д�Ž�rho���Ӵ�С����֮�������ֵ
% % Compute delta
% % disp('Computing delta...');
% delta = zeros(size(rho));
% nneigh = zeros(size(rho));
% 
% delta(ordrho(1)) = -1;
% nneigh(ordrho(1)) = 0;
% for i = 2:size(Dist,1)
%     range = ordrho(1:i-1);
%     [delta(ordrho(i)), tmp_idx] = min(Dist(ordrho(i),range));
%     nneigh(ordrho(i)) = range(tmp_idx);        %%ÿһ��������һ��
% end
% delta(ordrho(1)) = max(delta(:));
% 
% % Decision graph, choose min rho and min delta
% rho_premnmx = mapminmax(rho', 0, 1);
% delta_premnmx = mapminmax(delta', 0, 1);
% gamma = rho_premnmx.*delta_premnmx;