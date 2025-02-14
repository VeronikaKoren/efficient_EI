%% plots 2-dimensional plots of performance mesures as a function of ratios [E-I neuron number, mean I-I: E-I conenctivity] 

clear
close all

vari='ratios'; % local currentss
g_l=0.7;        % weighting of the error vs cost

savefig=0;
savefig2=0;
savefig3=0;
 
namevar={'N^E: N^I','mean I-I : mean E-I'};
%%

addpath('result/ratios/')
savefile=pwd;
loadname= 'measures_q_d';
load(loadname)

%%
figname1=strcat('error_',vari,'_2d');
figname2=strcat('cost_',vari,'_2d');
figname3=strcat('loss_',vari,'_2d_',sprintf('%1.0i',g_l*10));


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

clb_ticks=[1.3,2.3];

H=figure('name',figname1);
contourf(var1, var2,zvar')
axis xy
axis square

clim([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
clb.Label.String = 'log(error)';

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
clb_ticks=[1.5,2,3];

H=figure('name',figname2);

contourf(var1, var2,cvar')
axis xy
axis square

clim([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
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
clb_ticks=[1.5,2];

H=figure('name',figname3);

contourf(var1,var2,lossvar',20)
hold on
axis xy
axis square
plot(4,3,'rx','markersize',8,'linewidth',3)
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

