
clear all
close all

savefig=0;

addpath('/Users/vkoren/ei_net/result/adaptation/')
namevar={'\tau_r^E','\tau_r^I'};

%%

loadname= 'local_2d_measures';
load(loadname)

figname='net_current_2d_adaptation';
savefile='/Users/vkoren/ei_net/figure/adaptation/';

fs=15;
lw=1.5;
lwa=1;
pos_vec=[0,0,10,8];

idx=find(variable==10);     % limit between adaptation and facilitation
vec=idx:(size(mean_curr,1))-3; % range of values for adaptation
%%
a=0.3;
I_net=(mean_curr(:,:,1) + mean_curr(:,:,2)).*a;
zvar=I_net(vec,vec);

mini=min(zvar(:));
maxi=max(zvar(:));

ncol=30;

ticks=[1,11,21];
x=variable(vec);
tl=x(ticks);

%%
ci=zeros(ncol+1,3);

H=figure('name',figname);
%contourf(zvar',ncol)
imagesc(zvar')
axis xy
axis square

ch=colormap(hot(ncol+1)); % modified colormap "hot"
ci(:,1)=ch(:,2);
ci(:,2)=ch(:,1);
ci(:,3)=ch(:,3);
colormap(ci)

clb=colorbar;
caxis([mini,maxi])
set(clb,'YTick',0:2:4,'fontsize',fs)
clb.FontSize=fs;
clb.Label.String = 'net syn. input to I';

title('adaptation in E and I','fontweight','normal','fontsize',fs-1)

xlabel(namevar{1},'fontsize',fs)
ylabel(namevar{2},'fontsize',fs,'rotation',0)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

set(gca,'XTick',ticks,'fontsize',fs)
set(gca,'YTick',ticks,'fontsize',fs)
set(gca,'XTickLabel',tl,'fontsize',fs)
set(gca,'YTickLabel',tl,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end


