%% plots the tuning curves in E and I neurons for changing levels of a constant stimulus in E and I neurons
% plots the selectivity index in E and I neurons

close all
clear
clc

savefig=0;
savefig2=0;

figname1='tuning_curves';
figname2='selectivity_EI_boxplt';

addpath([cd,'/result/stimulus/'])
savefile=[pwd,'/'];

loadname='tuning_curves';
load(loadname)

%%

fs=15;

pos_vec=[0,0,18,8];
yt=0:30:60;
xt=-5:5:5;

H=figure('name',figname1);
subplot(1,2,1)
hold 
for jj=1:10
    plot(as1,tuningE(:,jj))
end
hold off
title('example E neurons','fontsize',fs-2)

set(gca,'YTick',yt);
set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'fontsize',fs)
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.07]);

subplot(1,2,2)
hold on
for jj=1:10
    plot(as1,tuningI(:,jj))
end
hold off
title('example I neurons','fontsize',fs-2)

set(gca,'YTick',yt)
set(gca,'XTick',xt)
set(gca,'XTickLabel',xt,'fontsize',fs)
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.07]);

axes
h1 = ylabel ('firing rate [Hz]','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+1);
h2 = xlabel ('stimulus feature s_1(t)','units','normalized','Position',[0.5,-0.01,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% for all neurons

car=ones(1,10)./10;
N=size(tuningE,2);

selE=zeros(N,1);
for ii=1:N
    y=tuningE(:,ii)./max(tuningE(:,ii));
    yc=conv(y,car,'same'); % smoothing
    selE(ii)=mean(abs(diff(yc)))./0.1;
end

Ni=size(tuningI,2);
selI=zeros(Ni,1);
for ii=1:Ni
    y=tuningI(:,ii)./max(tuningI(:,ii));
    yc=conv(y,car,'same'); 
    selI(ii)=mean(abs(diff(yc)))./0.1;
end

selE(isnan(selE))=[];
selI(isnan(selI))=[];

display([mean(selE),mean(selI)],'mean selectivity for E and I')

[~,p]=ttest2(selE,selI);
display(p,'p-value for t-test difference between E and I')

[~,pvar]=vartest2(selE,selI);
display(pvar,'p-value for f-test on difference in variance between E and I')

%% plot selectivity of E and I

pos_vec=[0,0,8,7];
red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];

xt=[1,1.5];
yt=0:0.1:0.2;

H=figure('name',figname2,'Position',pos_vec);
hold on
h=boxplot(selE,'Position',1,'colors',red,'Outliersize',3,'Symbol','.');
set(h,{'linew'},{2})
h=boxplot(selI,'Position',1.5,'colors',blue,'Outliersize',3,'Symbol','.');
set(h,{'linew'},{2})
line([1,1.5],[0.22 0.22],'color','k','linewidth',1)
line([1,1],[0.215 0.22],'color','k','linewidth',1)
line([1.5,1.5],[0.215 0.22],'color','k','linewidth',1)
if p>0.05
    text(1.13,0.235,'n.s.','color','k','fontsize',fs)
end
hold off
box off

set(gca,'XTick',xt)
set(gca,'YTick',yt)
set(gca,'XTickLabel',{'Exc','Inh'},'fontsize',fs)
axis([0.5,2,0,0.24])
ylabel('selectivity |dz_i^y /ds_1|','fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
