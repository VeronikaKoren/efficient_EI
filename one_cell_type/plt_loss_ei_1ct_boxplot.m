
clear all
close all

figname1='rmse_ei_1ct_box';
figname2='cost_ei_1ct_box';
%figname3='sc_ei_1ct_box';
figname4='loss_ei_1ct_box';
figname5='loss_weighting';

savefig1=1;
savefig2=1;
%savefig3=1;
savefig4=1;
savefig5=1;

savefile='/Users/vkoren/ei_net/figure/implementation/optimal_loss/';
addpath('/Users/vkoren/ei_net/result/implementation/')

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

fs=14.5;
msize=6;
lw=1.2;
lwa=1;
plt1=[0,0,7,6];
blw=2; % box linewidth

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
purple=[0.7,0.1,0.7];

col=[red;blue;purple];

namep={'Exc','Inh','1CT'};
namepp={'E-I','1CT'};

%% plot rmse

yt=[2,3,4];

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

%% plot cost

yt=[3,5];

H=figure('name',figname2, 'Position', plt1);
h=boxplot(cost_box,'Labels',namep,'plotstyle','traditional','colors',col,'Symbol','','BoxStyle','outline');
set(h,{'linew'},{blw})
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('metabolic cost (MC)','fontsize',fs)
ylim([2,6.5])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size
if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% plot loss

maxi=max(lbox(:));
mini=min(lbox(:));
d=0.05;

yt=[3,3.5];

[~,p]=ttest2(lbox(:,1),lbox(:,2));

H=figure('name',figname4, 'Position', plt1);
hold on
h=boxplot(lbox,'Labels',namepp,'plotstyle','traditional','colors',gray,'Symbol','','BoxStyle','outline');
if p<0.05
    line([1,2],[maxi,maxi],'color','k')
    line([1,1],[maxi-d,maxi],'color','k')
    line([2,2],[maxi-d,maxi],'color','k')
    text(1.4,maxi+0.05,'*','fontsize',25)
end
hold off
box off
set(h,{'linew'},{blw})

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel(['average loss (g_L=',sprintf('%0.1f',g_l),')'],'fontsize',fs)

ylim([mini-0.2,maxi+0.2])
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%% 
n=100;
gl=linspace(0,1,n);
avloss=zeros(2,n);
for jj=1:100
    
    avloss(1,jj)=(gl(jj).*(mean(mean(rmse)))+((1-gl(jj)).*mean(mean(cost))));
    avloss(2,jj)=(gl(jj).*mean(rmse1))+((1-gl(jj)).*mean(kappa1));

end

%% plot average loss E-I and 1CT as a function of weighting of error and cost

col2={'k',purple};
yt=3:1:5;

H=figure('name',figname5, 'Position', plt1);
hold on
for ii=1:2
    plot(gl,avloss(ii,:),'color',col2{ii})
    text(0.7,0.9-(ii-1)*0.2,namepp{ii},'units','normalized','color',col2{ii},'fontsize',fs)
end
hold off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('average loss','fontsize',fs)

xlabel('weighting error vs. cost (g_L)','fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
ylim([2.5,4.5])

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig5==1
    print(H,[savefile,figname5],'-dpng','-r300');
end

%% plot spike count
%{
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
%}
