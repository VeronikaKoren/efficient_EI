clear all
close all

savefig=0;
 
addpath('/Users/vkoren/ei_net/result/adaptation/')
namevar={'tau_r^E','\tau_r^I'};
%%
loadname= 'local_2d_measures';
load(loadname)

figname='corr_2d';
savefile='/Users/vkoren/ei_net/figure/adaptation/';

fs=13;
lw=1.5;
lwa=1;
pos_vec=[0,0,10.5,8];

zvar=abs(r_ei);

mini=min(zvar(:));
maxi=max(zvar(:));

ticks=[1,11,21,31];
tl=variable(ticks);

m=min(variable);
M=max(variable);

green=[0.2,0.7,0];
%%

H=figure('name',figname);

imagesc(zvar')
axis xy
axis square

colormap hot
clb=colorbar;
caxis([mini,maxi])
set(clb,'YTick',0.0:.4:0.8,'fontsize',fs)
clb.FontSize=fs;
clb.Label.String = 'corr. coefficient';

line([10,10],[0,M],'color','k','linewidth',lw,'linestyle',':')
line([0,M],[10,10],'color','k','linewidth',lw,'linestyle',':')

text(0.45,0.85,'adaptation','color','black','units','normalized','fontsize',fs,'fontweight','bold')
text(0.5,0.75,'E & I','color','black','units','normalized','fontsize',fs,'fontweight','bold')
text(0.01,0.2,'facil.','color',green,'units','normalized','fontsize',fs,'fontweight','bold')
text(0.03,0.05,'E & I','color',green,'units','normalized','fontsize',fs,'fontweight','bold')

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs)
zlabel('corr. coeff.','fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs-1)
set(gca,'YTickLabel',tl,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end


