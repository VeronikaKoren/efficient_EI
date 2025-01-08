%% measures of performance and of dynamics as a function of noise strength sigma

clear
close all
clc
        
vari='sigma';
g_l=0.7;
g_eps=0.5;

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('EI_balance_',vari);
figname4=strcat('weightings_',vari);

addpath('/Users/vkoren/efficient_EI/result/beta_sigma/')
savefile=pwd;

loadname=strcat('measures_',vari);
load(loadname)
%%

xvec=sigma_vec;
vis={'on','on','on','on'}; % visibility of figures 1,2,3 and 4

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
xt=xvec(1):10:xvec(end)-5;
xlab='noise intensity \sigma';

%% optimal parameter

loss_ei=g_l.*rms + ((1-g_l).*cost);
avloss=mean(loss_ei,2);
[~,idx]=min(avloss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% normalized for plotting

cost_ei_norm= (cost-min(cost))./max(cost - min(cost));
cost_norm=mean(cost_ei_norm,2);

loss_norm=(avloss-min(avloss))./max(avloss - min(avloss));

%% plot loss measures

name_error={'RMSE^E','RMSE^I'};

mini=min(loss_norm);
maxi=max(loss_norm);
delta= (maxi-mini)/5;

pos_vec=plt2;
yt=3:3:8;
yt2=[0,1];
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
ylim([2,7.5])
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
plot(xvec,cost_norm,'color',green)
plot(xvec,loss_norm,'color','k')
text(0.32,0.9,'cost','units','normalized','color',green,'fontsize',fs)
text(0.32,0.7,'loss','units','normalized','color','k','fontsize',fs)

% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
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

%% firing rate & Coefficient of variation

pos_vec=plt2;
yt=0:30:60;

mini=min(frate(:,2));
maxi=max(frate(:));
delta= (maxi-mini)/5;

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colpop{ii});
    text(0.05,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini+delta mini+3*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off
xlim([xvec(1),xvec(end)])
ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

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

mini=rec(idx,2)-3;
maxi=rec(idx,2)-1.5;

yt=-4:2:0;
H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',colpop{ii})
    text(0.7, 0.83-(ii-1)*0.18,['in ', namepop{ii}],'units','normalized','color',colpop{ii},'fontsize',fs)
end
line([optimal_param optimal_param],[mini maxi],'color','k')
plot(optimal_param,maxi,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

title('average imbalance','fontsize',fs)
xlim([xvec(1),xvec(end)])

ylabel('net syn. input [mV]','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)+0.01 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%

yt=0.2:0.4:0.6;
mini=min(abs(r_ei(:)));
maxi=mean(abs(r_ei(:)));
delta= (maxi-mini)/4;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',colpop{ii},'linewidth',lw)
end
line([optimal_param optimal_param],[0.3 0.42],'color','k')
hh=plot(optimal_param,0.3,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim([xvec(1),xvec(end)])
ylim([0.1,0.68])
title('instantaneous balance','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
ylabel('corr. coefficient','fontsize',fs+1)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.03 op(3)+0.01 op(4)+0.02]);

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
yt=[3,6];

H=figure('name',figname4,'visible',vis{4});
%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
hold on
stem(g_ei_vec,optimal_ratio_ei,'color',red)
plot(g_eps,optimal_ratio_ei(hidx)+1.2,'kv','markersize',13)
hold off
box off

xlabel('weighting loss E vs. I','fontsize',fs)
ylim([0,7])
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
plot(g_l,optimal_ratio_gl(glidx)+1.8,'kv','markersize',13)
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

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end



