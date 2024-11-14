clear all
close all

savefig=1;
pop=1;  

addpath('/Users/vkoren/ei_net/result/adaptation/')
namevar={'\tau_r^E','\tau_r^I'};
namepop={'E','I'}; 
%%
loadname='adaptation_2d_measures';
load(loadname,'variable','r_ei')

figname=['inst_2d_',namepop{pop}];
savefile='/Users/vkoren/ei_net/figure/adaptation/';

fs=15.0;
lw=1.5;
lwa=1;
pos_vec=[0,0,11,8];

idx=find(variable==10);
vec=(idx):size(r_ei,1);
%vec=(idx+1):(size(mean_curr,1)-0);
zvar=abs(r_ei(vec,vec,pop));

mini=min(zvar(:));
maxi=max(zvar(:));

ticks=[1,11,21];
x=variable(vec);
tl=x(ticks);

clby={[0.1,0.25],[0.2,0.4]};
%%

H=figure('name',figname);
imagesc(zvar')
axis xy
axis square

colormap hot
clb=colorbar;
caxis([mini,maxi])

%cbaryt=clb.YTick;
set(clb,'YTick',clby{pop},'fontsize',fs)
clb.FontSize=fs;
clb.Label.String = 'corr. coefficient';

title(['inst. balance in ',namepop{pop}],'fontweight','normal','fontsize',fs-1)
xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',0)

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs)
set(gca,'YTickLabel',tl,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
