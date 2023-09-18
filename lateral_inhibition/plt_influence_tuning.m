clear all
close all
clc


savefig=0;
figname='influence_tuning';

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%% load result


apvec=[0.4,0.8];

F=zeros(2,400);
phi_target=zeros(2,400)
for ii=1:2
    Ap=apvec(ii)
    loadname=['perturbation_spont_Ap',sprintf('%1.0i',Ap*10)];
    load(loadname,'inf','phi_vec','namepop')
    F(ii,:)=inf;
    phi_target(ii,:)=phi_vec;

end
%% prepare fig.

plt1=[0,0,12,14];

fs=13;
msize=6;
lw=1.2;
lwa=1;

green=[0.1,0.82,0.1];
gray=[0.7,0.7,0.7];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,green};                               % for "different", "similar"
coltxt={darkgray,olive};

xt=-0.003:0.003:0.003;
%%

H=figure('name',figname);

for ii=1:2
    subplot(2,1,ii)
    
    plot(F(ii,:),phi_target(ii,:),'kx')
    line([0,0],[-1,1],'color','r','LineStyle','-')
    %hls=lsline
    %hls.Color='m'
    box off

    title(['perturbation strength Ap = ',sprintf('%0.1f',apvec(ii))])
    xlim([xt(1),xt(end)])
    ylim([-1.1,1.1])
    set(gca,'XTick',xt)
    if ii==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',xt)
    end
    set(gca,'YTick',-1:1:1)

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.00 op(3)-0.05 op(4)-0.00]);

end

axes

h1 = xlabel ('influence','units','normalized','Position',[0.5,-0.07,0]);
h2 = ylabel ('tuning similarity','units','normalized','Position',[-0.05,0.5,0]);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
