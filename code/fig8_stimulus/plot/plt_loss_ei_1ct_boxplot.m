
clear
close all
clc

figname1='rmse_ei_1ct_box';
figname2='cost_ei_1ct_box';

savefig1=0;
savefig2=0;

savefile=[pwd,'/']; % put here a path for saving the results
addpath('result/stimulus/')

%% load results

% E-I net
loadname='loss_measures_optimal_ei';
load(loadname)

% 1 cell type
loadname='loss_measures_optimal_1CT';
load(loadname)

g_l=0.7;

%% prepare the boxes

ntr=length(rmse1);

rmse_box=zeros(ntr,3);
rmse_box(:,1:2)=rmse';
rmse_box(:,3)=rmse1;

cost_box=zeros(ntr,3);
cost_box(:,1:2)=cost';
cost_box(:,3)=kappa1;

fr_box=zeros(ntr,3);
fr_box(:,1:2)=sc';
fr_box(:,3)=sc1;

lbox=zeros(ntr,2);
lbox(:,1)=(g_l.*(mean(rmse))+((1-g_l).*mean(cost)))';
lbox(:,2)=(g_l.*rmse1)+((1-g_l).*kappa1);

%%

display(mean(rmse,2),'rmse E and I')
display(mean(cost,2),'cost E and I')
loss_ei=mean(g_l.*rmse + ((1-g_l).*cost),2);
display(loss_ei,'loss E and I')

%%

fs=15;
msize=6;
lw=1.2;
lwa=1;
plt1=[0,0,7,6];
blw=2; % box linewidth

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
purple=[0.7,0.1,0.7];

col=[red;blue;purple];

namep={'E','I','1CT'};
namepp={'E-I','1CT'};

%% plot Root Mean Squared Error

yt=[2.5,3.5];

H=figure('name',figname1, 'Position', plt1);
h=boxplot(rmse_box,'Labels',namep,'plotstyle','traditional','colors',col,'Symbol','','BoxStyle','outline');
set(h,{'linew'},{blw})
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('RMSE','fontsize',fs)
ylim([2,4])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size
if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot metabolic cost

yt=[3,5];

H=figure('name',figname2, 'Position', plt1);
h=boxplot(cost_box,'Labels',namep,'plotstyle','traditional','colors',col,'Symbol','','BoxStyle','outline');
set(h,{'linew'},{blw})
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('MC','fontsize',fs)
ylim([2,5.5])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size
if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

