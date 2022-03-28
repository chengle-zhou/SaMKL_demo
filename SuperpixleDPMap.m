function DensityMap = SuperpixleDPMap(img,SuperLabels,para)

% 备注： 按超像素块求DP局部密度，从而获取HSI的密度图

% img:全图像元光谱值200 * 21025
% SuperLabels：超像素块的标签
% percent：DP截断距离百分比

DensityMap = ones(size(SuperLabels));

 for k = 0:max(SuperLabels(:))
     super_index = find(SuperLabels == k);
     samples_per = img(:,super_index);
     rho = DensityPeak(samples_per',para); % n * m. n:numbers; m:dimension.
%      rho = rho./repmat(sqrt(sum(rho.*rho)),[size(rho,1) 1]); % unit norm 2
     DensityMap(super_index) = rho;
 end
