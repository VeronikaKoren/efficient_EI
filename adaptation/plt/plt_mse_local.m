clear all
close all
clc

savefig=0;

namec={'local_current_E','local_current_I'};
namevar={'\tau_r^E','\tau_r^I'};

figname='mse_2cases';

addpath('/Users/vkoren/ei_net/result/adaptation/')
savefile='/Users/vkoren/ei_net/figure/adaptation/';

mse=cell(2,1);
for cases=1:2
    loadname=['measures_', namec{cases}];
    load(loadname)
    mse{cases}=ms;
    clear ms
end

%%
fs=15;
msize=6;
lw=1.9;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];

col={red,blue};

namepop={'RMSE^E','RMSE^I'};

plt2=[0,0,8,10];

xlab=namevar;
xvec=variable;
xt=[10,30,100];
%xlimit=[10,500];
xlimit=[5,200];
%%

pos_vec=plt2;
yt=[1,10,100,1000,10000];
ytl={'','10^1','','','10^{4}'};

H=figure('name',figname);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,mse{k}(:,ii),'color',col{ii},'linewidth',lw);
    end
    hold off
    box off
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    xlim(xlimit)
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',ytl,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        for ii=1:2
            text(0.7,0.85-(ii-1)*0.22,namepop{ii},'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.0 op(3)+0.01 op(4)-0.0])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.0 op(3)+0.01 op(4)+0.04])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)
    

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes
%h1 = xlabel (['time constant ',namevar{2}],'units','normalized','Position',[0.55,0.0,0],'fontsize',fs);
h2 = ylabel('RMSE','units','normalized','Position',[-0.06,0.55,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')
%set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

