
clear all
close all

savefig1=0;

figname='beta_EI';

addpath('/Users/vkoren/ei_net/result/connectivity/')
savefile=[cd,'/figure/implementation/'];

loadname='measures_mu';
load(loadname)

%%
xvec=muvec;

vis={'on','on'};
%%
fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];

col={red,blue};

namect={'Exc','Inh'};


xt=0:10:30;
xlab='metabolic constant \beta';

%% plot firing rate

yt=0:10:20;
plt1=[0,0,8,6];
pos_vec=plt1;

H=figure('name',figname,'visible',vis{1});

hold on
plot(xvec,sc(:,2),'color',col{2});
plot(xvec,sc(:,1),'color',col{1});
hold off
box off

for ii=1:2
    text(0.7,0.85-(ii-1)*0.15,namect{ii},'units','normalized','fontsize',fs,'color',col{ii})
end

xlim([xvec(1),xvec(end)])
%ylim([0,58])

ylabel('f. rate [Hz]')
xlabel (xlab);

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTick',xt)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%}
%%

%{
plt3=[0,0,8,10];
pos_vec=plt3;

H=figure('name',figname,'visible',vis{1});
subplot(3,1,1)
hold on
plot(xvec,sc(:,2),'color',col{2},'linewidth',lw);
plot(xvec,sc(:,1),'color',col{1},'linewidth',lw);
hold off
box off

for ii=1:2
    text(0.7,0.85-(ii-1)*0.25,namect{ii},'units','normalized','fontsize',fs,'color',col{ii})
end

xlim([xvec(1),xvec(end)])
%ylim([0,58])

ylabel('f. rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%
%yt=0.5:0.5:1.5;

subplot(3,1,2)
hold on
plot(xvec,Rmse(:,1),'color',red,'linewidth',lw);
plot(xvec,Rmse(:,2),'color',blue,'linewidth',lw);
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([1,6.5])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',0:3:6)
set(gca,'YTicklabel',0:3:6,'fontsize',fs)
ylabel('RMSE','fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,3)
hold on
plot(xvec,cost(:,1),'color',red,'linewidth',lw);
plot(xvec,cost(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('cost','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim([xvec(1),xvec(end)])
%ylim([0.5,1.5])

set(gca,'XTick',xt,'fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%}