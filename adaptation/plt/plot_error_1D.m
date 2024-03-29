
clear all
close all
clc

savefig=0;
savefig2=0;
savefig3=0;
savefig4=0;
savefig5=0;
savefig6=0;

cases=1;

namec={'local_current_E','local_current_I'};
namevar={'\tau_r^E','\tau_r^I'};

figname=['fr_cv_',namec{cases}];
figname2=['perf_',namec{cases}];
figname3=['currents_',namec{cases}];
figname4=['rho_',namec{cases}];
figname5=['fr_',namec{cases}];
figname6=['net_rho_',namec{cases}];

addpath('/Users/vkoren/ei_net/result/adaptation/')
savefile=[cd,'/figure/adaptation/'];

loadname=['measures_', namec{cases}];
load(loadname)
%%

vis={'off','on','on','on','off','off'};
%%
fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];

colI={red,blue,green};
colE={'k',blue,green};

nameI={'Exc','Inh','Net'};
nameE={'ff','Inh','Net'};

plt1=[0,0,8,7];
plt2=[0,0,8,10];

xlab=namevar{cases};
xvec=variable;
xt=[10,200,400];
xtl=xt;
xlimit=[10,500];
%%

pos_vec=plt2;
yt=[1,10,100,1000];
ytl={'10^0','10^1','10^2','10^3'};

H=figure('name',figname,'visible',vis{1});
subplot(2,1,1)
hold on
plot(xvec,frate(:,1),'color',colI{1},'linewidth',lw);
plot(xvec,frate(:,2),'color',colI{2},'linewidth',lw);
hold off
box off
%set(gca,'YScale','log')

for ii=1:2
    text(0.7,0.8-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs-1,'color',colI{ii})
end

xlim(xlimit)
ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yt=[0.5,1];

subplot(2,1,2)
hold on
plot(xvec,CVs(:,1),'color',red,'linewidth',lw);
plot(xvec,CVs(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('coeff. variation','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim(xlimit)
ylim([0.5,1.3])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
g=0.5;
error=g.*sqrt(ms(:,1))+ (1-g).*sqrt(ms(:,2));
[~,idx]=min(error);
dstar=variable(idx);
display(dstar,'best tau_f');
%%
pos_vec=plt2;

H2=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
plot(xvec,sqrt(ms(:,1)),'color',red,'linewidth',lw);
plot(xvec,sqrt(ms(:,2)),'color',blue,'linewidth',lw);
%plot(xvec,error,'color','k','linewidth',lw);
hold off
box off

for ii=1:2
    text(0.8,0.7-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs-1,'color',colI{ii})
end

xlim(xlimit)
if cases==1
    ylim([1,20])
    yt=[1,10];
    ytl={'10^0','10^1'};
    
else
    ylim([1,120])
    yt=[1,10,100];
    ytl={'10^0','10^1','10^2'};
end
set(gca,'YScale','log')
ylabel('Root MSE','fontsize',fs)

%yt=get(gca,'YTick');
set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.02 op(3)-0.01 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

subplot(2,1,2)
plot(xvec,ratios(:,1),'color',red,'linewidth',lw)
hold on
plot(xvec,ratios(:,2),'color',blue,'linewidth',lw)
hold off
box off
set(gca,'YScale','log')

xlim(xlimit)
if cases==1
    ylim([0.01,3])
    yt2=[0.01,.1,1];
    ytl2={'10^{-2}','10^{-1}','10^0'};
else
    ylim([0.1,80])
    yt2=[0.1,1,10];
    ytl2={'10^{-1}','10^0','10^1'};
end
ylabel('ratio variance','fontsize',fs)

set(gca,'YTick',yt2)
set(gca,'YTicklabel',ytl2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
xlabel (xlab,'fontsize',fs);

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.02 op(3)-0.01 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

%axes
%h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.06,0],'fontsize',fs);
%set(gca,'Visible','off')
%set(h2,'visible','on')

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end
%}
%%

pos_vec=plt2;
rec=meanE(:,1)+meanE(:,2);
yt=[-1,0];

H3=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,meanE(:,ii),'color',colE{ii},'linewidth',lw)
    text(0.05+(ii-1)*0.15,0.9,nameE{ii},'units','normalized','fontsize',fs,'color',colE{ii})
end
line([10,500],[0,0])
plot(xvec,rec,'--','color',colE{3},'linewidth',lw-0.2)

text(0.05+ 2*0.17,0.9,nameE{3},'units','normalized','fontsize',fs,'color',colE{3})
hold off
box off

xlim(xlimit)
%ylim([-3,3])
ylabel('currents in E','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.02 op(3)-0.02 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%
rec=meanI(:,1)+meanI(:,2);
yt=-5:5:5;

subplot(2,1,2)
hold on

for ii=1:2
    plot(xvec,meanI(:,ii),'color',colI{ii},'linewidth',lw)
    text(0.05+(ii-1)*0.17,0.9,nameI{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end
%}
line([10,500],[0,0])
plot(xvec,rec,'--','color',colI{3},'linewidth',lw-0.2)

text(0.05+2*0.17,0.9,nameE{3},'units','normalized','fontsize',fs,'color',colE{3})
hold off
box off

xlim(xlimit)
%ylim([-6,9])

ylabel('currents in I','fontsize',fs)
xlabel (xlab,'fontsize',fs);

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.02 op(3)-0.02 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H3, 'Units','centimeters', 'Position', pos_vec)
set(H3,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H3,[savefile,figname3],'-dpng','-r300');
end

%% plot correlation of E-I currents

pos_vec=[0,0,7,6];

H4=figure('name',figname4,'visible',vis{4});
hold on
plot(xvec,r_ei(:,1),'color',colI{1},'linewidth',lw);
plot(xvec,r_ei(:,2),'color',colI{2},'linewidth',lw);
hold off

ylabel('corr. currents','fontsize',fs)
ylim([-0.5,0.08])
xlim(xlimit)
box off
if cases==1
    for ii=1:2
        text(0.05,0.9-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs,'color',colI{ii})
    end
end
%legend('in E neurons','in I neurons','fontsize',fs-2,'Location','NorthWest')

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

xlabel (xlab,'fontsize',fs);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%
set(H4, 'Units','centimeters', 'Position', pos_vec)
set(H4,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig4==1
    print(H4,[savefile,figname4],'-dpng','-r300');
end
%% 

pos_vec=[0,0,7,6];

yt=[1,10,100,1000];
ytl={'10^0','10^1','10^2','10^3'};

H5=figure('name',figname5,'visible',vis{5});

hold on
plot(xvec,frate(:,1),'color',red,'linewidth',lw);
plot(xvec,frate(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('firing rate [Hz]','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim(xlimit)
ylim([0.7,100])
set(gca,'YScale','log')

if cases==1
    for ii=1:2
        text(0.7,0.9-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs,'color',colI{ii})
    end
end

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H5, 'Units','centimeters', 'Position', pos_vec)
set(H5,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig5==1
    print(H5,[savefile,figname5],'-dpng','-r300');
end

%% plot net current

pos_vec=plt2;

recE=meanE(:,1)+meanE(:,2);
recI=meanI(:,1)+meanI(:,2);

H=figure('name',figname6,'visible',vis{6});
subplot(2,1,1)
hold on
plot(xvec,recE,'color',red,'linewidth',lw);
plot(xvec,recI,'color',blue,'linewidth',lw);
hold off
box off

for ii=1:2
    text(0.7,0.5-(ii-1)*0.15,['in ', nameI{ii}],'units','normalized','fontsize',fs-1,'color',colI{ii})
end

xlim(xlimit)
if cases==1
    ylim([-3,0.1])
    yt=[-2,0];
else
    ylim([-5,25])
    yt=[0:10:20];
end
ylabel('net current','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%

subplot(2,1,2)
hold on
plot(xvec,r_ei(:,1),'color',colI{1},'linewidth',lw);
plot(xvec,r_ei(:,2),'color',colI{2},'linewidth',lw);
hold off

ylabel('corr. currents','fontsize',fs)

ylim([-0.5,0.08])
yt=-0.5:0.25:0;

xlim(xlimit)
box off

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

xlabel (xlab,'fontsize',fs);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig6==1
    print(H,[savefile,figname6],'-dpng','-r300');
end
%}