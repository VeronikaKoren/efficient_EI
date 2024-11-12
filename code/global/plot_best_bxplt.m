% plot distribution of loss across trials for the frist couple of points

clear 
close all
%clc

savefig=0;
gL=0.7;

addpath([cd,'/result/global/']);
loadname='performance_mc_cont';
load(loadname,'rmse_tr','cost_tr')

figname=['distr_trials_best_',sprintf('%1.0i',gL*10)];

%%

savefile='/Users/vkoren/ei_net/figure/global/';

blw=2;
pos_vec=[0,0,10,9];
lwa=1.0;
fs=14;
ms=8;

%%

loss_tr= (mean(gL*rmse_tr + (1-gL)*cost_tr,3))'; % compute loss with weigthing gL
loss_mean=mean(loss_tr,1);                       % mean across trils for ranking   

[~,idx]=sort(loss_mean);                         % sort the mean loss from smallest to largest 
cn=5;
idxu=idx(1:cn);                                  % index of the param. configuration with lowest loss    

loss_best=loss_tr(:,idxu);                       % dustribution across trials of best configurations   

nt=size(loss_best,2)-1;                          % test for significance
ref=loss_tr(:,1);
pval=zeros(nt,1);
for k=1:nt
    x2=loss_tr(:,k+1);
    [~,pval(k)]=ttest2(ref,x2);
end
disp(pval);
idxmy=find(idxu==1);
%%
yt=3:0.5:4;
maxi=max(loss_best);
maxall=max(maxi);
minall=min(loss_best(:));

d=0.02;
xd=0.35;
ymin=minall-0.2;


if gL==0.7    
    z=[maxi(2)-0.02,maxi(3)+0.05,maxi(4)+0.05,maxi(5)+0.05];
    ymax=maxall+0.25;    
else
    z= [0.03:0.09:0.3]+maxall;
    ymax=maxall+0.5;
end

H=figure('name',figname,'Position', pos_vec);
hold on
boxplot(loss_best,'colors',gray,'Outliersize',1,'Symbol','.','notch','on'); % can also be symbol = 'x'
hold off
hb = findobj(gca,'Tag','Box'); % attention, it counts from the back
hb(5).Color='r';
set(hb,{'linew'},{blw})
set(findobj(gca,'type','line'),'linew',blw)
%hold off

for k=1:4
    if pval(k)<0.05/nt
        line([1,k+1],[z(k), z(k)],'color','k','linewidth',1.3)
        line([1,1],[z(k), z(k)-d],'color','k','linewidth',1.3)
        line([k+1,k+1],[z(k), z(k)-d],'color','k','linewidth',1.3)
        text((1+k+1)/2-xd,z(k)+d,'* * *','fontsize',fs+4)
    end
end


box off
xlim([0,cn+1])
ylim([ymin,ymax])

set(gca,'YTick',yt)
set(gca,'XTick',2:cn)

text(-0.17,0.2,['average loss (g_L =',sprintf('%0.1f',gL),')'],'units','normalized','fontsize',fs+1,'Rotation',90)
xlabel('ranking')

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(1)==1
    print(H,[savefile,figname],'-dpng','-r300');
end
