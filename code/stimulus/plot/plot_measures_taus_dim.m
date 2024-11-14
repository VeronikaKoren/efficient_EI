
clear all
close all
clc
        
vari='taus_dim';

savefig1=0;
savefig2=0;

figname1=strcat('error_',vari);
figname2=strcat('loss_',vari);

addpath('/Users/vkoren/ei_net/result/stimulus/')
savefile='/Users/vkoren/ei_net/figure/stimulus/taus_dim/';

loadname=strcat('measures_',vari);
load(loadname)

%%

rmse_e=sqrt(mean(mse_dim(:,:,1),2)); % root mean squared error as evaluated for all parameters 
rmse_i=sqrt(mean(mse_dim(:,:,2),2));
rms=cat(2,rmse_e,rmse_i);

xvec=taus_dim(3,:);
vis={'on','on'};

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
coldim={'k','m',green};

nameI={'Exc','Inh','net'};
nameE={'ff','Inh','net'};
namepop={'Exc','Inh'};

plt1=[0,0,9,7];
plt2=[0,0,9,10];
xt=50:100:350;
%xt=[50,100,150];
xlab='time const. stim. 3 \tau^s_3 [ms]';

%% plot error in every dimension

name_error={'dim. 1','dim. 2','dim. 3'};

maxi=18;

yt=[0,10];
ylimit=[0,maxi];
pos_vec=[0,0,9,12];
%%%%%%%%%%%%%

H=figure('name',figname1);
subplot(2,1,1)

hold on
for ii=1:3
    plot(xvec,squeeze(mse_dim(:,ii,1)),'color',coldim{ii});
    text(0.1+(ii-1)*0.25,0.8,name_error{ii},'units','normalized','color',coldim{ii},'fontsize',fs)
end

hold off
text(0.08,1.35,'time const. stim. 2 \tau^s_2 [ms]','units','normalized','fontsize',fs)
text(1.02,0.5,'E','units','normalized','fontsize',fs)
%text(0.1,-.3,'time const. stimulus 3 \tau^s_3','units','normalized','fontsize',fs)

box on
for jj=1:length(xt)
    text(xt(jj)-11,maxi+2, sprintf('%1.0i', xt(jj)/2),'fontsize',fs)
end

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylim(ylimit)
xlim([xvec(1),xvec(end)])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt, 'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)-0.03 op(3)-0.02 op(4)-0.07]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on

for ii=1:3
    plot(xvec,squeeze(mse_dim(:,ii,2)),'color',coldim{ii});
    text(0.1+(ii-1)*0.25,0.8,name_error{ii},'units','normalized','color',coldim{ii},'fontsize',fs)
end

hold off
box on

for jj=1:length(xt)
    text(xt(jj)-11,maxi+2, sprintf('%1.0i', xt(jj)/2),'fontsize',fs)
end
xlim([xvec(1),xvec(end)])
%text(0.1,1.3,'time const. stimulus 2 \tau^s_2','units','normalized','fontsize',fs)
text(0.08,-.4,'time const. stim. 3 \tau^s_3 [ms]','units','normalized','fontsize',fs)
text(1.02,0.5,'I','units','normalized','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylim(ylimit)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.07]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('mean squared error (\tau_1^s=10 ms)','units','normalized','Position',[-0.04,0.5,0],'fontsize',fs+1);
%h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.01,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
%set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot loss measures

name_error={'RMSE^E','RMSE^I'};
name_cost={'MC^E','MC^I'};

maxi=7;
yt=[0,5];
yt2=[0,5];
ylimit=([0,maxi]);

%%%%%%%%%%%%%

H=figure('name',figname2,'visible',vis{1});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rms(:,ii),'color',colpop{ii});
    text(0.08,0.85-(ii-1)*0.17,name_error{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end

for jj=1:length(xt)
    text(xt(jj)-11,maxi+1, sprintf('%1.0i', xt(jj)/2),'fontsize',fs)
end

text(0.1,1.35,'time const. stim. 2 \tau^s_2 [ms]','units','normalized','fontsize',fs)

hold off
box on
ylim(ylimit)
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)-0.05 op(3)-0.02 op(4)-0.04]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on

for ii=1:2
    plot(xvec,cost(:,ii),'color',colpop{ii});
    text(0.08,0.3-(ii-1)*0.17,name_cost{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end

for jj=1:length(xt)
    text(xt(jj)-11,maxi+1, sprintf('%1.0i', xt(jj)/2),'fontsize',fs)
end

hold off
box on
xlim([xvec(1),xvec(end)])
text(0.08,-.4,'time const. stim. 3 \tau^s_3 [ms]','units','normalized','fontsize',fs)

set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylim(ylimit)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.07]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('loss measures (\tau_1^s=10 ms)','units','normalized','Position',[-0.04,0.5,0],'fontsize',fs+1);
%h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.01,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
%set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

