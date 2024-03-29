
%clear all
close all
clc
        
vari='sigma';
g_l=0.7;

savefig1=0;
savefig2=0;
savefig3=1;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);

addpath('/Users/vkoren/ei_net/result/beta_sigma/')
savefile='/Users/vkoren/ei_net/figure/beta_sigma/';

loadname=strcat('measures_',vari);
load(loadname)
%%

xvec=sigma_vec;
vis={'off','off','on'};

fs=13;
msize=6;
lw=2.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];

colI={red,blue,green};
colE={'k',blue,green};
colpop={red,blue};

nameI={'Exc','Inh','Net'};
nameE={'ffw','Inh','Net'};
namepop={'Exc','Inh'};

plt1=[0,0,8,7];
plt2=[0,0,8,10];
xt=xvec(1):10:xvec(end)-5;
xlab='noise intensity \sigma';

%% optimal parameter

g_e = 0.5;
g_k = 0.5;

eps=(rms-min(rms))./max(rms-min(rms));
kappa= (cost-min(cost))./max(cost - min(cost));
error=(g_e*eps(:,1)) + ((1-g_e)*eps(:,2));
mcost=(g_k*kappa(:,1)) + ((1-g_k)*kappa(:,2));
loss=(g_l*error) + ((1-g_l) * mcost);

[~,idx]=min(loss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% plot loss measures

name_error={'RMSE^E','RMSE^I'};

mini=min(loss);
maxi=max(loss);
delta= (maxi-mini)/5;

pos_vec=plt2;
yt=2:3:8;
yt2=[0,1];
%%%%%%%%%%%%%

H=figure('name',figname1,'visible',vis{1});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rms(:,ii),'color',colpop{ii});
    text(0.1,0.9-(ii-1)*0.17,name_error{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end

hold off
box off
ylim([2,7.5])
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,mcost,'color',green)
plot(xvec,loss,'color','k')
text(0.32,0.9,'cost','units','normalized','color',green,'fontsize',fs)
text(0.32,0.7,'loss','units','normalized','color','k','fontsize',fs)

%ylim([2,6])
% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off

box off
%text(0.25,0.8,'(RMSE^E + RMSE^I ) / 2','units','normalized','fontsize',fs)
xlim([xvec(1),xvec(end)])
ylim([0,1])

set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('loss measures','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+2);
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% firing rate & CV

pos_vec=plt2;
yt=0:30:60;

mini=min(frate(:,2));
maxi=max(frate(:));
delta= (maxi-mini)/5;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colpop{ii});
    text(0.25,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off
xlim([xvec(1),xvec(end)])
ylabel('firing rate')

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

%set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%
yt=0.7:0.3:1.3;
mini=min(CVs(:,2));
maxi=max(CVs(:,1));
delta= (maxi-mini)/3;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',colpop{ii});
end
line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

ylabel('coeff. of variation')

xlim([xvec(1),xvec(end)])
ylim([0.6,1.4])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

axes
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end


%% E-I balance
a=0.3;
pos_vec=plt2;
rec=zeros(length(xvec),2);
rec(:,1)=meanE(:,1)*a + meanE(:,2)*a;
rec(:,2)=meanI(:,1)*a + meanI(:,2)*a;

mini=min(rec(:));
maxi=max(rec(:));
delta= (maxi-mini)/2.5;
yt=[-1,0];
H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colpop{ii})
    text(0.7, 0.83-(ii-1)*0.18,['to ', namepop{ii}],'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini+delta/2 maxi-delta],'color','k')
plot(optimal_param,maxi-delta,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

title('average imbalance','fontsize',fs)
xlim([xvec(1),xvec(end)])
ylim([-1.5,0])

ylabel('net syn. input [mV]','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)+0.01 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%

yt=0.2:0.4:0.6;
mini=min(abs(r_ei(:)));
maxi=mean(abs(r_ei(:)));
delta= (maxi-mini)/4;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end
line([optimal_param optimal_param],[0.27 0.42],'color','k')
hh=plot(optimal_param,0.27,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([0.1,0.7])
title('instantaneous balance','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylabel('corr. coefficient','fontsize',fs)


op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.03 op(3)+0.01 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% test full range of weighting of error and cost

glvec=0:0.1:1;
optimal=zeros(length(glvec),1);
for ii=1:length(glvec)
    loss=(glvec(ii)*error) + ((1-glvec(ii)) * mcost);
    [~,idx]=min(loss);
    optimal(ii)=xvec(idx);
end

display(optimal,'optimal parameters for different weighting of error vs. cost')

figure('visible','off')
stem(glvec,optimal,'r')
xlabel('weighting of error  g_L')
ylabel('optimal parameter')

%% average E-I balance all currents
%{
pos_vec=plt2;
rec=meanE(:,1)+meanE(:,2);


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

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%
rec=meanI(:,1)+meanI(:,2);

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,meanI(:,ii),'color',colI{ii},'linewidth',lw)
end
plot(xvec,rec,'--','color',colI{3},'linewidth',lw-0.2)

for ii=1:3
    text(0.05+ (ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

hold off
box off

xlim([xvec(1),xvec(end)])
title('in Inhibitory','Fontsize',fs-1)

%set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt,'fontsize',fs)
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
%}
%% performance

%{
g=0.5;
error=g.*rms(:,1)+ (1-g).*rms(:,2);
[~,idx]=min(error);
optimal_param=xvec(idx);
display(optimal_param,'best sigma')

pos_vec=plt2;
yt=0:5:10;
yt2=0.5:0.5:1.5;

mini=min(error);
maxi=max(error);
delta= (maxi-mini)/3;

%%%%%%%%%%%%%

name_error={'RMSE^E','RMSE^I','(RMSE^E+RMSE^I) / 2'};

H2=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rms(:,ii),'color',colpop{ii});
    text(0.08,0.9-(ii-1)*0.15,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end

hold off
box off
ylim([2,10.0])
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.05 op(3)-0.05 op(4)-0.05]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,error,'color','k')
% arrow
line([optimal_param optimal_param],[mini+delta mini+4*delta],'color','k')
hh=plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
%text(optimal_param-.8,mini+4*delta, 'optimal','fontsize',fs-1)
hold off

box off
text(0.3,0.8,'(RMSE^E + RMSE^I ) / 2','units','normalized','fontsize',fs)

xlim([xvec(1),xvec(end)])
ylim([2,10.0])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
%xlabel (xlab)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)+0.0 op(4)+0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('root mean squared error','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+2);
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end

%}