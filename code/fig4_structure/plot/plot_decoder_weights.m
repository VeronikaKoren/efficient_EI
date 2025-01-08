%% plots the distribution of weights of the trained linear decoder and the uniform distribution
% type=1 ~ trained on spikes from the network with strucured connectivity
% type=2 ~ trained on spikes from the network with UNstrucured connectivity

clear
close all
clc

type=1;

savefig=0;
namep={'structured','perm_full_all'};
addpath([cd,'/result/structure/'])

figname=['decoder_weights_',namep{type}];
savefile=pwd;

%%

ntr=[200,100];
loadname=['rmse_w_',namep{type},'_',sprintf('%1.0i',ntr(type))];
load(loadname,'w_d','w')

%%
ntype={' structured',' random'};
labs={strcat('trained on ',ntype{type}),'uniform'};
namepop={'E neurons','I neurons'};

blw=1;
pos_vec=[0,0,10,12];
lwa=1.0;
fs=14;
ms=8;

green=[0.2,0.7,0.1];
gray=[0.5,0.5,0.5];
if type==1
    col={green,gray};
else
    col={'m',gray};
end

%%

yl=[1.1,0.7];
yt={[0,0.5],[0,0.3]};
xl=[1.8,5.2];
xt={-1:1:1,-3:3:3};

H=figure('name',figname,'Position', pos_vec);
for p=1:2

    subplot(2,1,p)
    hold on
    
    histogram(w{p}(:),20,'FaceColor',col{2},'normalization','pdf')
    histogram(w_d{p}(:),20,'FaceColor',col{1},'normalization','pdf')
    hold off
    if p==1
        for ii=1:2
            text(0.05,0.9-(ii-1)*0.15,labs{ii},'units','normalized','color',col{ii},'fontsize',fs)
        end
    end
    hold 

    xlim([-xl(p),xl(p)])
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


