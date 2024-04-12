
clear all
close all

savefig=0;

figname='beta_1ct';

addpath('/Users/vkoren/ei_net/result/connectivity/')
savefile='/Users/vkoren/ei_net/figure/implementation/';

loadname='measures_mu_1ct';
load(loadname)

%%
xvec=muvec;
%%
fs=14;
msize=6;
lw=1.2;
lwa=1;

gray=[0.2,0.2,0.2];

xt=0:10:30;
xlab='metabolic constant \beta_1';
plt1=[0,0,8,6];
%%

yt=[1,100,10000];
ytl={'10^0','10^2','10^{4}'};

H=figure('name',figname);

hold on
plot(xvec,sc(:,1),'color',gray);
set(gca,'YScale','log')
hold off
box off
text(0.5,0.7,'1 CT','units','normalized','fontsize',fs)

xlim([xvec(1),xvec(end)])
%ylim([0,58])

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

%%
%{
pos_vec3=[0,0,8,10];
H=figure('name',figname);
subplot(3,1,1)
plot(xvec,sc(:,1),'color',gray,'linewidth',lw);
set(gca,'YScale','log')
box off

xlim([xvec(1),xvec(end)])
%ylim([0,58])

ylabel('f. rate [Hz]','fontsize',fs)

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%

yt=[1,100];
ytl={'10^0','10^{2}'};

subplot(3,1,2)
plot(xvec,Rmse(:,1),'color',gray,'linewidth',lw);
set(gca,'YScale','log')
box off

ylabel('RMSE','fontsize',fs)
xlim([xvec(1),xvec(end)])
ylim([1,100])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yt=[1,10000];
ytl={'10^0','10^{4}'};

subplot(3,1,3)
plot(xvec,cost(:,1),'color',gray,'linewidth',lw);
set(gca,'YScale','log')
box off

xlabel (xlab,'fontsize',fs);
ylabel('cost','fontsize',fs)
xlim([xvec(1),xvec(end)])
%ylim([0.5,1.5])

set(gca,'XTick',xt,'fontsize',fs)
set(gca,'YTick',0:3:6)
set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')


set(H, 'Units','centimeters', 'Position', pos_vec3)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec3(3), pos_vec3(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%}