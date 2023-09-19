clear all
close all

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;


figname='fr_cv_q';
figname2='perf_q';
figname3='currents_q';
figname4='rho_q';
 
addpath('result/connectivity/')
savefile=[cd,'/figure'];

loadname='measures_all_q';
load(loadname)

xvec=qvec;
vis={'on','on','on','on'};
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

plt1=[0,0,9,7];
plt2=[0,0,9,10];
xt=xvec(1):2:xvec(end);
xlab='N^E:N^I';

%% firing rate and CV

pos_vec=plt2;
yt=0:10:30;

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

xlim([xvec(1),xvec(end-2)])
ylim([0,37])

ylabel('firing rate','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%
yt=0.5:0.5:1.5;

subplot(2,1,2)
hold on
plot(xvec,CVs(:,1),'color',red,'linewidth',lw);
plot(xvec,CVs(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('coeff. of variation','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim([xvec(1),xvec(end-2)])
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
    print(H,[savefile,figname],'-dpng','-r300');
end

%% RMS

g=0.5;
error=g.*ms(:,1)+ (1-g).*ms(:,2);
[~,idx]=min(error);
qstar=xvec(idx);
display(qstar,'best q')

mini=min(error);
maxi=max(error);
delta= (maxi-mini)/5;
%%%%%%%%%%%%%%%%

pos_vec=plt2;
yt=[2.7,3.5];

H2=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
plot(xvec,sqrt(ms(:,1)),'color',red,'linewidth',lw);
plot(xvec,sqrt(ms(:,2)),'color',blue,'linewidth',lw);
hold off
box off

for ii=1:2
    text(0.1,0.95-(ii-1)*0.15,namepop{ii},'units','normalized','fontsize',fs-1,'color',colI{ii})
end

xlim([xvec(1),xvec(end-2)])
ylim([2.4,3.7])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.09 op(2)+0.02 op(3)-0.09 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,error,'color','k','linewidth',lw)
% arrow
line([qstar qstar],[mini+delta mini+3*delta],'color','k','LineWidth',lw-0.5)
hh=plot(qstar,min(error)+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','g','LineWidth',lw-0.5);
text(qstar-.8,mini+4*delta, 'optimal','fontsize',fs-1)
hold off

box off
text(0.1,0.9,'(RMSE^E + RMSE^I ) / 2','units','normalized','fontsize',fs,'color','k')
%title('(RMSE^E + RMSE^I) / 2','fontsize',fs-4)

xlim([xvec(1),xvec(end-2)])
ylim([2.6,3.7])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.09 op(2)+0.05 op(3)-0.09 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('root mean sqared error','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end

%% mean syn. current


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
    text(0.05+ (ii-1)*0.15,0.8,nameE{ii},'fontsize',fs,'units','normalized','color',colE{ii})
end
hold off
box off

title('in Excitatory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
ylim([-2.5,2.5])

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
yt=-5:5:5;

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

title('in Inhibitory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
ylim([-8,8])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('mean synaptic current','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
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
yt=-0.5:0.25:0;
H4=figure('name',figname4,'visible',vis{4});
hold on
plot(xvec,r_ei(:,1),'color',red,'linewidth',lw);
plot(xvec,r_ei(:,2),'color',blue,'linewidth',lw);
hold off

ylabel('correlation currents','fontsize',fs)
ylim([-0.5,-0.2])
xlim([xvec(1),xvec(end-2)])
box off

text(0.7,0.6,'in Exc','fontsize',fs,'units','normalized','color',red)
text(0.7,0.45,'in Inh','fontsize',fs,'units','normalized','color',blue)

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
%{
pos_vec=plt1;
yt=0.8:0.2:1.2;

H5=figure('name',figname5,'visible',vis{5});

hold on
plot(xvec,CVs(:,1),'color',red,'linewidth',lw);
plot(xvec,CVs(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('coeff. of variation','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim([xvec(1),xvec(end-2)])
ylim([0.8,1.2])

for ii=1:2
    text(0.1,0.9-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H5, 'Units','centimeters', 'Position', pos_vec)
set(H5,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig5==1
    print(H5,[savefile,figname5],'-dpng','-r300');
end

%% plot ratios

pos_vec=plt1;
yt=0.8:0.2:1.2;

H=figure('name',figname6,'visible',vis{6});
plot(xvec,ratios(:,1),'color',red,'linewidth',lw)
hold on
plot(xvec,ratios(:,2),'color',blue,'linewidth',lw)
hold off
line([xvec(1),xvec(end-2)],[1,1],'color',[0.7,0.7,0.7,0.5])
hold off
box off

for ii=1:2
    text(0.03+ (ii-1)*0.2,0.9,nameI{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end

xlim([xvec(1),xvec(end-2)])
ylim([0.8,1.2])
ylabel('ratio variance','fontsize',fs)
xlabel (xlab,'fontsize',fs);

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
    
%op=get(gca,'OuterPosition');
%set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.02 op(3)-0.02 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig6==1
    print(H,[savefile,figname6],'-dpng','-r300');
end

%% optimal ratio 

gvec=0:0.1:1;

qstar=zeros(length(gvec),1);
for ii=1:length(gvec)
    error=gvec(ii).*sqrt(ms(:,1))+ (1-gvec(ii)).*sqrt(ms(:,2));
    [~,idx]=min(error);
    qstar(ii)=xvec(idx);
end

display(qstar,'q star')
%}