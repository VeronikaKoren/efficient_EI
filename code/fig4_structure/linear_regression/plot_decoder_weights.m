
clear
close all

type=2;
ntr=200;

savefig=0;
namep={'structured','perm_full_all'};
addpath([cd,'/result/linear_regression/'])

figname=['decoder_weights_',namep{type}];
savefile='/Users/vkoren/ei_net/figure/structure/train_decoder/';

%%

loadname=['rmse_w_',namep{type},'_',sprintf('%1.0i',ntr)];
load(loadname,'w_d','w')

%%
nlab={' structured',' random'};
labs={strcat('trained on ',nlab{type}),'uniform'};
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

%%
%{
H=figure('name',figname,'Position', pos_vec);

h=boxplot(cell2mat(rmsed'),'colors','k','Outliersize',1,'Symbol','.'); % can also be symbol = 'x'
set(h,{'linew'},{blw})

hb = findobj(gca,'Tag','Box'); % attention, it counts from the back
hb(1).Color=blue;
hb(3).Color=blue;
hb(2).Color=red;
hb(4).Color=red;

for j=1:length(hb)
    patch(get(hb(j),'XData'),get(hb(j),'YData'),colinverse{j},'FaceAlpha',.5,'linew',blw);
end

for ii=1:2
    text(0.1,0.9-(ii-1)*0.12,namepop{ii},'units','normalized','color',colinverse{ii+1},'fontsize',fs)
end
box off
axis([0,5,0,14])

set(gca,'YTick',yt)
set(gca,'XTick',[1,3]+0.5)
set(gca,'XTickLabel',xlab,'fontsize',fs)

ylabel('RMSE','fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(1)==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%%
%}
%%
