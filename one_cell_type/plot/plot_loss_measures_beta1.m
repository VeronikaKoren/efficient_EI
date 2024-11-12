
clear all
close all
clc
    
savefig=0;
vari='beta';
g_l=0.7;                    % weighting of the error vs. cost


figname=strcat('loss_1CT_',vari,'_g',sprintf('%1.0i',g_l*10))

addpath('/Users/vkoren/ei_net/result/implementation/')
savefile='/Users/vkoren/ei_net/figure/implementation/';

loadname=strcat('optimization_1ct_',vari);
load(loadname)
%%
N= parameters{1}{1};
xvec=b_vec.*log(N);

fs=14;
msize=6;
lw=2.2;
lwa=1;

red=[0.85,0.32,0.1];
green=[0.2,0.7,0];

plt1=[0,0,8,7];
plt2=[0,0,8,10];
%xt=xvec(1):10:xvec(end);
xlab='metabolic constant \beta_1';

%%

%loss=g_l*ms.^2 + (1-g_l)*mc.^2;
%loss=(g_l*eps) + ((1-g_l) * kappa);


eps=(ms-min(ms))./max(ms-min(ms));
kappa= (mc-min(mc))./max(mc - min(mc));
loss=(g_l*eps) + ((1-g_l) * kappa);
%loss_plt=(loss - min(loss))./max(loss-min(loss));

[~,idx]=min(loss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% loss measures

mini=min(loss);
maxi=max(loss);
delta= (maxi-mini)/4;

pos_vec=plt2;
yt=2:3:8;
yt2=[0,1];
xt=3:10:23;
%%%%%%%%%%%%%

H=figure('name',figname,'visible',1);
subplot(2,1,1)
plot(xvec,ms,'color','k');
text(0.5,0.8,'RMSE','units','normalized','color','k','fontsize',fs)

hold off
box off
ylim([1.5,6.5])
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,eps,'color',red)
plot(xvec,kappa,'color',green)
plot(xvec,loss,'color','k')
text(0.5,0.9,'error','units','normalized','color',red,'fontsize',fs)
text(0.5,0.75,'cost','units','normalized','color',green,'fontsize',fs)
text(0.5,0.6,'loss','units','normalized','color','k','fontsize',fs)

ylim([-0.2,1.1])
% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([0,1])

set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('loss measures','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+2);
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

