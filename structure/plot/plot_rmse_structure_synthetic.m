
clear all
close all

savefig=0;
savefig2=0;
savefig3=0;

figname='mse_full_permJ';
figname2='mse_partial_permJ';
figname3='mse_synthetic_permC';

savefile=[cd,'/figure/weights_J/'];

addpath('/Users/vkoren/ei_net/result/connectivity/')
%addpath('result/connectivity/')
namet={'perm_full','perm_partial'};
%%
loadname='Cnoise_factor_measures';
load(loadname,'ms')

baseline=sqrt(ms(1,:));
%%
mse_all=cell(2,1);

for k=1:2
    loadname=['measures_',namet{k}];
    load(loadname,'ms','Ct')
    mse_all{k}=ms;
end
%%

fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};

plt1=[0,0,8,7];

xlb=Ct;
xvec=1:4;
xt=1:4;

xlimit=[0.5,4.5];
namep={'Exc','Inh'};
Ct{4}(4:end)=[];
order=[2,1,3,4];
Co=Ct(order);

%%

%yt=0:10:30; % absolute
yt=0:3:10;
H=figure('name',figname);

hold on
b=bar(xvec,sqrt(mse_all{1}(order,:))./baseline,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
hold off
box off

for ii=1:2
    text(0.7,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',col{ii})
end

hl=line([0.5,4.5],[1,1],'LineStyle','--','color',[0.2,0.2,0.2],'LineWidth',lw);
xlim(xlimit)
ylim([0,12])

title('full permutation','fontweight','normal','fontsize',fs)
ylabel('relative root MSE','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
%set(gca,'XTicklabel',Co,'fontsize',fs)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%% partial perm

yt=0:2;

H=figure('name',figname);

hold on
b=bar(xvec,sqrt(mse_all{2}(order,:))./baseline,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
hold off
box off

hl=line([0.5,4.5],[1,1],'LineStyle','--','color',[0.2,0.2,0.2],'LineWidth',lw);
title('partial permutation','fontweight','normal','fontsize',fs)

xlim(xlimit)

ylabel('relative root MSE','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',Co,'fontsize',fs)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
%%

yt=[1,5,9];
stemcell=cell2mat(cellfun(@(x) sqrt(x(end,:))./baseline,mse_all,'un',0));
x=1:2;
X=[x-0.1;x+0.1];
labels={'full perm.','partial perm.'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=figure('name',figname3);

hold on
b=stem(X',stemcell,'d','filled');
b(1).Color = col{1};
b(2).Color=col{2};
bb=b.BaseLine;
bb.Visible='off';
line([0.5,2.5],[1,1],'color','k','LineStyle','--')
hold off
box off

for ii=1:2
    text(0.75,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',col{ii})
end

xlim([0.3,2.7])
ylim([0,12])

ylabel('relative root MSE','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',labels,'fontsize',fs)
xtickangle(25)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end