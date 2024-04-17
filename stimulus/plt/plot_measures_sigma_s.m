
clear all
close all
clc
        
vari='sigmas';
savefig1=0;
savefig2=0;
savefig3=0;

figname1=strcat('loss_',vari);
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);

addpath('result/stimulus/')
savefile=[cd,'/figure/stimulus/sigma_s/'];

loadname=strcat('measures_',vari);
load(loadname)
%%

xvec=sigmas_vec;
vis={'on','off','off'};

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

plt1=[0,0,9,7];
plt2=[0,0,9,10];
xt=xvec(1):3:8;
xlab='STD stimulus \sigma_s';

%%

g_e = 0.5;
g_k = 0.5;
g_l=0.7;

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

mini=0.55;
maxi=1;
delta= (maxi-mini)/3;

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
ylim([2,10])
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
text(0.1,0.8,'cost','units','normalized','color',green,'fontsize',fs)
text(0.1,0.65,'loss','units','normalized','color','k','fontsize',fs)

% arrow
%{
line([optimal_param optimal_param],[mini mini+2*delta],'color','k')
plot(optimal_param,mini,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
%}
hold off

box off
xlim([xvec(1),xvec(end)])
ylim([-0.1,1.1])

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
yt=10:20:30;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colpop{ii});
    text(0.1,0.9-(ii-1)*0.17,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
hold off
box off
xlim([xvec(1),xvec(end)])
%ylim([5,30])

ylabel('firing rate')

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%
yt=0.85:0.1:0.95;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',colpop{ii});
end
hold off
box off

ylabel('coeff. of variation')
xlabel(xlab);
xlim([xvec(1),xvec(end)])
%ylim([0.5,1.5])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)

%op=get(gca,'OuterPosition');
%set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.05 op(3)-0.05 op(4)-0.05]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.0 op(3)-0.02 op(4)+0.04]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end


%% E-I balance

pos_vec=plt2;
rec=zeros(length(xvec),2);
rec(:,1)=meanE(:,1)+meanE(:,2);
rec(:,2)=meanI(:,1)+meanI(:,2);


H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colpop{ii})
    text(0.05, 0.43-(ii-1)*0.18,['in ', namepop{ii}],'units','normalized','color',colpop{ii},'fontsize',fs)
end

hold off
box off

title('average E-I balance')
xlim([xvec(1),xvec(end)])
ylim([-4,0])

ylabel('net current')
%set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.0 op(3)-0.0 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%


subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end

hold off
box off

xlim([xvec(1),xvec(end)])
ylim([0 0.7])
title('temporal E-I balance')
xlabel (xlab)

%set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
ylabel('corr. coefficient')


op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.01 op(2)-0.02 op(3)+0.01 op(4)+0.04]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end


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
display(optimal_param,'best taus')

mini=min(error);
maxi=max(error);
delta= (maxi-mini)/3;

pos_vec=plt2;
yt=0:5:10;
yt2=0.5:0.5:1.5;
%%%%%%%%%%%%%

H2=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rms(:,ii),'color',colpop{ii});
    text(0.08,0.8-(ii-1)*0.15,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end

hold off
box off
ylim([0,10.0])
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
%line([optimal_param optimal_param],[mini+delta mini+5*delta],'color','k')
%hh=plot(optimal_param,min(error)+delta+1,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
%text(optimal_param-.8,mini+4*delta, 'optimal','fontsize',fs-1)
hold off

box off
text(0.1,0.8,'(RMSE^E + RMSE^I ) / 2','units','normalized','fontsize',fs)

xlim([xvec(1),xvec(end)])
%ylim([2,13.0])
ylim([0,10.0])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
xlabel (xlab)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.03 op(3)-0.05 op(4)-0.03]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('root mean squared error','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h1,'visible','on')

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end
%}
