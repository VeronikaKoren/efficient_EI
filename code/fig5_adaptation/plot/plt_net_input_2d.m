%% generates 2-dimensional plot of the net synaptic input to population pop as a function of [tau_r^E,tau_r^I]

clear
close all

savefig=0;
pop=1;        % [1,2] for E,I   

namevar={'\tau_r^E','\tau_r^I'};
namepop={'E','I'}; 

figname=['net_2d_',namepop{pop}];

%%
addpath('/Users/vkoren/efficient_EI/result/adaptation/')

loadname='adaptation_2d_measures';
if pop==1
    load(loadname,'meanE','variable')
    mean_curr=meanE;
else
    load(loadname,'meanI','variable')
    mean_curr=meanI;
end

savefile=pwd;

%%

fs=15;
lw=1.5;
lwa=1;
pos_vec=[0,0,11,8];

idx=find(variable==10);     % limit between adaptation and facilitation (show adaptation regime)
vec=idx:(size(mean_curr,1)); % range of values for adaptation

%%

I_net=mean_curr(:,:,1) + mean_curr(:,:,2);
zvar=I_net(vec,vec);

mini=min(zvar(:));
maxi=max(zvar(:));

ncol=length(variable);

ticks=[1,11,21];
x=variable(vec);
tl=x(ticks);

%%
ci=zeros(ncol+1,3);
ty={[-1.2,-0.4],[0,10]};

H=figure('name',figname);

imagesc(zvar')
axis xy
axis square
clim([mini,maxi])

ch=colormap(hot(ncol+1)); % modified colormap "hot"
ci(:,1)=ch(:,2);
ci(:,2)=ch(:,1);
ci(:,3)=ch(:,3);
colormap(ci)

clb=colorbar;

set(clb,'YTick',ty{pop},'fontsize',fs)
clb.FontSize=fs;
clb.Label.String = ['net syn. input to ',namepop{pop}];


title(['average imbalance in ',namepop{pop}],'fontweight','normal','fontsize',fs-1)

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


