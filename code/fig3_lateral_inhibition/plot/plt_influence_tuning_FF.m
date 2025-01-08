%% plots the tuning similarity as a function of effective conenctivity in E
% and I neurons with ativity perturbation of a single E neuron 
% in presence of weak feedforward input

clear
close all
clc

savefig=0;

savefile=pwd;
addpath([cd,'/result/perturbation/'])

%% load result

a_s=1;  % strength of the stimulus
a_p=1;   % strength of perturbation wrt firing threshold (1 is at the threshold)

loadname=['perturbation_ap',sprintf('%1.0i',a_p*10),'_stim',sprintf('%1.0i',a_s*10)];
load(loadname)

F=cell(2,1);
phi=cell(2,1);

F{1}=infI;
F{2}=infE;

phi{1}=phi_veci;
phi{2}=phi_vec;

%% prepare fig.

figname=loadname;
plt1=[0,0,12,14];

fs=14;
msize=6;
lw=1.2;
lwa=1;

orange=[1,0.5,0.1];

titles={'I neurons','E neurons'};
xt=-0.004:0.004:0.004;
%%

H=figure('name',figname);

for ii=1:2
    subplot(2,1,ii)
    
    plot(F{ii},phi{ii},'kx')
    line([0,0],[-1,1],'color','r','LineStyle','-')
    hls=lsline;
    hls.Color=orange;
    box off

    title(titles{ii},'Fontsize',fs)
    xlim([-1,1].*0.0043)
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

h1 = xlabel ('influence','units','normalized','Position',[0.5,-0.07,0],'Fontsize',fs+1);
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