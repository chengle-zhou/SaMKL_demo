% =========================================================================
% Structure-Aware Multikernel Learning for Hyperspectral Image Classification
% MATLAB demo:
%
% Reference
% [1] C. Zhou, B. Tu, N. Li, W. He and A. Plaza, "Structure-Aware Multikernel Learning for Hyperspectral Image Classification," 
% in IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing, 
% vol. 14, pp. 9837-9854, 2021, doi: 10.1109/JSTARS.2021.3111740.
%
% For any questions, email me by chengle_zhou@foxmail.com
%=========================================================================


close all; clear all; clc

addpath utilities
addpath data

load IndiaP
load Indian_pines_gt
load Indian_PC1_EPs
load Indian_PC2_EPs
load Indian_PC3_EPs

Groundtruth = indian_pines_gt;

no_class = max(Groundtruth(:));
% record the indexs of background pixels
[bagrX, bagrY] = find(double(Groundtruth) == 0);

[rows, cols, band_ori] = size(img);
img_ori = img;
img = reshape(img, rows * cols, band_ori);
img_ori = compute_mapping(img,'PCA',25);     %
img_ori = reshape(img_ori, rows, cols, 25);

% PCA reduce dimension
img_pca = compute_mapping(img,'PCA',3);     %
[img_pca] = scale_new(img_pca);
superpixel_data = reshape(img_pca,[rows, cols, 3]);
gabor_input = double(superpixel_data);
superpixel_data=mat2gray(superpixel_data);
superpixel_data=im2uint8(superpixel_data);

% superpixels
if(~exist('superpixel_labels.mat'))
number_superpixels = 150;
lambda_prime = 0.8;  sigma = 10;  conn8 = 1;
SuperLabels = mex_ers(double(superpixel_data),number_superpixels,lambda_prime,sigma,conn8);
    save superpixel_labels SuperLabels
else
    load superpixel_labels
end

% PC feature fusion
[r,c,b] = size(Indian_PC1_EPs);
img_1 = reshape(Indian_PC1_EPs,r*c,b);
img_2 = reshape(Indian_PC2_EPs,r*c,b);
img_3 = reshape(Indian_PC3_EPs,r*c,b);
img_ep = img_1 + img_2 + img_3;
img_EP = reshape(img_ep,r,c,b);

% Gabor feature extraction
u = 5; v = 8; m = 55; n = 55;
% [img_rgb1] = scale_new(img_RGB);
gaborArray = gaborFilterBank(u,v,m,n);
[ ~,img_gabor] = gaborFeatures(gabor_input, gaborArray, r, c);

rate_k = 0.7;
% Generate mean feature map
[mean_matric,~,~] = K_mean_feature(img_ori,SuperLabels,rate_k);
[EP_matric,~,~] = K_mean_feature(img_EP,SuperLabels,rate_k);
[gabor_matric,~,~] = K_mean_feature(img_gabor,SuperLabels,rate_k);


train_num = [3,13,9,3,5,6,3,5,3,8,25,6,3,11,4,3]; % the rate of training is set to 1.0% of ground thruth
indexes = train_random_select(GroundT(2,:),train_num);
train_SL = GroundT(:,indexes);
test_SL = GroundT;
test_SL(:,indexes) = [];

train_samples = img(train_SL(1,:),:);
train_labels = train_SL(2,:);
test_samples = img(test_SL(1,:),:);
GroudTest = test_SL(2,:);

% Generate spectral feature
train_img = zeros(rows,cols);
train_img(train_SL(1,:)) = train_SL(2,:);

in_param.nfold = 5;  % cross validation for parameters
in_param.alpha = 0.07;
in_param.beta = 1 - in_param.alpha;
[results1, ~] = classify_svm_mykernel(img_ori,mean_matric,train_img,in_param);

in_param.alpha = 0.04;
in_param.beta = 1 - in_param.alpha;
[results2, ~] = classify_svm_mykernel(img_ori,EP_matric,train_img,in_param);

in_param.alpha = 0.46;
in_param.beta = 1 - in_param.alpha;
[results3, ~] = classify_svm_mykernel(img_ori,gabor_matric,train_img,in_param);

labels = [results1,results2,results3];
Tlabel = labels(test_SL(1,:),:);

% Fusion Stage Two
fusion_result = FusionTwo(Tlabel);

[OA,kappa,AA,CA] = calcError(test_SL(2,:)-1,fusion_result-1,[1:no_class])

% Display the classification
result = zeros(rows, cols);
result(test_SL(1,:))=fusion_result;
result(train_SL(1,:))=train_SL(2,:);
SG_SSIFresults = reshape(result,[rows,cols,1]);
SG_SSIFMap=label2color(SG_SSIFresults,'india');
figure,imshow(SG_SSIFMap);


