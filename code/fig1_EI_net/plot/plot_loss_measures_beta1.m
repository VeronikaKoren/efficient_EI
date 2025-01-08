%% plots performnce measures as a function of beta in 1CT model 

clear
close all
clc
    
savefig=0;
vari='beta';
g_l=0.7;                    % weighting of the error vs. cost

figname=strcat('loss_1CT_hori_',vari,'_g',sprintf('%1.0i',g_l*10));

addpath([cd,'/result/EI_net/'])
savefile=pwd;

loadname=strcat('optimization_1ct_',vari);
load(loadname)
%%

N= parameters{1}{1};
xvec=b_vec.*log(N);
xlab='metabolic constant \beta_1';

%% get optimal param

aloss=g_l.*ms + (1-g_l).*mc;

[~,idx]=min(aloss);
optimal_param=xvec(idx);
display(optimal_param,'optimal beta1');

ploss=(aloss - min(aloss))./ max(aloss - min(aloss));
kappa= (mc-min(mc))./max(mc - min(mc));
%% loss measures

fs=14;
msize=6;
lw=2.2;
lwa=1;

red=[0.85,0.32,0.1];
green=[0.2,0.7,0];

plt2=[0,0,12,6];

mini=min(ploss);
maxi=max(ploss);
delta= (maxi-mini)/4;

pos_vec=plt2;
yt=2:3:8;
yt2=[0,1];
xt=5:10:23;
%%%%%%%%%%%%%

H=figure('name',figname,'visible',1);
subplot(1,2,1)
plot(xvec,ms,'color','k');
ylabel('RMSE','fontsize',fs)

hold off
box off
ylim([1.5,6.5])
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
    

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.1 op(3)+0.02 op(4)-0.07]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,2,2)
hold on
plot(xvec,kappa,'color',green)
plot(xvec,ploss,'color','k')

text(0.3,0.89,'cost','units','normalized','color',green,'fontsize',fs)
text(0.3,0.74,'loss','units','normalized','color','k','fontsize',fs)

line([optimal_param optimal_param],[mini+delta mini+2*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

ylabel ('cost, loss','fontsize',fs)
ylim([-0.1,1.1])
% arrow
xlim([xvec(1),xvec(end)])


set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.1 op(3)+0.02 op(4)-0.07]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

axes

h2 = xlabel (xlab,'units','normalized','Position',[0.5,0.01,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

