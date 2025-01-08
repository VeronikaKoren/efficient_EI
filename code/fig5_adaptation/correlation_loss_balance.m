

% computes Pearson's correlation coefficient between the loss and the average balance / instantanoues balance

clear all
close all

g_l=0.7;        % weighting of the error vs cost

savefig=0;
showfig=0;
namepop={'in E','in I'};

%%

addpath('/Users/vkoren/ei_net/result/adaptation/')
loadname= 'adaptation_2d_measures';
load(loadname,'rms','meanE','meanI','r_ei','variable','cost')

figname1='correlation_error_balance';
figname2='correlation_efficiency_balance';

savefile='/Users/vkoren/ei_net/figure/adaptation/';

idx=find(variable==10);
vec=idx:length(variable);

%% correlation (loss, average imbalance) / (loss,instantaneous balance)

loss_ei=log(g_l*rms(vec,vec,:) +((1-g_l).*cost(vec,vec,:)));
net=meanE(vec,vec,:)+meanI(vec,vec,:);
rei=abs(r_ei(vec,vec,:));

r_inst=zeros(2,1);
r_average=zeros(2,1);
for p=1:2
    x=loss_ei(:,:,p);
    y=rei(:,:,p);
    z=net(:,:,p);
    r_inst(p)=corr(x(:),y(:));
    r_average(p)=corr(x(:),z(:));
end

display(r_average,'r_loss average_imbalance');
display(r_inst,'r_loss inst_balance')
%%

