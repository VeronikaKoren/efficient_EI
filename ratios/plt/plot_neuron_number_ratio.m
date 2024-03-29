
clear all
close all

vari='q';
g_l=0.7;

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;
savefig5=0;
%savefig6=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('balance_',vari);
figname4=strcat('currents_',vari);
figname5=strcat('optimal_',vari);
%figname6=strcat('weighting_error_vs_cost_',vari);

addpath('/Users/vkoren/ei_net/result/ratios/')
savefile='/Users/vkoren/ei_net/figure/ratios/measure_NI/';

loadname='measures_q';
load(loadname)

%%

xvec=qvec;
vis={'on','on','on','on','on'};

%%
fs=14;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};
green=[0.2,0.7,0];

colI={red,blue,green};
colE={'k',blue,green};

nameI={'Exc','Inh','net'};
nameE={'ff','Inh','net'};
namepop={'Exc','Inh'};

plt1=[0,0,9,7];
plt2=[0,0,9,10];
xt=xvec(1):2:xvec(end);
xlab='N^E:N^I';
xlimit=[xvec(1),xvec(end-2)];

%% optimal parameter

g_e = 0.5;
g_k = 0.5;

eps=(ms-min(ms))./max(ms-min(ms));
kappa= (cost-min(cost))./max(cost - min(cost));
error=(g_e*eps(:,1)) + ((1-g_e)*eps(:,2));
costm=(g_k*kappa(:,1)) + ((1-g_k)*kappa(:,2));
loss=(g_l*error) + ((1-g_l) * costm);


[~,idx]=min(loss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% plot loss

name_error={'RMSE^E','RMSE^I','(RMSE^E + RMSE^I)/2'};
mini=min(loss);
maxi=max(loss);
delta= (maxi-mini)/4;

pos_vec=plt2;
yt=[2.5,3.5];
yt2=[0,1];
%%%%%%%%%%%%%

H=figure('name',figname1,'visible',vis{1});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,ms(:,ii),'color',col{ii});
    text(0.15,0.95-(ii-1)*0.17,name_error{ii},'units','normalized','color',col{ii},'fontsize',fs)
end
%plot(xvec,(ms(:,1)+ms(:,2))./2,'--','color','k')
%text(0.15,0.99-(3-1)*0.17,name_error{3},'units','normalized','color','m','fontsize',fs)

hold off
box off
ylim([2.3,3.7])
xlim(xlimit)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt,'fontsize',fs)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,costm,'color',green)
plot(xvec,loss,'color','k')
text(0.1,0.76,'cost','units','normalized','color',green,'fontsize',fs)
text(0.1,0.6,'loss','units','normalized','color','k','fontsize',fs)

ylim([-0.2,1.1])
% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim(xlimit)
ylim([0,1])

set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

axes
h1 = ylabel ('loss measures','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+2);
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% firing rate and CV

pos_vec=plt2;
yt=0:20:30;

mini=frate(idx,2);
maxi=max(frate(:));
delta= (maxi-mini)/3;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
plot(xvec,frate(:,1),'color',colI{1});
plot(xvec,frate(:,2),'color',colI{2});
% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

for ii=1:2
    text(0.1,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end

xlim(xlimit)
ylim([0,37])

ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%
yt=0.5:0.5:1.5;
mini=CVs(idx,2);
maxi=1.4;
delta= (maxi-mini)/3;

subplot(2,1,2)
hold on
plot(xvec,CVs(:,1),'color',red);
plot(xvec,CVs(:,2),'color',blue);
% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

ylabel('coeff. of variation','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim(xlimit)
ylim([0.5,1.5])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end


%% E-I balance

a=0.3;
pos_vec=plt2;
rec(:,1)=meanE(:,1).*a +meanE(:,2).*a;
rec(:,2)=meanI(:,1).*a +meanI(:,2).*a;

mini=-1;
maxi=-0.1;
delta= (maxi-mini)/3;

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',col{ii})
    text(0.08,0.85-(ii-1)*0.18,0.9,['in ',namepop{ii}],'units','normalized','fontsize',fs,'color',col{ii})
end
line([optimal_param optimal_param],[mini+delta/2 maxi-delta],'color','k')
plot(optimal_param,mini+delta/2 ,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

title('average imbalance','fontsize',fs)
ylabel('net syn. input [mV]','fontsize',fs)
xlim(xlimit)
ylim([-2,0])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',[-2,0],'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%
mini=0.25;
maxi=0.4;
delta= (maxi-mini)/3;
yt=0:.25:.5;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',col{ii},'linewidth',lw)
end
line([optimal_param optimal_param],[mini+delta/2 maxi-delta],'color','k')
plot(optimal_param,maxi-delta,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

title('instantaneous balance','fontsize',fs)
xlim(xlimit)
ylim([0.15,0.5])
ylabel('corr. coefficient','fontsize',fs)
xlabel (xlab,'fontsize',fs);

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end


%% mean syn. current


pos_vec=plt2;
rec=meanE(:,1).*a+meanE(:,2).*a;
yt=[0,2];

H=figure('name',figname4,'visible',vis{4});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,meanE(:,ii).*a,'color',colE{ii},'linewidth',lw)
    
end
plot(xvec,rec,'--','color',colE{3},'linewidth',lw-0.2)

for ii=1:3
    text(0.05+ (ii-1)*0.15,0.8,nameE{ii},'fontsize',fs,'units','normalized','color',colE{ii})
end
hold off
box off

title('to Excitatory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
ylim([-2,2])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%
rec=meanI(:,1).*a+meanI(:,2).*a;
yt=-2:2:2;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,meanI(:,ii).*a,'color',colI{ii},'linewidth',lw)
end
plot(xvec,rec,'--','color',colI{3},'linewidth',lw-0.2)
for ii=1:3
    text(0.05+ (ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

hold off
box off

title('to Inhibitory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
ylim([-2,2])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%

axes
h1 = ylabel ('mean synaptic input [mV]','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%% full range of optimal parameters as a function of weighting of RMSE^E and RMSE^I 

gevec=0:0.01:1;
optimal_error=zeros(length(gevec),1);

for ii=1:length(gevec)
    error=(gevec(ii)*eps(:,1)) + ((1-gevec(ii))*eps(:,2));
    [~,idx]=min(error);
    optimal_error(ii)=xvec(idx);
end

display([optimal_error(1),optimal_error(end)],'range of optimal parameters for different weighting of RMSE^E and RMSE^I')

%% full range of optimal parameters as a function of weighting of error and cost

% assuming equal weighting for E and I neurons (g_e = g_k = 0.5)
error=(g_e*eps(:,1)) + ((1-g_e)*eps(:,2));
costm=(g_k*kappa(:,1)) + ((1-g_k)*kappa(:,2));

glvec=0:0.01:1;
optimal_loss=zeros(length(glvec),1);
for ii=1:length(glvec)
    loss=(glvec(ii)*error) + ((1-glvec(ii)) * costm);
    [~,idx]=min(loss);
    optimal_loss(ii)=xvec(idx);
end

display([optimal_loss(1),optimal_loss(end)],'range of optimal parameters for different weighting of error vs. cost')

%% plot optimal param as a function of weighting

hidx=find(gevec==g_e);
glidx=find(glvec==g_l);

pos_vec=[0,0,8,10];
xt=0:0.5:1;
yt=[2,4];

H=figure('name',figname5,'visible','on');
%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
hold on
stem(gevec,optimal_error,'color',red)
plot(g_e,optimal_error(hidx)+1,'kv','markersize',13)
hold off
box off

xlabel('weight RMSE^E vs. RMSE^I','fontsize',fs)
ylim([0,6])
xlim([-0.1,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.00 op(3)-0.05 op(4)-0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')
%%%%%%%%%%%%%%%%

subplot(2,1,2)
hold on
stem(glvec,optimal_loss,'k')
plot(g_l,optimal_loss(glidx)+1.5,'kv','markersize',13)
hold off
box off

xlabel('weight error vs. cost','fontsize',fs)
ylim([0,6])
xlim([-0.1,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.00 op(3)-0.05 op(4)-0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

axes
h1 = ylabel ('optimal N^E : N^I','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig5==1
    print(H,[savefile,figname5],'-dpng','-r300');
end
%}
%%
%{
pos_vec=plt1;
xt=0:0.5:1;
yt=[2,4];

H=figure('name',figname6,'visible','on');
stem(gevec,optimal_wrt_error,'color','k')
box off

ylabel('optimal N^E : N^I','fontsize',fs)
xlabel('g_L (weighting error vs. cost) ','fontsize',fs)
ylim([0,max(optimal_gl)+1])
xlim([-0.1,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.05 op(3)-0.05 op(4)-0.05]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig6==1
    print(H,[savefile,figname6],'-dpng','-r300');
end
%}