

clear all
close all

vari='ratios'; % local currentss
g_l=0.7;        % weighting of the error vs cost

savefig=0;
savefig2=0;
savefig3=0;
 
namevar={'N^E: N^I','mean I-I : mean E-I'};
%%

addpath('/Users/vkoren/ei_net/result/ratios/')
loadname= 'measures_q_d';
load(loadname)

%%
figname1=strcat('error_',vari,'_2d');
figname2=strcat('cost_',vari,'_2d');
figname3=strcat('loss_',vari,'_2d_',sprintf('%1.0i',g_l*10));

savefile='/Users/vkoren/ei_net/figure/ratios/2d/';

fs=16;
lw=1.5;
lwa=1;
pos_vec=[0,0,10.5,8];

xticks=[0,3,6];
yticks=[0,3,6];

var1=qvec;
var2=dvec;

%% plot error

zvar=log(mean(rms,3));

mini=min(zvar(:));
maxi=max(zvar(:));
d=(maxi - mini)/3;
%clb_ticks=[floor((mini+d)*10)/10,ceil((mini+2*d)*10)/10];
clb_ticks=[1.3,2.3];

H=figure('name',figname1);
contourf(var1, var2,zvar')
%imagesc(qvec, dvec,zvar')
axis xy
axis square

clim([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
clb.Label.String = 'log(error)';
%clb.Label.String = '(RMSE^E + RMSE^I) / 2';

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',90)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',xticks)
set(gca,'YTick',yticks)
set(gca,'XTickLabel',xticks,'fontsize',fs-1)
set(gca,'YTickLabel',yticks,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot cost

cvar=log(mean(cost,3));

mini=min(cvar(:));
maxi=max(cvar(:));
d=(maxi - mini)/3;
%clb_ticks=[floor((mini+d)*10)/10,ceil((mini+2*d)*10)/10];
clb_ticks=[1.5,2,3];

H=figure('name',figname2);

contourf(var1, var2,cvar')
%imagesc(qvec, dvec,cvar')
axis xy
axis square

clim([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
%clb.Label.String = '(MC^E + MC^I) / 2';
clb.Label.String = 'log(cost)';

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',90)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',xticks)
set(gca,'YTick',yticks)
set(gca,'XTickLabel',xticks,'fontsize',fs-1)
set(gca,'YTickLabel',yticks,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% plot loss

lossvar=log((g_l*mean(rms,3)) + ((1-g_l)*mean(cost,3)));
mini=min(lossvar(:));
[idx,idy]=find(lossvar==mini);
optimal_param=[var1(idx),var2(idy)];
display(optimal_param,'[q*, d*]');
%%

maxi=max(lossvar(:));
d=(maxi - mini)/3;
%clb_ticks=[floor((mini+d)*10)/10,ceil((mini+2*d)*10)/10];
clb_ticks=[1.5,2];

H=figure('name',figname3);

contourf(var1,var2,lossvar',20)
hold on
axis xy
axis square
plot(4,3,'rx','markersize',8,'linewidth',3)
%plot(optimal_param(1),optimal_param(2),'rx','markersize',15,'linewidth',4)
hold off
clim([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
clb.Label.String = 'log( loss )';

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',90)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',xticks)
set(gca,'YTick',yticks)
set(gca,'XTickLabel',xticks,'fontsize',fs-1)
set(gca,'YTickLabel',yticks,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%%

