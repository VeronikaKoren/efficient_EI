
%clear all
close all
clc
        
vari='sigma';
savefig1=1;
savefig2=1;
savefig3=1;

figname1=strcat('fr_cv_',vari);
figname2=strcat('perf_',vari);
figname3=strcat('EI_balance_',vari);

addpath('result/beta_sigma/')
savefile=[cd,'/figure/beta_sigma/'];

loadname=strcat('measures_all_',vari);
load(loadname)
%%

xvec=sigma_vec;
vis={'on','on','on'};

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

g=0.5;
error=g.*rms(:,1)+ (1-g).*rms(:,2);
[~,idx]=min(error);
optimal_param=xvec(idx);
display(optimal_param,'best sigma')

%% firing rate & CV

pos_vec=plt2;
yt=0:30:60;
mini=min(frate(:,2));
maxi=max(frate(:));
delta= (maxi-mini)/5;


H=figure('name',figname1,'visible',vis{1});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colpop{ii});
    text(0.05,0.75-(ii-1)*0.17,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
hh=plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
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

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

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
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
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

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% performance

pos_vec=plt2;
yt=0:5:10;
yt2=0.5:0.5:1.5;

mini=min(error);
maxi=max(error);
delta= (maxi-mini)/3;

%%%%%%%%%%%%%


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

%% E-I balance

pos_vec=plt2;
rec=zeros(length(xvec),2);
rec(:,1)=meanE(:,1)+meanE(:,2);
rec(:,2)=meanI(:,1)+meanI(:,2);

mini=min(rec(:));
maxi=max(rec(:));
delta= (maxi-mini)/3;


H3=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colpop{ii})
    text(0.8, 0.83-(ii-1)*0.18,['in ', namepop{ii}],'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini+delta/2 maxi-delta],'color','k')
hh=plot(optimal_param,maxi-delta,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
hold off
box off

title('average E-I balance')
xlim([xvec(1),xvec(end)])
%ylim([-2,2])

ylabel('net current')
%set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)+0.01 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%

yt=0.2:0.4:0.6;
mini=min(abs(r_ei(:)));
maxi=max(abs(r_ei(:)));
delta= (maxi-mini)/4;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end
line([optimal_param optimal_param],[maxi+delta maxi - delta],'color','k')
hh=plot(optimal_param,maxi-delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([0.1,0.7])
title('temporal E-I balance')

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt)
ylabel('corr. coefficient')


op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.03 op(3)+0.01 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H3, 'Units','centimeters', 'Position', pos_vec)
set(H3,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H3,[savefile,figname3],'-dpng','-r300');
end


%% optimal parameter for different weighting of RMSE^E and RMSE^I

gvec=0:0.01:1;

optimal_param=zeros(length(gvec),1);
for ii=1:length(gvec)
    error=gvec(ii).*rms(:,1)+ (1-gvec(ii)).*rms(:,2);
    [~,idx]=min(error);
    optimal_param(ii)=xvec(idx);
end

display(optimal_param,'optimal parameter')

%}