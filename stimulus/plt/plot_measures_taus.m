
clear all
close all
clc
        
vari='taus';
savefig1=0;
savefig2=1;
savefig3=1;

figname1=strcat('loss_',vari);
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);

addpath('/Users/vkoren/ei_net/result/stimulus/')
savefile='/Users/vkoren/ei_net/figure/stimulus/tau_s/';

loadname=strcat('measures_',vari);
load(loadname)

%%

xvec=taus_vec;
vis={'on','on','on'};

fs=14;
msize=6;
lw=2.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];

colI={red,blue,green};
colE={'k',blue,green};
colpop={red,blue};

nameI={'Exc','Inh','net'};
nameE={'ff','Inh','net'};
namepop={'Exc','Inh'};

plt1=[0,0,9,7];
plt2=[0,0,9,10];
xt=[xvec(1),50,100,150]
xlab='time const. stimulus \tau_s';

%%

% optimal parameter with respect to the rmse

best_rmse=zeros(2,1);
for ii=1:2

    [~,idxrmse]=min(rms(:,ii))
    best_rmse(ii)=xvec(idxrmse)
end
display(best_rmse,'best param according to RMSE E and I')

%% optimal parameter average loss

g_l=0.7;
loss_ei=g_l.*rms + ((1-g_l).*cost);
avloss=mean(loss_ei,2); % average across E and I neurons
[~,idx]=min(avloss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% normalized for plotting

cost_ei_norm= (cost-min(cost))./max(cost - min(cost));
cost_norm=mean(cost_ei_norm,2);

loss_norm=(avloss-min(avloss))./max(avloss - min(avloss));
%% plot loss =measures


name_error={'RMSE^E','RMSE^I'};
name_cost={'MC^E','MC^I'};

mini=0.55;
maxi=1;
delta= (maxi-mini)/3;

pos_vec=plt2;
yt=[0,5];
yt2=[4,8];
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
ylim([0,8])
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on

for ii=1:2
    plot(xvec,cost(:,ii),'color',colpop{ii});
    text(0.1,0.9-(ii-1)*0.17,name_cost{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
%{
plot(xvec,mcost,'color',green)
plot(xvec,loss,'color','k')
text(0.1,0.9,'cost','units','normalized','color',green,'fontsize',fs)
text(0.1,0.75,'loss','units','normalized','color','k','fontsize',fs)
%}

hold off
box off
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylim([2,10])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('loss measures','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+1);
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
yt=10:10:20;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colpop{ii});
    text(0.1,0.95-(ii-1)*0.17,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
hold off
box off
xlim([xvec(1),xvec(end)])
ylim([0,30])

ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.0 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%
yt=[0.7,1];

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',colpop{ii});
end
hold off
box off

ylabel('coeff. variation','fontsize',fs)
xlabel(xlab,'fontsize',fs+1);
xlim([xvec(1),xvec(end)])
ylim([0.5,1.2])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.0 op(3)-0.02 op(4)+0.05]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% E-I balance
yt=-4:2:0;
pos_vec=plt2;

a=1;
rec=zeros(length(xvec),2);
rec(:,1)=meanE(:,1).*a+meanE(:,2).*a;
rec(:,2)=meanI(:,1).*a+meanI(:,2).*a;

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colpop{ii})
    text(0.7, 0.9-(ii-1)*0.18,['to ', namepop{ii}],'units','normalized','color',colpop{ii},'fontsize',fs)
end

hold off
box off

title('average imbalance','fontsize',fs)
xlim([xvec(1),xvec(end)])
ylim([-2,0])

ylabel('net syn. input [mV]','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.0 op(3)-0.0 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%

yt=[0,0.5];

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end

hold off
box off

xlim([xvec(1),xvec(end)])
ylim([0 0.5])
title('instantaneous balance','fontsize',fs)
xlabel (xlab,'fontsize',fs+1)
ylabel('corr. coeff.','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)


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
