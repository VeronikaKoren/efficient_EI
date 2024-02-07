
clear all
close all
clc

savefig=1;

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%% load result

Ap=1.0;

loadname=['perturbation_spont_EI_Ap',sprintf('%1.0i',Ap*10)];
load(loadname)

%% prepare figure

pos_vec=[0,0,16,11];
figname=['perturbation_trials_Ap',sprintf('%1.0i',Ap*10)];

red=[0.7,0.2,0.1];
magenta=[0.8,0,0.7];
gray=[0.5,0.5,0.5];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,magenta};                               % for "different", "similar"
coltxt={darkgray,magenta};

d=0.0005;
yt=-0.001:0.001:0.001;

xlimit=[200,nsec*1000 - spont_on-100];
xt=100:100:600;
xtl=xt-200;
fs=14;

pos=[stim_on-spont_on,-5*d,stim_off-stim_on,10*d];% [x y w h] rectangle for stim on
x=tidx;

ylimit=[-0.001,0.001]*1.7;
%% plot dr1 and dr2 average across trials

H=figure('name',figname);

subplot(2,1,1)
hold on
rectangle('Position',pos,'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
for ii=1:2
    y1=mdri{ii} - semdri{ii};
    y2=mdri{ii} + semdri{ii};
    patch([x fliplr(x)], [y1 fliplr(y2)], col{ii},'FaceAlpha',0.3,'EdgeColor',col{ii})
end
hold off
box off
for ii=1:2
    text(0.03,0.1+(ii-1)*0.15,namepop{ii},'units','normalized','color',coltxt{ii},'fontsize',fs)
end


line([tidx(1) tidx(end)],[0 0],'color','k','LineStyle','--','LineWidth',1.5)
text(stim_on-spont_on+8,-0.0012,'perturb','color',red,'fontsize',fs)
title(['perturbation strength a_p = ',sprintf('%0.1f',Ap)],'fontsize',fs)

xlim(xlimit)
ylim(ylimit)
ylabel('\Delta z^I(t)','fontsize',fs)
set(gca,'XTick',xt,'fontsize',fs)
set(gca,'XTickLabel',[])
set(gca,'YTick',yt,'fontsize',fs)

subplot(2,1,2)
hold on
rectangle('Position',pos,'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
for ii=1:2
    y1=mdre{ii} - semdre{ii};
    y2=mdre{ii} + semdre{ii};
    patch([x fliplr(x)], [y1 fliplr(y2)], col{ii},'FaceAlpha',0.3,'EdgeColor',col{ii})
end
hold off
box off
line([tidx(1) tidx(end)],[0 0],'color','k','LineStyle','--','LineWidth',1.5)

ylabel('\Delta z^E(t)','fontsize',fs)
xlabel('time [ms]','fontsize',fs)
xlim(xlimit)
ylim(ylimit)

set(gca,'YTick',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl,'fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    %savefile=[cd,'/figure/lateral/'];
    print(H,[savefile,figname],'-dpng','-r300');
end
%%


