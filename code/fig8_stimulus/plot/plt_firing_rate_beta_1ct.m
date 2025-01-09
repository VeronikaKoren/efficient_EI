%% plots the firing rate (on log-scale) as a function of the metabolic constant beta_1

clear
close all
clc

savefig=0;
figname='beta_1ct';

savefile=pwd;
addpath('result/stimulus/')

loadname='measures_mu_1ct';
load(loadname)

%%
xvec=muvec;

fs=14;
msize=6;
lw=1.2;
lwa=1;

gray=[0.2,0.2,0.2];

xt=0:10:30;
xlab='metabolic constant \beta_1';
plt1=[0,0,8,6];

yt=[1,100,10000];
ytl={'10^0','10^2','10^{4}'};

%%

H=figure('name',figname);

hold on
plot(xvec,sc(:,1),'color',gray);
set(gca,'YScale','log')
hold off
box off
text(0.5,0.7,'1 CT','units','normalized','fontsize',fs)

xlim([xvec(1),xvec(end)])

ylabel('f. rate [Hz]')
xlabel (xlab);

set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl)
set(gca,'XTick',xt)
set(gca,'XTick',xt)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

