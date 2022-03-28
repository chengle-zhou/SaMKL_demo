
# SaMKL, IEEE J-STARS, 2021
---
## Structure-Aware Multikernel Learning for Hyperspectral Image Classification

***Chengle Zhou, Bing Tu, Nanying Li, Wei He, and Antonio Plaza***

*IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing, vol. 14, pp. 9837-9854, 2021.*

[DOI:10.1109/JSTARS.2021.3111740](https://ieeexplore.ieee.org/document/9535266)

---

![FIg.1](https://github.com/chengle-zhou/MY-IMAGE/raw/main/SaMKL/framework.png)

Fig.1 Overview of the proposed SaMKL method for HSI classification. Super-S, Super-M, and Super-G refer to HSI raw spectral, morphological attribute, and 2-D Gabor textural features based on superpixel guidance, respectively.  Super-Spec, Super-Spat, and Super-Text represent superpixel spectral, spatial, and textural kernels, respectively.



## Abstract

Recently, the inclusion of spatial information has drawn increasing attention in hyperspectral image (HSI) applications due to its effectiveness in terms of improving classification accuracy. However, most of the techniques that include such spatial knowledge in the analysis are based on spatial–spectral weak assumptions, i.e., all pixels in a spatial region are assumed to belong
to the same class, and close pixels in spectral space are assigned the same label. This article proposes a novel structure-aware multikernel learning (SaMKL) method for HSI classification, which takes into account structural issues in order to effectively overcome the aforementioned weak assumptions and introduce a true multikernel learning process (based on multiple features derived from the original HSI), thus improving the spectral separability of such features. The proposed SaMKL method is composed of the following main steps. First, multiple (i.e., spectral, spatial, and textural) features are extracted from the original HSI based on various filtering operators. Then, a k-peak density approach is designed to define superpixel regions that can properly capture the structural information of HSIs and overcome the aforementioned weak assumptions. Next, three sets of composite kernels are separately constructed to make full use of the spectral, spatial, and textural information. Meanwhile, these three sets of composite kernels are independently incorporated into a support vector machine classifier to obtain their corresponding classification results. Finally, majority voting is used as a simple and effective method to obtain the final classification labels. Experimental results on real HSI datasets indicate that the SaMKL outperforms other well-known and state-of-the-art classification approaches, in particular, when very limited labeled samples are available a priori.


---

The code is for the work, if you find it is useful, please cite our work:
> BibTex format is as follows:
> 
	@ARTICLE{9535266,
	author={Zhou, Chengle and Tu, Bing and Li, Nanying and He, Wei and Plaza, Antonio},
    journal={IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing}, 
    title={Structure-Aware Multikernel Learning for Hyperspectral Image Classification}, 
    year={2021},
    volume={14},
    number={},
    pages={9837-9854},
    doi={10.1109/JSTARS.2021.3111740}}

If you need another two datasets (i.e., University of Pavia and Salinas Valley), please feel free to contact me. Or you can download them from http://www.ehu.eus/ccwintco/index.php/Hyperspectral_Remote_Sensing_Scenes

University of Pavia: http://www.ehu.eus/ccwintco/uploads/e/ee/PaviaU.mat, http://www.ehu.eus/ccwintco/uploads/5/50/PaviaU_gt.mat

Salinas Valley: http://www.ehu.eus/ccwintco/uploads/a/a3/Salinas_corrected.mat, http://www.ehu.eus/ccwintco/uploads/f/fa/Salinas_gt.mat

---


### ACKNOWLEDGMENT

The authors would like to thank Dr. Nanjun He from Tencent Jarvis Lab and Mr. Siyuan Huang from Sichuan Suitang Technology Co., Ltd. for their enthusiastic help. In addition, the authors appreciate Prof. Jun Li, Prof. Pedram Ghamisi, and Prof. Leyuan Fang for providing the software of the SVM-CK, MLR-GCK, EPF, Eps, EPs-F, and SC-MK. The authors would like also to thank the editors and anonymous reviewers for their insightful comments and suggestions, which have significantly improved this article.
