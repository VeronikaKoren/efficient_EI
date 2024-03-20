clear all
close all
clc

savefig=1;

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%% load result

Ap=1.0;
figname=['influence_tuning_',sprintf('%1.0i',Ap*10)];

F=cell(2,1);
phi=cell(2,1);
loadname=['perturbation_spont_Ap',sprintf('%1.0i',Ap*10)];
load(loadname,'infE','infI','phi_veci','phi_vec','namepop')

F{1}=infI;
F{2}=infE;

phi{1}=phi_veci;
phi{2}=phi_vec;

%% prepare fig.

plt1=[0,0,10,12];

fs=14;
msize=6;
lw=1.2;
lwa=1;

%green=[0.1,0.82,0.1];
%gray=[0.7,0.7,0.7];
%olive=[0.2,0.7,0.2];
%darkgray=[0.5,0.5,0.5];

%col={gray,green};                               % for "different", "similar"
%coltxt={darkgray,olive};

titles={'I neurons','E neurons'};
xt=-0.003:0.003:0.003;
%%

H=figure('name',figname);

for ii=1:2
    subplot(2,1,ii)
    
    plot(F{ii},phi{ii},'kx')
    line([0,0],[-1,1],'color','r','LineStyle','-')
    hls=lsline
    hls.Color='m'
    box off

    title(titles{ii},'Fontsize',fs)
    xlim([xt(1),xt(end)])
    ylim([-1.1,1.1])
    set(gca,'XTick',xt)
    if ii==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',xt,'Fontsize',fs)
    end
    set(gca,'YTick',-1:1:1,'Fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.00 op(3)-0.05 op(4)-0.00]);

end

axes

h1 = xlabel ('effective connectivity','units','normalized','Position',[0.5,-0.07,0],'Fontsize',fs+1);
h2 = ylabel ('tuning similarity','units','normalized','Position',[-0.05,0.5,0],'Fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% correlation coefficient

r=zeros(2,1);
for ii=1:2
    
    x=F{ii}';
    y=phi{ii}';
    x(100)=[];
    y(100)=[];
    r(ii)=corr(x,y);

end
display(r,'correlation coefficient')