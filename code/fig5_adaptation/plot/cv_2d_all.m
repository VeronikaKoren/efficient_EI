
clear all
close all

savefig=0;

addpath('/Users/vkoren/efficient_EI/result/adaptation/')
namevar={'\tau_r^E','\tau_r^I'};
namepop={'E','I'};

%%

loadname='adaptation_2d_measures';
load(loadname)

figname='cv_2d';
savefile='/Users/vkoren/ei_net/figure/adaptation/';

fs=13;
lw=1.5;
lwa=1;
pos_vec=[0,0,14,6];

%%

idx_nan=isnan(CVs);
CVs(idx_nan)=0;
idx=find(variable==10);
vec=(idx+2):size(frate,1);

x=variable(vec);
y=variable(vec);
varz=CVs(vec,vec,:);

%%

mini=0;
maxi=1;

ncol=25;
mymap=ones(ncol,3).*0.7;
for ii=1:ncol
    %mymap(ii,1)=ii/ncol;    % gets green
    mymap(ii,2)=1-ii/ncol;
    mymap(ii,3)=ii/ncol;
end

q=round(maxi/10)*10;
clb_ticks=0:0.4:0.8;

ticks=[1,10,19];
ticksl=x(ticks);

%%
H=figure('name',figname);
for k=1:2
    
    z=squeeze(varz(:,:,k));
    
    subplot(1,2,k)
    imagesc(z')
    colormap(spring)
    %colormap(parula)
    caxis([mini,maxi])
    
    axis xy
    axis square
    
    title([namepop{k},' neurons'],'fontweight','normal','fontsize',fs)
    set(gca,'XTick',ticks)
    set(gca,'XTickLabel',ticksl,'fontsize',fs)
    set(gca,'YTick',ticks)
    xlabel(namevar{1},'fontsize',fs)

    if k==1
        set(gca,'YTickLabel',ticksl,'fontsize',fs)
        ylabel(namevar{2},'fontsize',fs,'rotation',0)
        %op=get(gca,'OuterPosition');
        %set(gca,'OuterPosition',[op(1)+0.00 op(2)+0.01 op(3)-0.045 op(4)+0.01]);
    else 
        set(gca,'YTickLabel',[])

        op=get(gca,'OuterPosition');
        if k==1
            set(gca,'OuterPosition',[op(1)+0.00 op(2)+0.02 op(3)+0.02 op(4)+0.01]);
        else
            set(gca,'OuterPosition',[op(1)+0.00 op(2)+0.02 op(3)+0.02 op(4)+0.03]);
        end
        clb=colorbar;
        set(clb,'YTick',clb_ticks,'fontsize',fs)
        clb.FontSize=fs;
        clb.Label.String = 'coefficient variation';

    end
   
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
        
end
%set(gca,'OuterPosition',[op(1)+0.00 op(2)+0.0 op(3)+0.0 op(4)+0.0]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%%
