
clear all
close all
clc

savefig1=0;
savefig2=0;
savefig3=0;

namec='perturbation';             

figname1=['CV_',namec];
figname2=['rmse_fr_',namec];
figname3=['EI-balance_',namec];

addpath('/Users/vkoren/ei_net/result/connectivity/' )
%addpath('result/connectivity/')
savefile=[cd,'/figure/'];

loadname=['measures_',namec];
load(loadname)
%%
xvec=fvec;
vis={'on','on','on'};

fs=13;
msize=6;
lw=2.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
colpop={red,blue};
namepop={'Exc','Inh'};

plt2=[0,0,8,10];
plt1=[0,0,9,7];

if cases==1
    xt=0:0.5:1;
    xlimit=[fvec(1),fvec(5)];
else
    xt=0:0.25:0.6;
    xlimit=[fvec(1),fvec(7)];
end

xlab='perturbation strength';
%%

pos_vec=plt1;
yt=0.5:0.5:1;

H=figure('name',figname1,'visible',vis{1});
hold on
for ii=1:2
    plot(fvec,CVs(:,ii),'color',colpop{ii});
    text(0.08,0.9-(ii-1)*0.15,namepop{ii},'units','normalized','fontsize',fs,'color',colpop{ii})
end
hold off
box off

ylabel('coefficient of variation')
xlabel(xlab);
xlim(xlimit)
ylim([0.5,1.5])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% RMSE and firing rate


pos_vec=plt2;
%yt=[1,10,100];
%ytl={'10^0','10^1','10^2'};

H2=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(fvec,sqrt(ms(:,ii)),'color',colpop{ii});
    text(0.08,0.9-(ii-1)*0.15,namepop{ii},'units','normalized','fontsize',fs,'color',colpop{ii})
end
hold off
box off

xlim(xlimit)
ylim([1,600])
set(gca,'YScale','log')
ylabel('Root MSE')
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%
subplot(2,1,2)
hold on
for ii=1:2
    plot(fvec,frate(:,ii),'color',colpop{ii});
end
hold off
box off

xlim(xlimit)
ylim([0,120])
xlabel(xlab);
ylabel('firing rate [Hz]')

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end
%}
%% E-I balance

pos_vec=plt2;
rec(:,1)=meanE(:,1)+meanE(:,2);
rec(:,2)=meanI(:,1)+meanI(:,2);

H3=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(fvec,rec(:,ii),'color',colpop{ii})
    text(0.1,0.7-(ii-1)*0.18,0.9,['in ',namepop{ii}],'units','normalized','fontsize',fs,'color',colpop{ii})
end
hold off
box off

title('average E-I balance')
ylabel('net current')
xlim(xlimit)

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%

yt=0:.25:.5;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end

hold off
box off
title('temporal E-I balance')
xlim(xlimit)
ylim([0.2,0.5])
ylabel('corr. coefficient')
xlabel (xlab,'fontsize',fs);


set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H3, 'Units','centimeters', 'Position', pos_vec)
set(H3,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H3,[savefile,figname3],'-dpng','-r300');
end


