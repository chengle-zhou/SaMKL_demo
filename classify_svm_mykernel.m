function [ypred_f, out_param] = classify_svm_mykernel(varargin)
%CLASSIFYSVM Classify with libSVM an image
%
%		[outdata, out_param] = classify_svm(img, train, opt)
%
% INPUT
%   img    Multispectral image to be classified.
%   train  Training set image (zero is unclassified and will not be
%           considered).
%   opt    input parameters. Structure with each field correspondent to a
%           libsvm parameter
%           Below the availabel fields. The letters in the brackets corresponds to the flags used in libsvm:
%             "svm_type":	(-s) set type of SVM (default 0)
%                   0 -- C-SVC
%                   1 -- nu-SVC
%     	            2 -- one-class SVM
%     	            3 -- epsilon-SVR
%     	            4 -- nu-SVR
%             "kernel_type": (-t) set type of kernel function (default 2)
%                   0 -- linear: u'*v
%                   1 -- polynomial: (gamma*u'*v + coef0)^degree
%                   2 -- radial basis function: exp(-gamma*|u-v|^2)
%                   3 -- sigmoid: tanh(gamma*u'*v + coef0)
%                   4 -- precomputed kernel (kernel values in training_instance_matrix)
%          3   "kernel_degree": (-d) set degree in kernel function (default 3)
%             "gamma": set gamma in kernel function (default 1/k, k=number of features)
%           1  "coef0": (-r) set coef0 in kernel function (default 0)     1
%             "cost": (-c) set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
%             "nu": (-n) parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
%             "epsilon_regr": (-p) set the epsilon in loss function of epsilon-SVR (default 0.1)
%             "chache": (-m) set cache memory size in MB (default 100)
%             "epsilon": (-e) set tolerance of termination criterion (default 0.001)
%             "shrinking": (-h) whether to use the shrinking heuristics, 0 or 1 (default 1)
%        1     "probability_estimates": (-b) whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
%             "weight": (-wi) set the parameter C of class i to weight*C, for C-SVC (default 1)
%             "nfold": (-v) n-fold cross validation mode
%             "quite": (-q) quiet mode (no outputs)
%           For setting other default values, modify generateLibSVMcmd.
%
% OUTPUT
%   outdata    Classified image
%   out_param  structure reports the values of the parameters
%
% DESCRIPTION
% This routine classify an image according to the training set provided
% with libsvm. By default, the data are scaled and normalized to have unit
% variance and zero mean for each band of the image. If the parameters
% defining the model of the svm (e.g., the cost C and gamma) are not
% provided, the function call the routin MODSEL and which optimizes the
% parameters. Once the model is trained the image is classified and is
% returned as output.
%
% SEE ALSO
% EPSSVM, MODSEL, GETDEFAULTPARAM_LIBSVM, GENERATELIBSVMCMD, GETPATTERNS

% Mauro Dalla Mura
% Remote Sensing Laboratory
% Dept. of Information Engineering and Computer Science
% University of Trento
% E-mail: dallamura@disi.unitn.it
% Web page: http://www.disi.unitn.it/rslab

% Parse inputs
if nargin == 4
    data_set = varargin{1};
    train = varargin{3};
    data_set2 = varargin{2};
    in_param = varargin{4};
%     in_param = struct;
%     n_kernels = 0;
%    in_param.kernel_type = 2;   % default RBF
elseif nargin == 5
    data_set = varargin{1};
    train = varargin{3};
    data_set2 = varargin{2};
   in_param = varargin{5};
%     n_kernels = 1;
% % elseif nargin ==4
% %     data_set = varargin{1};
% %     train = varargin{2};
% %     in_param = varargin{4};
% %     data_set2 = varargin{3};
% %     n_kernels = 1;
end

% Default Parameters - Scaling the data
scaling_range = true;       % Scale each feature of the data in the range [-1,1]
scaling_std = true;         % Scale each feature of the data in order to have std=1

% Read in_param
if (isfield(in_param, 'scaling_range'))
    scaling_range = in_param.scaling_range;       % scaling_range
else
    in_param.scaling_range = scaling_range;
end
if (isfield(in_param, 'scaling_std'))
    scaling_std = in_param.scaling_std;           % scaling_range
else
    in_param.scaling_std = scaling_std;
end
% ------------------------ dataset1

[nrows ncols nfeats] = size(data_set);
Ximg = double(reshape(data_set, nrows*ncols, nfeats));

% Transform training set in a format compliant to RF
[X, L] = getPatterns(data_set, train);
nclasses = length(unique(L));


[X,row_factor] = removeconstantrows(X);   % Remove redundant features
Ximg = Ximg(:,row_factor.keep); % Remove redundant features

% ========= Preprocessing =========
% Scale each feature of the data in the range [-1,1]
if (scaling_range)
    [X,scale_factor] = mapminmax(X);   % Perform the scaling on the training set
    nfold = 10;
    nelem = round(size(Ximg,1)/nfold);
    for i=1:nfold-1                     % Apply the same scaling on the whole set
        Ximg((i-1)*nelem+1:i*nelem,:) = (mapminmax('apply',Ximg((i-1)*nelem+1:i*nelem,:)',scale_factor))';
    end
    Ximg((nfold-1)*nelem+1:end,:) = (mapminmax('apply',Ximg((nfold-1)*nelem+1:end,:)',scale_factor))';
end
% Scale each feature in order to have std=1
if (scaling_std)
    [X,scale_factor] = mapstd(X);  % Perform the scaling on the training set
    nfold = 10;
    nelem = round(size(Ximg,1)/nfold);
    for i=1:nfold-1                 % Apply the same scaling on the whole set
        Ximg((i-1)*nelem+1:i*nelem,:) = (mapstd('apply',Ximg((i-1)*nelem+1:i*nelem,:)',scale_factor))';
    end
    Ximg((nfold-1)*nelem+1:end,:) = (mapstd('apply',Ximg((nfold-1)*nelem+1:end,:)',scale_factor))';
end


% ------------------------ dataset2

[nrows ncols nfeats2] = size(data_set2);
Ximg2 = double(reshape(data_set2, nrows*ncols, nfeats2));

% Transform training set in a format compliant to RF
[X2, L2] = getPatterns(data_set2, train);
nclasses = length(unique(L2));

[X2,row_factor2] = removeconstantrows(X2);   % Remove redundant features
Ximg2 = Ximg2(:,row_factor2.keep); % Remove redundant features

% ========= Preprocessing =========
% Scale each feature of the data in the range [-1,1]
if (scaling_range)
    [X2,scale_factor2] = mapminmax(X2);   % Perform the scaling on the training set
    nfold = 10;
    nelem = round(size(Ximg2,1)/nfold);
    for i=1:nfold-1                     % Apply the same scaling on the whole set
        Ximg2((i-1)*nelem+1:i*nelem,:) = (mapminmax('apply',Ximg2((i-1)*nelem+1:i*nelem,:)',scale_factor2))';
    end
    Ximg2((nfold-1)*nelem+1:end,:) = (mapminmax('apply',Ximg2((nfold-1)*nelem+1:end,:)',scale_factor2))';
end
% Scale each feature in order to have std=1
if (scaling_std)
    [X2,scale_factor2] = mapstd(X2);  % Perform the scaling on the training set
    nfold = 5;
    nelem = round(size(Ximg2,1)/nfold);
    for i=1:nfold-1                 % Apply the same scaling on the whole set
        Ximg2((i-1)*nelem+1:i*nelem,:) = (mapstd('apply',Ximg2((i-1)*nelem+1:i*nelem,:)',scale_factor2))';
    end
    Ximg2((nfold-1)*nelem+1:end,:) = (mapstd('apply',Ximg2((nfold-1)*nelem+1:end,:)',scale_factor2))';
end


samples = size(Ximg,1);
prob = zeros(samples,nclasses);


[model, out_param,kerneloption] = epsSVM_mykernel(double(X)',double(X2)', double(L)',in_param);


out_param.time_tr = toc;
out_param.nfeats = length(row_factor.keep);
out_param2.time_tr = toc;
out_param2.nfeats = length(row_factor2.keep);
cmd = generateLibSVMcmd_mykernel(out_param, 'predict');      %  this is needed when the training is done with -b enabled (probabilities estimated)
% cmd = generateLibSVMcmd_mykernel(out_param, '-b 1');
nsplits = 500;
index = 1;
ypred_f = [];
ypred_pro = [];

for i = 1:nsplits
    i;
    if i == nsplits
        xtest_sspe = Ximg(index:end , : );
        xtest_sspa2 = Ximg2(index:end , : );
    else
        xtest_sspe = Ximg(index:min(index + floor(samples/nsplits)-1,samples) , : );
        xtest_sspa2 = Ximg2(index:min(index + floor(samples/nsplits)-1,samples) , : );
    end    
    
K1 = makekernel(xtest_sspe,double(X)',kerneloption(1));
K2 = makekernel(xtest_sspa2,double(X2)',kerneloption(2));
K = in_param.alpha*K1 + in_param.beta*K2;
K = [(1:size(K,1))' K];

groupX = ones(size(K,1),1);
% cmd = '-b 1'; % 2021-08-05 chengle zhou
if isempty(cmd)
    [predicted_labels, out_param.accuracy] = svmpredict(groupX, K, model);
else
    [predicted_labels, out_param.accuracy, out_param.prob_estimates] = svmpredict(groupX, K, model, cmd);
end

    
ypred_f = [ypred_f;predicted_labels]; % predicted labels
% ypred_pro = [ypred_pro;out_param.prob_estimates]; % probability estimates (chengle zhou)

    indexold = index;
    index = index + floor(samples/nsplits);
    [i, index + floor(samples/nsplits)-1, index - indexold];

end


    out_param.time_tot = toc;
