
%clear all
close all
clc

vari='taux';
g_l=0.7;
g_eps=0.5;

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);
figname4='weighting';

addpath('/Users/vkoren/ei_net/result/stimulus/');
savefile=['/Users/vkoren/ei_net/figure/stimulus/taux/'];

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

%% normalized for plotting

%{
cost_ei_norm= (cost-min(cost))./max(cost - min(cost));
cost_norm=mean(cost_ei_norm,2);

loss_norm=(avloss-min(avloss))./max(avloss - min(avloss));
%}
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
%line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
%plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
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
%line([optimal_param optimal_param],[0.58 0.75],'color','k')
%plot(optimal_param,0.76,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
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
a=1;
rec=zeros(length(xvec),2);
rec(:,1)=meanE(:,1).*a + meanE(:,2).*a;
rec(:,2)=meanI(:,1).*a + meanI(:,2).*a;

yt=[-2,0];

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colerror{ii})
    text(0.1, 0.4-(ii-1)*0.18,['in ', namepop{ii}],'units','normalized','color',colerror{ii},'fontsize',fs)
end
%line([optimal_param optimal_param],[mini maxi],'color','k')
%hh=plot(optimal_param,mini,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);

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
%line([optimal_param optimal_param],[mini maxi],'color','k')
%hh=plot(optimal_param,maxi,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);

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

%op=get(gca,'OuterPosition');
%set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.02 op(3)-0.07 op(4)-0.02]);

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
%% weighting E vs. I

g_ei_vec=0.01:0.01:1;
optimal_ratio_ei=zeros(length(g_ei_vec),1);

for ii=1:length(g_ei_vec)

    avloss_g_ei=g_ei_vec(ii).*loss_ei(:,1) + (1-g_ei_vec(ii)).*loss_ei(:,2);

    [~,idx_ei]=min(avloss_g_ei);
    optimal_ratio_ei(ii)=xvec(idx_ei);
end

display([optimal_ratio_ei(1),optimal_ratio_ei(end)],'range of optimal parameters for different weighting of E and I loss')
%% full range of optimal parameters as a function of weighting of error and cost

glvec=0.01:0.01:1;
optimal_ratio_gl=zeros(length(glvec),1);
for ii=1:length(glvec)

    loss_ei_gl=glvec(ii).*rms + ((1-glvec(ii)).*cost);
    avloss_gl=mean(loss_ei_gl,2); % average across E and I neurons (assuming equal weighting of the loss across E and I neurons)
    [~,idx_gl]=min(avloss_gl);
    optimal_ratio_gl(ii)=xvec(idx_gl);

end

display([optimal_ratio_gl(1),optimal_ratio_gl(end)],'range of optimal parameters for different weighting of error vs. cost')

%% plot optimal param as a function of weighting

xlab_sh='time constant of the stimulus';
hidx=find(g_ei_vec==g_eps);
glidx=find(glvec==g_l);

pos_vec=[0,0,8,10];
xt=0:0.5:1;
yt=0:10:30;
ylimit=[0,15];

H=figure('name',figname4,'visible','on');
%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
hold on
stem(g_ei_vec,optimal_ratio_ei,'color',red)
plot(g_eps,optimal_ratio_ei(hidx)+2,'kv','markersize',13)
hold off
box off

xlabel('weighting loss E vs. I','fontsize',fs)
ylim(ylimit)
xlim([-0.1,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.00 op(3)-0.05 op(4)-0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%%%%%%%%%%%%%%%%

subplot(2,1,2)
hold on
stem(glvec,optimal_ratio_gl,'k')
plot(g_l,optimal_ratio_gl(glidx)+2,'kv','markersize',13)
hold off
box off

xlabel('weighting error vs. cost','fontsize',fs)
ylim(ylimit)
xlim([-0.1,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.00 op(3)-0.05 op(4)-0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

axes
h1 = ylabel (['optimal ',xlab_sh],'units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end
%}
%%

