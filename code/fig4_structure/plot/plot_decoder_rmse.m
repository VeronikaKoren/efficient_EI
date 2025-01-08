%% plots the RMSE of a linear decoder trained to minimize the encoding error
% using spikes from the optimal network vs
% using spikes from the network with unstructured connectivity

clear
close all
clc

savefig=0;

ntr=200;
figname=['rmse_decoder_',sprintf('%1.0i',ntr)];
savefile=pwd;

namep={'structured','perm_full_all'};
addpath([cd,'/result/structure/'])

%%

rmsed=cell(2,1);

for t=1:2
    loadname=['rmse_w_',namep{t},'_',sprintf('%1.0i',ntr)];
    load(loadname,'rmse_d')
    rmsed{t}=rmse_d;
end

%%

xlab={'structured','shuffled'};
namepop={'E neurons','I neurons'};

blw=1.0;
pos_vec=[0,0,9,8];
lwa=1.0;
fs=15;
ms=8;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
colinverse={blue,red,blue,red};
yt=0:5:10;

%%

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
