
clear all
close all

namet={'perm_full','perm_partial'};
type=2;

savefig=1;
savefig2=1;

figname=['error_',namet{type}];
figname2=['cost_',namet{type}];

savefile=[cd,'/figure/weights_J/effect_structure/'];
addpath('result/connectivity/')

%% load baseline

loadname='measures_new_perturbation';
load(loadname,'ms','cost')

baseline_error=ms(1,:);
baseline_cost=cost(1,:);

%% load result unstructured connectivity

loadname=['measures_new_',namet{type}];
load(loadname,'ms','Ct','cost')
error_perm=ms./baseline_error;
cost_perm=cost./baseline_cost;

n=length(error_perm);
%% fig. settings

fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};
green=[0.2,0.7,0];
ochre=[0.8,0.7,0.4];
col2={green,ochre};

plt1=[0,0,8,7];

xvec=1:n;
xt=1:n;

xlimit=[0.5,n+0.5];
namep={'RMSE^E','RMSE^I'};
namec={'MC^E','MC^I'};

order=[2,1,3,4];
Co=Ct(order);

titles={'fully','partially'};
if type==1
    yt=[1,4,8]
else
    yt=0:2;
end

maxi=max(error_perm(:)) + max(error_perm(:))*0.2;
maxc=max(cost_perm(:)) + max(cost_perm(:))*0.2;
%% plot RMSE

H=figure('name',figname);

hold on
b=bar(xvec,error_perm(order,:),0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
line([0.5,4.5],[1,1],'LineStyle','--','color',[0.2,0.2,0.2],'LineWidth',lw);
hold off
box off

for ii=1:2
    text(0.55,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',col{ii})
end

xlim(xlimit)

ylim([0,maxi])
if type==2
    title([titles{type},' unstructured'],'fontweight','normal','fontsize',fs)
end
ylabel('relative error','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',Co,'fontsize',fs)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% plot cost
if type==1
    yt=0:2;
else
    yt=[0,1,1.5];
end
H=figure('name',figname2);

hold on
b=bar(xvec,cost_perm(order,:),0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = col2{1};
b(2).FaceColor=col2{2};
line([0.5,4.5],[1,1],'LineStyle','--','color',[0.2,0.2,0.2],'LineWidth',lw);
hold off
box off

for ii=1:2
    text(0.6,0.9-(ii-1)*0.12,namec{ii},'units','normalized','fontsize',fs,'color',col2{ii})
end

xlim(xlimit)
ylim([0,maxc])
if type==2
    title([titles{type},' unstructured'],'fontweight','normal','fontsize',fs)
end
ylabel('relative cost','fontsize',fs)

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
