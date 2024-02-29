
clear all
close all

figname1='rmse_ei_1ct_box';
figname2='cost_ei_1ct_box';
figname3='sc_ei_1ct_box';
figname4='loss_ei_1ct_box';

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;

savefile='/Users/vkoren/ei_net/figure/implementation/optimal_loss/';
addpath('/Users/vkoren/ei_net/result/implementation/')

%% load results

% E-I net
loadname='loss_optimal_ei';
load(loadname)

% 1 cell type

loadname='loss_measures_1pop';
load(loadname)

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
lbox(:,1)=(mean(rmse)+mean(cost))';
lbox(:,2)=rmse1+kappa1;

%%

fs=14.5;
msize=6;
lw=1.2;
lwa=1;
plt1=[0,0,7,6];
blw=3; % box linewidth

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
purple=[0.7,0.1,0.7];

col=[red;blue;purple];

namep={'Exc','Inh','1 CT'};
namepp={'E-I','1 CT'};

%% plot rmse

yt=[2,3];

H=figure('name',figname1, 'Position', plt1);
h=boxplot(rmse_box,'Labels',namep,'plotstyle','traditional','colors',col,'Symbol','','BoxStyle','outline');
set(h,{'linew'},{blw})
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('RMSE','fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size
if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot cost

yt=[3,5];

H=figure('name',figname2, 'Position', plt1);
h=boxplot(cost_box,'Labels',namep,'plotstyle','traditional','colors',col,'Symbol','','BoxStyle','outline');
set(h,{'linew'},{blw})
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('metabolic cost','fontsize',fs)
ylim([2,6.5])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size
if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
%% plot spike count

yt=[7,14];

H=figure('name',figname3, 'Position', plt1);
h=boxplot(fr_box,'Labels',namep,'plotstyle','traditional','colors',col,'Symbol','','BoxStyle','outline');
set(h,{'linew'},{blw})
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('firing rate [Hz]','fontsize',fs)
ylim([5,15])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% plot loss

yt=[6,7];

H=figure('name',figname4, 'Position', plt1);
h=boxplot(lbox,'Labels',namepp,'plotstyle','traditional','colors',gray,'Symbol','','BoxStyle','outline');
box off
set(h,{'linew'},{blw})

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('average loss','fontsize',fs)
ylim([5.6,8.2])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%% 