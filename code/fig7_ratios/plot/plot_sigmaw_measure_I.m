%% plots the performance and activity measures as a function of the ratio of mean I-I to E-I connectivity
% measured as a function of the sigma_w^I (spread of tuning parameters in I neurons)

clear
close all
clc

vari='d'; 
g_l=0.7;
g_eps=0.5;

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;
savefig5=0; 


figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('balance_',vari);
figname4=strcat('currents_',vari);
figname5=strcat('weightings_',vari);

addpath('result/ratios/')
savefile=pwd;

loadname='measures_d';
load(loadname)

%%

xvec=dvec;
vis={'on','on','on','on','on'};

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
xlab='mean I-I : mean E-I';
xlimit=[xvec(1),xvec(end-2)];

%% optimal parameter

loss_ei=g_l.*ms + ((1-g_l).*cost);
avloss=mean(loss_ei,2); % average across E and I neurons
[~,idx]=min(avloss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

[~,idx2]=min(mean(ms,2));
optimal_param_error=xvec(idx2);
display(optimal_param_error,'best param with respect to error')

%% normalized for plotting

cost_ei_norm= (cost-min(cost))./max(cost - min(cost));
cost_norm=mean(cost_ei_norm,2);

loss_norm=(avloss-min(avloss))./max(avloss - min(avloss));

%% plot loss

name_error={'RMSE^E','RMSE^I'};

mini=min(loss_norm);
maxi=max(loss_norm);
delta= (maxi-mini)/5;

pos_vec=plt2;
yt=3:3:6;
yt2=[0,1];
%%%%%%%%%%%%%

H=figure('name',figname1,'visible',vis{1});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,ms(:,ii),'color',col{ii});
    text(0.15,0.9-(ii-1)*0.17,name_error{ii},'units','normalized','color',col{ii},'fontsize',fs)
end

hold off
box off
ylim([2.3,7.7])
xlim(xlimit)

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
plot(xvec,cost_norm,'color',green)
plot(xvec,loss_norm,'color','k')
text(0.7,0.86,'cost','units','normalized','color',green,'fontsize',fs)
text(0.7,0.7,'loss','units','normalized','color','k','fontsize',fs)

% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off
xlim(xlimit)
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
h2 = xlabel (xlab,'units','normalized','Position',[0.5,-0.01,0],'fontsize',fs+2);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% firing rate and CV

mini=frate(idx,2);
maxi=max(frate(:));
delta= (maxi-mini)/3;

pos_vec=plt2;
yt=0:20:40;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',col{ii});
    text(0.75,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end
% arrow
line([optimal_param optimal_param],[mini+delta mini+2*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim(xlimit)
ylim([0,57])

ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

%%%%%%%%%%%%%%%%%%%%%

mini=CVs(idx,2);
maxi=1.4;
delta= (maxi-mini)/3;
yt=1.0:0.5:1.5;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',col{ii});
end
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

a=1;
pos_vec=plt2;
rec(:,1)=meanE(:,1).*a +meanE(:,2).*a;
rec(:,2)=meanI(:,1).*a +meanI(:,2).*a;

mini=-2;
maxi=-4;
delta= (maxi-mini)/3;

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',col{ii})
    text(0.03,0.35-(ii-1)*0.18,0.9,['to ',namepop{ii}],'units','normalized','fontsize',fs,'color',col{ii})
end
% arrow
line([optimal_param optimal_param],[mini mini+2.5*delta],'color','k')
plot(optimal_param,mini+0*delta,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

title('average imbalance','fontsize',fs)
ylabel('net syn. input [mV]','fontsize',fs)
xlim(xlimit)
ylim([-4.3,0])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',[-2,0],'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%
mini=0.26;
maxi=0.4;
delta= (maxi-mini)/3;
yt=0:.25:.5;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',col{ii})
end
% arrow
line([optimal_param optimal_param],[mini mini+2.5*delta],'color','k')
plot(optimal_param,mini+2.5*delta,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off
title('instantaneous balance','fontsize',fs)
xlim(xlimit)
ylim([0.1,0.55])
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

mce=cat(2,meanE.*a,meanE(:,1).*a+meanE(:,2).*a);
pos_vec=plt2;
rec=meanE(:,1).*a+meanE(:,2).*a;
yt=[0,2];

H=figure('name',figname4,'visible',vis{4});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,mce(:,ii),'color',colE{ii})
    text(0.05+ (ii-1)*0.13,0.8,nameE{ii},'fontsize',fs,'units','normalized','color',colE{ii})
    
end
plot(xvec,rec,'--','color',colE{3})
text(0.05+ (3-1)*0.15,0.8,nameE{3},'fontsize',fs,'units','normalized','color',colE{3})

hold off
box off

title('to Excitatory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
ylim([-2.5,2.5])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)+0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')
%%%%%%%%%%%%

rec=meanI(:,1).*a + meanI(:,2).*a;
yt=0:8:12;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,meanI(:,ii).*a,'color',colI{ii})
end
plot(xvec,rec,'--','color',colI{3})
for ii=1:3
    text(0.05+ (ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

hold off
box off

title('to Inhibitory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
%ylim([-4,4])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

axes
h1 = ylabel ('net synaptic input [mV]','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.01,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%% weighting E vs. I

g_ei_vec=0:0.01:1;
optimal_ratio_ei=zeros(length(g_ei_vec),1);

for ii=1:length(g_ei_vec)

    avloss_g_ei=g_ei_vec(ii).*loss_ei(:,1) + (1-g_ei_vec(ii)).*loss_ei(:,2);

    [~,idx_ei]=min(avloss_g_ei);
    optimal_ratio_ei(ii)=xvec(idx_ei);
end

display([optimal_ratio_ei(1),optimal_ratio_ei(end)],'range of optimal parameters for different weighting of E and I loss')

%% weighting of error and cost

glvec=0:0.01:1;
optimal_ratio_gl=zeros(length(glvec),1);
for ii=1:length(glvec)

    loss_ei_gl=glvec(ii).*ms + ((1-glvec(ii)).*cost);
    avloss_gl=mean(loss_ei_gl,2); % average across E and I neurons (assuming equal weighting of the loss across E and I neurons)
    [~,idx_gl]=min(avloss_gl);
    optimal_ratio_gl(ii)=xvec(idx_gl);

end

display([optimal_ratio_gl(1),optimal_ratio_gl(end)],'range of optimal parameters for different weighting of error vs. cost')

%% plot optimal param as a function of weightings


hidx=find(g_ei_vec==g_eps);
glidx=find(glvec==g_l);

pos_vec=[0,0,8,10];
xt=0:0.5:1;
yt=[3,6];

H=figure('name',figname5,'visible','on');
%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
hold on
stem(g_ei_vec,optimal_ratio_ei,'color',red)
plot(g_eps,optimal_ratio_ei(hidx)+0.6,'kv','markersize',13)
hold off
box off

xlabel('weighting loss E vs. I','fontsize',fs)
ylim([0,4])
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
plot(g_l,optimal_ratio_gl(glidx)+1.9,'kv','markersize',13)
hold off
box off

xlabel('weighting error vs. cost','fontsize',fs)
ylim([0,9])
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


