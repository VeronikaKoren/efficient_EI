%% measures of performance and of dynamics as a function of the metabolic constant beta

clear
close all
clc
        
vari='beta';
g_l=0.7;                    % weighting of the error vs. cost
g_eps=0.5;                  % weighting of the error of E vs. I neurons

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;
savefig5=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);
figname4=strcat('mcurrents_',vari);
figname5=strcat('weighting_',vari);

addpath('/Users/vkoren/efficient_EI/result/beta_sigma/')
savefile=pwd;

loadname=strcat('measures_',vari);
load(loadname)
%%

xvec=beta_vec;
vis={'on','on','on','on','on'};

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

nameI={'Exc','Inh','Net'};
nameE={'ffw','Inh','Net'};
namepop={'Exc','Inh'};

plt1=[0,0,8,7];
plt2=[0,0,8,10];
xt=xvec(1):10:xvec(end);
xlab='metabolic constant \beta';

%%

loss_ei=g_l.*rms + ((1-g_l).*cost);
avloss=mean(loss_ei,2); % average across E and I neurons
[~,idx]=min(avloss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%{
[~,idx2]=min(mean(rms,2));
optimal_param_error=xvec(idx2);
display(optimal_param_error,'best param with respect to error')
%}
%%

cost_ei_norm= (cost-min(cost))./max(cost - min(cost));
cost=mean(cost_ei_norm,2);

loss_norm=(avloss-min(avloss))./max(avloss - min(avloss));

%% performance

name_error={'RMSE^E','RMSE^I'};

mini=min(loss_norm);
maxi=max(loss_norm);
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
    text(0.08,0.9-(ii-1)*0.17,name_error{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end

hold off
box off
ylim([1.5,6.5])
xlim([xvec(1),xvec(end)])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,cost,'color',green)
plot(xvec,loss_norm,'color','k')
text(0.1,0.9,'cost','units','normalized','color',green,'fontsize',fs)
text(0.1,0.7,'loss','units','normalized','color','k','fontsize',fs)

ylim([-0.2,1.1])
% arrow
line([optimal_param optimal_param],[mini+delta mini+2*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([-0.1,1.1])

set(gca,'YTick',yt2)
set(gca,'YTicklabel',yt2,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

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

%% firing rate and CV

pos_vec=plt2;
yt=0:20:40;

mini=frate(idx,2);
maxi=mini+15;
delta= (maxi-mini)/5;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colpop{ii});
    text(0.8,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off
xlim([xvec(1),xvec(end)])
ylabel('firing rate','fontsize',fs+1)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

%%%%%%%%%%%%%%%%%%
yt=0.7:0.3:1.3;
mini=CVs(idx,2);
maxi=mini+0.3;
delta= (maxi-mini)/3;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',colpop{ii});
end
line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

ylabel('coeff. of variation','fontsize',fs)

xlim([xvec(1),xvec(end)])
ylim([0.6,1.4])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

axes
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

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

mini=rec(idx,2);
delta= 0.2;
yt=-2:0

H3=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colpop{ii})
    text(0.7, 0.33-(ii-1)*0.18,['in ', namepop{ii}],'units','normalized','color',colpop{ii},'fontsize',fs)
end

line([optimal_param optimal_param],[mini+delta mini+4*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);

hold off
box off

title('average imbalance','fontsize',fs)
xlim([xvec(1),xvec(end)])
%ylim([-2,2])

ylabel('net syn. input [mV]','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%

mini=abs(r_ei(idx,2));
maxi=max(abs(r_ei(:)));
delta= 0.05;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end

line([optimal_param optimal_param],[mini+delta mini+4*delta],'color','k')
hh=plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);

hold off
box off

xlim([xvec(1),xvec(end)])
title('instantaneous balance','fontsize',fs)

%set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylabel('corr. coefficient','fontsize',fs)
ylim([0.15,0.65])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H3, 'Units','centimeters', 'Position', pos_vec)
set(H3,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H3,[savefile,figname3],'-dpng','-r300');
end


%% average E-I balance all currents

pos_vec=plt2;
rec=meanE(:,1)+meanE(:,2);

H4=figure('name',figname4,'visible',vis{4});
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

xlim([xvec(1),xvec(end)])
ylim([-2.2,0.2])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

title('in Excitatory','Fontsize',fs+1)

%%%%%%%%%%%%
rec=meanI(:,1)+meanI(:,2);

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,meanI(:,ii),'color',colI{ii},'linewidth',lw)
end
plot(xvec,rec,'--','color',colI{3},'linewidth',lw-0.2)
line([xvec(1) xvec(end)] ,[0 0],'Color','k','Linewidth',1.8,'LineStyle',':')

for ii=1:3
    text(0.1+ (ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

hold off
box off

xlim([xvec(1),xvec(end)])
ylim([-6.2,6.2])

title('in Inhibitory','Fontsize',fs-1)

%set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes
h1 = ylabel ('mean synaptic current','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

set(H4, 'Units','centimeters', 'Position', pos_vec)
set(H4,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig4==1
    print(H4,[savefile,figname4],'-dpng','-r300');
end

%%%%%%%%%%%%%%%%%%%%%%%
%% full range of optimal parameters as a function of weighting of RMSE^E and RMSE^I 

g_ei_vec=0:0.01:1;
optimal_ratio_ei=zeros(length(g_ei_vec),1);

for ii=1:length(g_ei_vec)

    avloss_g_ei=g_ei_vec(ii).*loss_ei(:,1) + (1-g_ei_vec(ii)).*loss_ei(:,2);

    [~,idx_ei]=min(avloss_g_ei);
    optimal_ratio_ei(ii)=xvec(idx_ei);
end

display([optimal_ratio_ei(1),optimal_ratio_ei(end)],'range of optimal parameters for different weighting of E and I loss')
%% weightings

glvec=0:0.01:1;
optimal_ratio_gl=zeros(length(glvec),1);
for ii=1:length(glvec)

    loss_ei_gl=glvec(ii).*rms + ((1-glvec(ii)).*cost);
    avloss_gl=mean(loss_ei_gl,2); % average across E and I neurons (assuming equal weighting of the loss across E and I neurons)
    [~,idx_gl]=min(avloss_gl);
    optimal_ratio_gl(ii)=xvec(idx_gl);

end

display([optimal_ratio_gl(1),optimal_ratio_gl(end)],'range of optimal parameters for different weighting of error vs. cost')

%% plot optimal param as a function of weightings

hidx=find(g_ei_vec==0.5);
glidx=find(glvec==g_l);

pos_vec=[0,0,8,10];
xt=0:0.5:1;
yt=[15,30];

H=figure('name',figname5,'visible',vis{5});
%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
hold on
stem(g_ei_vec,optimal_ratio_ei,'color',red)
plot(g_eps,optimal_ratio_ei(hidx)+6,'kv','markersize',13)
hold off
box off

xlabel('weighting loss E vs. I','fontsize',fs)
ylim([0,39])
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
plot(g_l,optimal_ratio_gl(glidx)+7,'kv','markersize',13)
hold off
box off

xlabel('weighting error vs. cost','fontsize',fs)
ylim([0,39])
xlim([-0.1,1.1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.00 op(3)-0.05 op(4)-0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

axes
h1 = ylabel (['optimal ',xlab],'units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig5==1
    print(H,[savefile,figname5],'-dpng','-r300');
end





