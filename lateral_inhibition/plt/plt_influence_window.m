clear all
close all
clc

savefig=1;
figname='influence_window';

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%%
loadname='perturbation_Ei_spont_dstim';
load(loadname)

%%
plt3=[0,0,10,12];

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
xt=100:200:500;
x=d_stim_vec;

ax=[x(1), x(end), -0.0015, 0.0015];

%%

H=figure('name',figname);

subplot(2,1,1)
hold on
for k=1:2
    y1=(minfI{k}-semfI{k})';
    y2=(minfI{k}+semfI{k})';
    patch([x fliplr(x)], [y1 fliplr(y2)], col{k},'FaceAlpha',0.3,'EdgeColor',col{k})
    text(0.05,0.15+(k-1)*0.15,namepop{k},'units','normalized','color',coltxt{k},'fontsize',fs)
end
line([x(1) x(end)],[0 0],'color','k','linestyle','--','linewidth',1)
hold off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])
axis(ax)
ylabel('influence I','fontsize',fs+2)

subplot(2,1,2)
hold on
for k=1:2
    y1=(minfE{k}-semfE{k})';
    y2=(minfE{k}+semfE{k})';
    patch([x fliplr(x)], [y1 fliplr(y2)], col{k},'FaceAlpha',0.3,'EdgeColor',col{k})
end
line([x(1) x(end)],[0 0],'color','k','linestyle','--','linewidth',1)
hold off
ylabel('influence E','fontsize',fs)
xlabel('length stimulation [ms]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
axis(ax)

set(H, 'Units','centimeters', 'Position', plt3)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt3(3), plt3(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
%{
subplot(3,1,1)
hold on
y1=(mtar - semtar)';
y2=(mtar + semtar)';
patch([x fliplr(x)], [y1 fliplr(y2)], red,'FaceAlpha',0.3,'EdgeColor',red)
hold off
text(0.05,0.85,'stimulated','units','normalized','color',red,'fontsize',fs)

set(gca,'YTick',0:30:60)
set(gca,'YTicklabel',0:30:60,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',[])

%ylim([0,100])
ylabel('firing rate','fontsize',fs)
%}