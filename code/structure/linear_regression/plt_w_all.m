
clear
close all

ntr=100;

savefig=0;

namep={'structured','perm_full_all'};
addpath([cd,'/result/linear_regression/'])

figname='decoder_weights_all';
savefile='/Users/vkoren/ei_net/figure/structure/train_decoder/';

%%
w_dec=cell(2,1);

for k=1:2
    loadname=['rmse_w_',namep{k},'_',sprintf('%1.0i',ntr)]
    if k==1
        load(loadname,'w_d','w')
    else
        load(loadname,'w_d')
    end

    w_dec{k}=w_d;

end
%%

labs={'trained decoder','uniform'};
namepop={'E neurons','I neurons'};

blw=1;
pos_vec=[0,0,10,12];
lwa=1.0;
fs=14;
ms=8;

green=[0.2,0.7,0.1];
gray=[0.5,0.5,0.5];
col={green,gray,'m'};

%%
yl=[0.9,0.4];
yt={[0,0.5],[0,0.3]};
xl=[1.8,4.2];
xt={-1:1:1,-3:3:3};

H=figure('name',figname,'Position', pos_vec);
for p=1:2

    subplot(2,1,p)
    hold on
    h=histogram(w_dec{1}{p}(:),20,'EdgeColor',col{1},'normalization','pdf','DisplayStyle', 'stairs','linewidth',1.5)
    histogram(w_dec{2}{p}(:),20,'EdgeColor',col{3},'normalization','pdf','DisplayStyle', 'stairs','linewidth',1.5)
    histogram(w{p}(:),20,'EdgeColor',col{2},'normalization','pdf','DisplayStyle', 'stairs','linewidth',1.5)
    hold off
    if p==1
        for ii=1:2
            text(0.55,0.9-(ii-1)*0.15,labs{ii},'units','normalized','color',col{ii},'fontsize',fs)
        end
    end
    hold 

    %xlim([-xl(p),xl(p)])
    title(namepop{p},'fontsize',fs)
    ylim([0,yl(p)])

    set(gca,'YTick',yt{p})
    set(gca,'YTickLabel',yt{p},'fontsize',fs)
    set(gca,'XTick',xt{p})
    set(gca,'XTickLabel',xt{p},'fontsize',fs)
    
    
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.0 op(3)-0.0 op(4)+0.0]);
end

axes
h1 = ylabel ('density','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+2);
h2 = xlabel ('decoding weight','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(1)==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
