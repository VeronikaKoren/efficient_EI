
clear all
close all
clc

savefig1=0;
savefig2=0;

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%% load result

Ap=0.4;

loadname=['perturbation_spont_Ap',sprintf('%1.0i',Ap*10)];
load(loadname)

figname1=['lateral_trials_Ap',sprintf('%1.0i',Ap*10)];
figname2=['influence_tuning_similarity',sprintf('%1.0i',Ap*10)];

%% prepare figure

tidx=[1:length(md_plt)]*dt;

pos_vec=[0,0,18,8];
figname=['perturbation_trials_Ap',sprintf('%1.0i',Ap*10)];

red=[0.7,0.2,0.1];
green=[0.1,0.82,0.1];
gray=[0.7,0.7,0.7];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,green};                               % for "different", "similar"
coltxt={darkgray,olive};

d=0.0005;
yt=-2*d:d:d;

xlimit=[100,nsec*1000 - spont_on-100];
xt=100:200:600;
xtl=xt-100;
fs=14;

pos=[stim_on-spont_on,-3*d,stim_off-stim_on,5*d];% [x y w h]

%% plot dr1 and dr2 average across trials

H=figure('name',figname1);
hold on
plot(tidx,md_plt(1,:),'color',col{1})
plot(tidx,md_plt(2,:),'color',col{2})
hold off
box off

rectangle('Position',pos,'FaceColor',[1,1,0,0.3],'EdgeColor','y','Linewidth',1)
line([tidx(1) tidx(end)],[0 0],'color','k','LineStyle','--','LineWidth',2)
text(stim_on-spont_on,0.0006,'stim.','color',red,'fontsize',fs)

for ii=1:2
    text(0.07,0.8+(ii-1)*0.1,namepop{ii},'units','normalized','color',coltxt{ii},'fontsize',fs)
end

title(['perturbation strength a_p = ',sprintf('%0.1f',Ap)])
ylabel('\Delta r(t)')
xlabel('time [ms]')
xlim(xlimit)
ylim([-0.0013,0.0008])

set(gca,'YTick',yt)
set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    savefile=[cd,'/figure/lateral/'];
    print(H,[savefile,figname1],'-dpng','-r300');
end
%%


