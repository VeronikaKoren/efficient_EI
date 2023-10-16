
clear all
close all

savefig=0;
savefig2=0;
savefig3=0;
savefig4=0;

figname='fr_cv_d';
figname2='perf_d';
figname3='currents_d';
figname4='rho_d';


addpath('/Users/vkoren/ei_net/result/connectivity/')
savefile='/Users/vkoren/ei_net/figure/ratios/d_ratio/';

loadname='measures_all_d';
load(loadname)
%%
xvec=dvec;

vis={'on','on','on','on'}; % visible or invisible
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
nameE={'ffw','Inh','Net'};
namepop={'Exc','Inh'};

plt1=[0,0,8,7];
plt2=[0,0,8,10];
xt=xvec(1):2:xvec(end);
xlab='d^I: d^E';
%%

pos_vec=plt2;
yt=0:20:50;

H=figure('name',figname,'visible',vis{1});
subplot(2,1,1)
hold on
plot(xvec,frate(:,1),'color',colI{1},'linewidth',lw);
plot(xvec,frate(:,2),'color',colI{2},'linewidth',lw);
hold off
box off

for ii=1:2
    text(0.15,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end

xlim([xvec(1),xvec(end)])
ylim([0,58])

ylabel('firing rate','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%
yt=0.5:0.5:1.5;

subplot(2,1,2)
hold on
plot(xvec,CVs(:,1),'color',red,'linewidth',lw);
plot(xvec,CVs(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('coeff. of variation','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim([xvec(1),xvec(end)])
ylim([0.5,1.5])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%

g=0.5;
error=g.*ms(:,1)+ (1-g).*ms(:,2);
[~,idx]=min(error);
dstar=xvec(idx);
display(dstar,'best d')

mini=min(error);
maxi=max(error);
delta= (maxi-mini)/7;

pos_vec=plt2;
yt=2:2:9;
yt2=0.5:0.5:1.5;
%%%%%%%%%%%%%

H2=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
plot(xvec,sqrt(ms(:,1)),'color',red,'linewidth',lw);
plot(xvec,sqrt(ms(:,2)),'color',blue,'linewidth',lw);

hold off
box off
ylim([2,7.5])
for ii=1:2
    text(0.08,0.9-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end

xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.05 op(3)-0.05 op(4)-0.05]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,error,'color','k','linewidth',lw)
% arrow
line([dstar dstar],[mini+delta mini+3*delta],'color','k','LineWidth',lw-0.5)
hh=plot(dstar,min(error)+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
text(dstar-.8,mini+4*delta, 'optimal','fontsize',fs-1)
hold off

box off
text(0.1,0.9,'(RMSE^E + RMSE^I ) / 2','units','normalized','fontsize',fs-1,'color','k')

xlim([xvec(1),xvec(end)])
ylim([2.5,7.0])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.03 op(3)-0.05 op(4)-0.03]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('root mean squared error','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end

%% mean currents

pos_vec=plt2;
rec=meanE(:,1)+meanE(:,2);
yt=-2:2:2;

H3=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,meanE(:,ii),'color',colE{ii},'linewidth',lw)
   
end
plot(xvec,rec,'--','color',colE{3},'linewidth',lw-0.2)

for ii=1:3
    text(0.05+ (ii-1)*0.15,0.9,nameE{ii},'fontsize',fs,'units','normalized','color',colE{ii})
end
hold off
box off

title('in Excitatory','Fontsize',fs-1)
xlim([xvec(1),xvec(end)])
ylim([-2,2])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%
rec=meanI(:,1)+meanI(:,2);
yt=-10:10:10;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,meanI(:,ii),'color',colI{ii},'linewidth',lw)
end
plot(xvec,rec,'--','color',colI{3},'linewidth',lw-0.2)

for ii=1:3
    text(0.05+ (ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

%text(0.05+2*0.2,0.9,nameE{3},'units','normalized','fontsize',fs,'color',colE{3})
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([-14,14])
title('in Inhibitory','Fontsize',fs-1)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.02 op(3)-0.07 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('mean synaptic current','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

set(H3, 'Units','centimeters', 'Position', pos_vec)
set(H3,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H3,[savefile,figname3],'-dpng','-r300');
end

%% plot correlation of E-I currents

pos_vec=plt1;
yt=0.1:0.2:0.5;
H4=figure('name',figname4,'visible',vis{4});
hold on
plot(xvec,abs(r_ei(:,1)),'color',red,'linewidth',lw);
plot(xvec,abs(r_ei(:,2)),'color',blue,'linewidth',lw);
hold off

ylabel('correlation currents','fontsize',fs)
ylim([0.1,0.5])
xlim([xvec(1),xvec(end)])
box off

text(0.7,0.9,'in Exc','fontsize',fs,'units','normalized','color',red)
text(0.7,0.75,'in Inh','fontsize',fs,'units','normalized','color',blue)

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
gvec=0:0.1:1;

dstar=zeros(length(gvec),1);
for ii=1:length(gvec)
    error=gvec(ii).*sqrt(ms(:,1))+ (1-gvec(ii)).*sqrt(ms(:,2));
    [~,idx]=min(error);
    dstar(ii)=xvec(idx);
end

display(dstar,'d star')
%}