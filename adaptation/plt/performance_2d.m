

clear all
close all

savefig=0;
savefig2=0;
savefig3=0;
 
namevar={'\tau_r^E','\tau_r^I'};
%%
addpath('/Users/vkoren/ei_net/result/adaptation/')
loadname= 'local_2d_measures';
load(loadname)

figname='error_local_2d';
figname2='cost_local_2d';
figname3='loss_local_2d';

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

%% plot error

g=0.5;
zvar=log(g*rms(:,:,1)+(1-g)*rms(:,:,2));

mini=min(zvar(:));
maxi=max(zvar(:));
clb_ticks=0:3:3;

H=figure('name',figname);

imagesc(zvar')
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
ylabel(namevar{2},'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs-1)
set(gca,'YTickLabel',tl,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% plot cost

cvar=log(sum(cost,3));

mini=min(cvar(:));
maxi=max(cvar(:));
clb_ticks=[0,3];

H=figure('name',figname2);

imagesc(cvar')
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
ylabel(namevar{2},'fontsize',fs)

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

lossvar=log(g*rms(:,:,1)+(1-g)*rms(:,:,2) + sum(cost,3)); % compute the loss, plot it in log scale

mini=min(lossvar(:));
maxi=max(lossvar(:));

clb_ticks=[0,4];

H=figure('name',figname3);

imagesc(lossvar')
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
ylabel(namevar{2},'fontsize',fs)

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
