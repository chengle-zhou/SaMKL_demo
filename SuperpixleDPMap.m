function DensityMap = SuperpixleDPMap(img,SuperLabels,para)

% ��ע�� �������ؿ���DP�ֲ��ܶȣ��Ӷ���ȡHSI���ܶ�ͼ

% img:ȫͼ��Ԫ����ֵ200 * 21025
% SuperLabels�������ؿ�ı�ǩ
% percent��DP�ضϾ���ٷֱ�

DensityMap = ones(size(SuperLabels));

 for k = 0:max(SuperLabels(:))
     super_index = find(SuperLabels == k);
     samples_per = img(:,super_index);
     rho = DensityPeak(samples_per',para); % n * m. n:numbers; m:dimension.
%      rho = rho./repmat(sqrt(sum(rho.*rho)),[size(rho,1) 1]); % unit norm 2
     DensityMap(super_index) = rho;
 end
