
close all
clear all

addpath('/Users/vkoren/ei_net/result/implementation/');
loadname='activity_measures_distribution';
load(loadname);
%%

figure()
subplot(4,2,1)
histogram(fre_tr)
ylabel('firing rate')
subplot(4,2,2)
histogram(fri_tr)

subplot(4,2,3)
histogram(CVe_tr)
ylabel('CV')
subplot(4,2,4)
histogram(CVi_tr)

subplot(4,2,5)
histogram(re_tr)
ylabel('corr. coeff')
subplot(4,2,6)
histogram(ri_tr)

subplot(4,2,7)
histogram(sum(Ie_tr,3))
ylabel('net syn. input')
subplot(4,2,8)
histogram(sum(Ii_tr,3))