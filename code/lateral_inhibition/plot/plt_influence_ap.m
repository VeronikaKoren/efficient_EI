clear all
close all
clc

savefig=1;
figname='influence_ap';

savefile='/Users/vkoren/ei_net/figure/lateral/';
addpath('/Users/vkoren/ei_net/result/perturbation/')

%%

loadname='perturbation_Ei_spont_apvec';
load(loadname)

%%
plt3=[0,0,10,16];

red=[0.7,0.2,0.1];
magenta=[0.8,0,0.7];
gray=[0.5,0.5,0.5];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,magenta};                               % for "different", "similar"
coltxt={darkgray,magenta};

fs=14;
msize=6;
lw=1.2;
lwa=1;

d=0.001;
yt=-2*d:d:d;
xt=0:0.5:1.5;
x=apvec;

ylimit=[-0.0015,0.0015];
%%

H=figure('name',figname);

subplot(3,1,1)
hold on
y1=(mtar - semtar)';
y2=(mtar + semtar)';
patch([x fliplr(x)], [y1 fliplr(y2)], red,'FaceAlpha',0.3,'EdgeColor',red)
hold off

title('photostimulated neuron','fontsize',fs)
%text(0.05,0.85,'photostimulated','units','normalized','color',red,'fontsize',fs)

set(gca,'YTick',0:30:60)
set(gca,'YTicklabel',0:30:60,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])

ylim([0,60])
ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.1 op(2)+0.0 op(3)-0.05 op(4)-0.0]);

subplot(3,1,2)
hold on
for k=1:2
    y1=(minfI{k}-semfI{k})';
    y2=(minfI{k}+semfI{k})';
    patch([x fliplr(x)], [y1 fliplr(y2)], col{k},'FaceAlpha',0.3,'EdgeColor',col{k})
    text(0.05,0.75+(k-1)*0.15,namepop{k},'units','normalized','color',coltxt{k},'fontsize',fs)
end
line([x(1) x(end)],[0 0],'color','k','linestyle','--','linewidth',1)
hold off

title('to I neurons','Fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])
ylim(ylimit)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.08 op(2)+0.0 op(3)-0.03 op(4)+0.02]);

subplot(3,1,3)
hold on
for k=1:2
    y1=(minfE{k}-semfE{k})';
    y2=(minfE{k}+semfE{k})';
    patch([x fliplr(x)], [y1 fliplr(y2)], col{k},'FaceAlpha',0.3,'EdgeColor',col{k})
end
line([x(1) x(end)],[0 0],'color','k','linestyle','--','linewidth',1)
hold off

title('to E neurons','Fontsize',fs)
ylim(ylimit)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.08 op(2)+0.0 op(3)-0.03 op(4)+0.02]);

axes

h1 = xlabel('perturbation strength a_p','units','normalized','Position',[0.55,-0.07,0],'Fontsize',fs+1);
h2 = ylabel('effective connectivity','units','normalized','Position',[-0.07,0.3,0],'Fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', plt3)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt3(3), plt3(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
