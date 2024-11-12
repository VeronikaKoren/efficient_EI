% plot loss from Monte-carlo random search

%%
clear all 
close all
%clc

addpath([cd,'/result/global/']);
loadname='performance_mc_cont';
load(loadname)

%%

figname1='loss_gL';
figname2='global_loss';
figname3='global_error';
figname4='global_cost';
figname5='params_config';

savefig=[0,0,0,0,0];
savefile='/Users/vkoren/ei_net/figure/global/';

%gray=[0.2,0.2,0.2];
blw=2;
pos_vec1=[0,0,9,9];
pos_vec2=[0,0,16,10];
lwa=1.0;
fs=14;

[val,idxglo]=min(loss);
display(idxglo,'best index');
display(theta_all(:,idxglo),'optimal parameter setting');

rms=squeeze(mean(rmse_tr,2));
cost=squeeze(mean(cost_tr,2));

%% plot loss for different weightings gL

glvec=0:0.1:1;
n=length(glvec);
l=zeros(n,size(rms,1));
for ii=1:n
    l(ii,:)=mean(glvec(ii).*rms + ((1-glvec(ii)).*cost),2);
end

x_point=l(:,1);
x_other=l(:,2:end)';
xlabs=cell(n,1);
for ii=1:n
    xlabs{ii}=sprintf('%0.2f',glvec(ii));
end

H=figure('name',figname1,'Position', pos_vec2);
hold on

h=boxplot(x_other,'colors',gray,'Outliersize',6,'Symbol','.'); % can also be symbol = 'x'
plot([1:n]-0.2,x_point,'rx','markersize',8,'linewidth',3)
set(h,{'linew'},{blw})
hold off
box off

text(-0.13,0.35,'average loss','units','normalized','fontsize',fs+1,'Rotation',90)

xlim([0,n+1])
set(gca,'YScale','log')
ylim([1,10000])
%set(gca,'YTick',[3.0,3.4])
set(gca,'XTick',1:2:n)
set(gca,'XTickLabel',xlabs(1:2:n))
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.05 op(3)-0.02 op(4)-0.05]);
xlabel('weighting error vs. cost (g_L)')               

set(H, 'Units','centimeters', 'Position', pos_vec2)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec2(3), pos_vec2(4)]) % for saving in the right size

if savefig(1)==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot loss with gL=0.7 

x=loss;
x_point=x(1); % parameter configuration chosen in the paper
x_other=x(2:end);
[sorted,idx]=sort(x_other);

H=figure('name',figname2,'Position', pos_vec1);
hold on

h=boxplot(x_other,'colors',gray,'Outliersize',6,'Symbol','.'); % can also be symbol = 'x'
plot(0.8,x_point,'rx','markersize',10,'linewidth',3)

hold off

set(h,{'linew'},{blw})
%ho = findobj(gcf,'tag','Outliers');
%ho.MarkerFaceColor='b';

set(gca,'XTick',[])
text(-0.17,0.2,'average loss (g_L = 0.7)','units','normalized','fontsize',fs+1,'Rotation',90)

xlim([0.5,2])
set(gca,'YScale','log')
ylim([1,5000])
%set(gca,'YTick',[3.0,3.4])
box off

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);
                
%%%%%%%% inset

axes('Position',[.6 .5 .3 .35])
box on
hold on
for ii=1:10
    plot(1,x_other(idx(ii)),'v','markersize',6,'linewidth',3)
end
plot(0.8,x_point,'rx','markersize',10,'linewidth',3)
hold off

xlim([0.5,1.5])
ylim([3.1,3.5])
set(gca,'XTick',[])
set(gca,'YScale','log')
set(gca,'YTick',[3.1,3.4])

set(H, 'Units','centimeters', 'Position', pos_vec1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec1(3), pos_vec1(4)]) % for saving in the right size

if savefig(2)==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
 

%% plot encoding error

x=mean(rms,2);
x_point=x(1);
x_other=x(2:end);
[~,idx]=sort(x_other);
best_error=theta_all(:,idx(1));

display(best_error','sigmav,beta,taure, tauri,q,d');

H=figure('name',figname3,'Position', pos_vec1);
hold on

h=boxplot(x_other,'colors',gray,'Outliersize',6,'Symbol','.'); % can also be symbol = 'x'
plot(0.8,x_point,'rx','markersize',10,'linewidth',3)

hold off

set(h,{'linew'},{blw})
ho = findobj(gcf,'tag','Outliers');
ho.MarkerFaceColor='b';

set(gca,'XTick',[])
text(-0.2,0.35,'encoding error','units','normalized','fontsize',fs+1,'Rotation',90)

xlim([0.5,2])
set(gca,'YScale','log')
ylim([1,7000])
%set(gca,'YTick',[3.0,3.4])
box off

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);
                
%%%%%%%% inset

axes('Position',[.6 .5 .3 .35])
box on
hold on
for ii=1:10
    plot(1,x_other(idx(ii)),'v','markersize',6,'linewidth',3)
end
plot(0.8,x_point,'rx','markersize',10,'linewidth',3)
hold off
xlim([0.5,1.5])
ylim([2.5,3.3])
set(gca,'XTick',[])
set(gca,'YScale','log')
set(gca,'YTick',[2.8,3.1])


set(H, 'Units','centimeters', 'Position', pos_vec1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec1(3), pos_vec1(4)]) % for saving in the right size

if savefig(3)==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% plot cost 

x=mean(cost,2);
x_point=x(1);
x_other=x(2:end);
[~,idx]=sort(x_other);
best_cost=theta_all(:,idx(1));

display(best_cost','sigmav,beta,tau^x, taure, tauri,q,d');

H=figure('name',figname4,'Position', pos_vec1);
hold on

h=boxplot(x_other,'colors',gray,'Outliersize',6,'Symbol','.'); % can also be symbol = 'x'
plot(0.8,x_point,'rx','markersize',10,'linewidth',3)

hold off

set(h,{'linew'},{blw})
ho = findobj(gcf,'tag','Outliers');
ho.MarkerFaceColor='b';

set(gca,'XTick',[])
text(-0.2,0.35,'metabolic cost','units','normalized','fontsize',fs+1,'Rotation',90)

xlim([0.5,2])
set(gca,'YScale','log')
ylim([1,7000])
%set(gca,'YTick',[3.0,3.4])
box off

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);
                
%%%%%%%% inset

axes('Position',[.6 .5 .3 .35])
box on
hold on
for ii=1:10
    plot(1,x_other(idx(ii)),'v','markersize',6,'linewidth',3)
end
plot(0.8,x_point,'rx','markersize',10,'linewidth',3)
hold off
xlim([0.5,1.5])
ylim([1.9,3.7])
set(gca,'XTick',[])
set(gca,'YScale','log')
%set(gca,'YTick',[3.1,3.4])

set(H, 'Units','centimeters', 'Position', pos_vec1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec1(3), pos_vec1(4)]) % for saving in the right size

if savefig(4)==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%%
%{
listlab={'\sigma','\beta','\tau_r^E','\tau_r^I','N^E:N^I','<J^{I-I}>:<J^{E-I}>'};

npar=size(theta_all,1);
xvec=1:npar;
ms=6;
pos_vec1=[0,0,18,12];
namecrit={'loss','error','cost'};

red=[0.85,0.32,0.1];
green=[0.2,0.7,0];
col={'k',red,green};

H=figure('name',figname5,'Position', pos_vec1);
hold on
plot(xvec,theta_all(:,idxglo),'o','color',col{1},'markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','k')
plot(xvec+0.1,best_error,'o','color',col{2},'markersize',10,'MarkerFaceColor','r','MarkerEdgeColor','k')
plot(xvec-0.1,best_cost,'o','color',col{3},'markersize',10,'MarkerFaceColor','g','MarkerEdgeColor','k')
hold off
axis([0,npar+1,0,45])
set(gca,'XTick',1:npar)
set(gca,'XTickLabel',listlab)

for ii=1:3
    text(0.7,0.9-(ii-1)*0.12,['minimize ',namecrit{ii}],'units','normalized','color',col{ii},'fontsize',fs)
end

ylabel('parameter value','fontsize',fs+2)
set(H, 'Units','centimeters', 'Position', pos_vec1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec1(3), pos_vec1(4)]) % for saving in the right size

if savefig(5)==1
    print(H,[savefile,figname5],'-dpng','-r300');
end
%}