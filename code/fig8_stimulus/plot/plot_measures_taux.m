
clear
close all
clc

vari='taux';
g_l=0.7;
g_eps=0.5;

savefig1=0;
savefig2=0;
savefig3=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);

addpath('result/stimulus/')
savefile=pwd;

loadname=strcat('measures_',vari);
load(loadname)

%%

xvec=tauxvec;
vis={'on','on','on','on'};

fs=14;
msize=6;
lw=2.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
colerror={red,blue};

green=[0.2,0.7,0];
olive=[0.1,0.6,0.3];
colcost={green,olive};
colloss={'k',[0.5,0.5,0.5]};

namepop={'Exc','Inh'};

plt2=[0,0,9,10];
xt=0:10:30;
xlab='time const. targets \tau_x';
xlimit=[xvec(1),xvec(end-10)];

%% optimal parameter with respect to the rmse

best_rmse=zeros(2,1);
for ii=1:2

    [~,idxrmse]=min(rms(:,ii));
    best_rmse(ii)=xvec(idxrmse);
end
display(best_rmse,'best param according to RMSE E and I')

% optimal parameter average loss

loss_ei=g_l.*rms + ((1-g_l).*cost);
avloss=mean(loss_ei,2); % average across E and I neurons
[~,idx]=min(avloss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% plot loss measures

name_error={'RMSE^E','RMSE^I'};
name_cost={'MC^E','MC^I'};
nameloss={'loss^E','loss^I'};

mini=min(loss_ei(:,1));
maxi=max(loss_ei(:));
delta=3;

pos_vec=[0,0,9,13];
yt=0:10:20;
%%%%%%%%%%%%%

H=figure('name',figname1,'visible',vis{1});
subplot(3,1,1)
hold on
for ii=1:2
    plot(xvec,rms(:,ii),'color',colerror{ii});
    text(0.1,0.9-(ii-1)*0.2,name_error{ii},'units','normalized','color',colerror{ii},'fontsize',fs)
end

hold off
box off
ylim([0,maxi+2*delta])
xlim(xlimit)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,2)
hold on
for ii=1:2
    plot(xvec,cost(:,ii),'color',colcost{ii});
    text(0.1,0.9-(ii-1)*0.2,name_cost{ii},'units','normalized','color',colcost{ii},'fontsize',fs)
end

hold off
box off
xlim(xlimit)
ylim([0,10])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

subplot(3,1,3)
hold on
for ii=1:2
    plot(xvec,loss_ei(:,ii),'color',colloss{ii});
    text(0.35,0.9-(ii-1)*0.2,nameloss{ii},'units','normalized','color',colloss{ii},'fontsize',fs)
end

% arrow
line([optimal_param optimal_param],[mini+delta mini+4*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off

box off
xlim(xlimit)
ylim([0,25])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('loss measures','units','normalized','Position',[-0.06,0.5,0],'fontsize',fs+2);
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

mini=frate(idx,2);
maxi=max(frate(:));
delta= (maxi-mini)/5;

pos_vec=plt2;
yt=[0,20];

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colerror{ii});
    text(0.8,0.8-(ii-1)*0.17,namepop{ii},'units','normalized','color',colerror{ii},'fontsize',fs)
end
hold off
box off
xlim(xlimit)
ylabel('firing rate [Hz]','fontsize',fs)

ylim([0,30])
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%
yt=0.7:0.3:1.3;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',colerror{ii});
end
hold off
box off

ylabel('coeff. of variation','fontsize',fs)
xlabel (xlab);
xlim(xlimit)
ylim([0.7,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% E-I balance

pos_vec=plt2;
rec=zeros(length(xvec),2);
rec(:,1)=meanE(:,1) + meanE(:,2);
rec(:,2)=meanI(:,1) + meanI(:,2);

yt=[-2,0];

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colerror{ii})
    text(0.1, 0.4-(ii-1)*0.18,['in ', namepop{ii}],'units','normalized','color',colerror{ii},'fontsize',fs)
end

hold off
box off

title('average imbalance','fontsize',fs)
xlim(xlimit)
ylim([-2.5,0.2])

ylabel('net syn. input [mV]','fontsize',fs+1)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.03 op(3)-0.0 op(4)-0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%

yt=[0.2,0.4];
mini=0.1;
maxi=0.2;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colerror{ii},'linewidth',lw)
end
hold off
box off

xlim(xlimit)
ylim([0,0.5])
title('instantaneous balance','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylabel('corr. coefficient','fontsize',fs+1)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.03 op(3)-0.0 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%%

