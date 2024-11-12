
clear all
close all

N1ct=400;

figname4=['loss_onlyE_box_',sprintf('%1.0i',N1ct)];
figname5=['loss_onlyE_gL_',sprintf('%1.0i',N1ct)];

savefig4=0;
savefig5=0;

savefile='/Users/vkoren/ei_net/figure/implementation/optimal_loss/onlyE/';
addpath('/Users/vkoren/ei_net/result/implementation/')

%% load results

% E-I net
loadname='loss_measures_optimal_ei';
load(loadname)

if N1ct==400
    loadname='loss_measures_optimal_1CT';
else
    loadname='loss_measures_optimal_1CT_500';
    
end
load(loadname)

g_l=0.7;
%% prepare the boxes

ntr=length(rmse1);

lbox=zeros(ntr,2);
lbox(:,1)=(g_l.*(rmse(1,:))+((1-g_l).*cost(1,:)))';
lbox(:,2)=(g_l.*rmse1)+((1-g_l).*kappa1);

%%

fs=15;
msize=6;
lw=1.2;
lwa=1;
plt1=[0,0,7.5,6];
blw=2; % box linewidth

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
purple=[0.7,0.1,0.7];

col=[red;blue;purple];

namep={'E','I','1CT'};
namepp={'E (E-I)','1CT'};


%% plot loss

maxi=max(lbox(:))+0.2;
mini=min(lbox(:));
d=0.08;

yt=[3,4];

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

ylim([mini-0.2,maxi+0.3])
xlim([0.3,3])
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
    
    avloss(1,jj)=(gl(jj).*(mean(rmse(1,:)))+((1-gl(jj)).*mean(cost(1,:))));
    avloss(2,jj)=(gl(jj).*mean(rmse1))+((1-gl(jj)).*mean(kappa1));

end

%% plot average loss E-I and 1CT as a function of weighting of error and cost

col2={'k',purple};
yt=3:1:5;

H=figure('name',figname5, 'Position', plt1);
hold on
for ii=1:2
    plot(gl,avloss(ii,:),'color',col2{ii})
    text(0.7,0.7+(ii-1)*0.2,namepp{ii},'units','normalized','color',col2{ii},'fontsize',fs)
end
hold off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('average loss','fontsize',fs)

xlabel('weighting error vs. cost (g_L)','fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
ylim([2.5,4.8])

set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig5==1
    print(H,[savefile,figname5],'-dpng','-r300');
end


