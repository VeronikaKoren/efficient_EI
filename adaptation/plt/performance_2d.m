

clear all
close all

vari='local'; % local currentss
g_l=0.7;        % weighting of the error vs cost

savefig=0;
savefig2=0;
savefig3=0;
 
namevar={'\tau_r^E','\tau_r^I'};
%%
addpath('/Users/vkoren/ei_net/result/adaptation/')
loadname= 'local_2d_measures';
load(loadname)

figname1=strcat('error_',vari,'_2d');
figname2=strcat('cost_',vari,'_2d');
figname3=strcat('loss_local_2d_',sprintf('%1.0i',g_l*10));

savefile='/Users/vkoren/ei_net/figure/adaptation/';

fs=16;
lw=1.5;
lwa=1;
pos_vec=[0,0,10,8];

ticks=[0,10,20,30]+1;
tl=variable(ticks);

m=min(variable);
M=max(variable);

idx=find(variable==10);

g_e = 0.5;
g_k = 0.5;

%% plot error

%g=0.5;
%zvar=log(g*rms(:,:,1)+(1-g)*rms(:,:,2));

RMSE=squeeze(rms(:,:,1));
RMSI=squeeze(rms(:,:,2));
eps_E=(RMSE-min(min(RMSE)))./max(max(RMSE));
eps_I=(RMSE-min(min(RMSI)))./max(max(RMSI));
error=(g_e*eps_E) + ((1-g_e)*eps_I);
zvar=log(error);
%}

mini=min(zvar(:));
maxi=max(zvar(:));
clb_ticks=[-5,-2];

%%
H=figure('name',figname1);

imagesc(zvar)
axis xy
axis square

caxis([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
clb.Label.String = 'log( error )';

line([idx,idx],[0,M],'color','w','linewidth',lw,'linestyle',':')
line([0,M],[idx,idx],'color','w','linewidth',lw,'linestyle',':')

text(0.43,0.8,'adaptation','color','w','units','normalized','fontsize',fs-1)
text(0.45,0.7,'E & I','color','w','units','normalized','fontsize',fs-1)
text(0.01,0.2,'facilit.','color','r','units','normalized','fontsize',fs-1)
text(0.01,0.1,'E & I','color','r','units','normalized','fontsize',fs-1)

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',0)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs-1)
set(gca,'YTickLabel',tl,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot cost

%cvar=log(mean(cost,3));

MCE=squeeze(cost(:,:,1));
MCI=squeeze(cost(:,:,2));
kappa_E=(MCE-min(min(MCE)))./max(max(MCE));
kappa_I=(MCI-min(min(MCI)))./max(max(MCI));
costm=(g_k.*kappa_E) + ((1-g_k).*kappa_I);
cvar=log(costm);


mini=min(cvar(:));
maxi=max(cvar(:));
clb_ticks=[-5,-2];

%%
H=figure('name',figname2);

imagesc(cvar)
axis xy
axis square

caxis([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
clb.Label.String = 'log( cost )';

line([idx,idx],[0,M],'color','w','linewidth',lw,'linestyle',':')
line([0,M],[idx,idx],'color','w','linewidth',lw,'linestyle',':')

text(0.43,0.8,'adaptation','color','w','units','normalized','fontsize',fs-1)
text(0.45,0.7,'E & I','color','w','units','normalized','fontsize',fs-1)
text(0.01,0.2,'facilit.','color','r','units','normalized','fontsize',fs-1)
text(0.01,0.1,'E & I','color','r','units','normalized','fontsize',fs-1)

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',0)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs-1)
set(gca,'YTickLabel',tl,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% plot loss

%lossvar=log(g*rms(:,:,1)+(1-g)*rms(:,:,2) + mean(cost,3)); % compute the loss, plot it in log scale

lossvar=log(g_l.*error + (1-g_l).*costm);
mini=min(lossvar(:));
maxi=max(lossvar(:));

clb_ticks=[-5,-2];

H=figure('name',figname3);

imagesc(lossvar)
axis xy
axis square

caxis([mini,maxi])
clb=colorbar;

set(clb,'YTick',clb_ticks,'fontsize',fs)
set(clb,'YTickLabel',clb_ticks,'fontsize',fs-2)
clb.FontSize=fs;
clb.Label.String = 'log( loss )';

line([idx,idx],[0,M],'color','w','linewidth',lw,'linestyle',':')
line([0,M],[idx,idx],'color','w','linewidth',lw,'linestyle',':')

text(0.43,0.8,'adaptation','color','w','units','normalized','fontsize',fs-1)
text(0.45,0.7,'E & I','color','w','units','normalized','fontsize',fs-1)
text(0.01,0.2,'facilit.','color','r','units','normalized','fontsize',fs-1)
text(0.01,0.1,'E & I','color','r','units','normalized','fontsize',fs-1)

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',0)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs-1)
set(gca,'YTickLabel',tl,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%%
%{
figure()
surf(zvar')
xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs)
colorbar
axis xy
%}
%%