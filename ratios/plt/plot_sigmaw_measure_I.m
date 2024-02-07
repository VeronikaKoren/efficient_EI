clear all
close all

vari='d'; 
g_l=0.7;

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;
savefig5=0; 
savefig6=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('balance_',vari);
figname4=strcat('currents_',vari);
figname5=strcat('weighting_errorE_vs_I_',vari);
figname6=strcat('weighting_error_vs_cost_',vari);

addpath('result/ratios/')
savefile=[cd,'/figure/ratios/measure_sigmawI/'];

loadname='measures_d';
load(loadname)

%%

xvec=dvec;
vis={'off','off','on','off','on','on'};

fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};
green=[0.2,0.7,0];

colI={red,blue,green};
colE={'k',blue,green};

nameI={'Exc','Inh','Net'};
nameE={'ffw','Inh','Net'};
namepop={'Exc','Inh'};

plt1=[0,0,9,7];
plt2=[0,0,9,10];
xt=xvec(1):2:xvec(end);
xlab='\sigma_w^I:\sigma_w^E';
xlimit=[xvec(1),xvec(end-2)];

%% optimal parameter

g_e = 0.5;
g_k = 0.5;

eps=(ms-min(ms))./max(ms-min(ms));
kappa= (cost-min(cost))./max(cost - min(cost));
error=(g_e*eps(:,1)) + ((1-g_e)*eps(:,2));
mcost=(g_k*kappa(:,1)) + ((1-g_k)*kappa(:,2));
loss=(g_l*error) + ((1-g_l) * mcost);

[~,idx]=min(loss);
optimal_param=xvec(idx);
display(optimal_param,'best param')

%% plot loss

name_error={'RMSE^E','RMSE^I'};

mini=min(loss);
maxi=max(loss);
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
%set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,mcost,'color',green)
plot(xvec,loss,'color','k')
text(0.7,0.86,'cost','units','normalized','color',green,'fontsize',fs)
text(0.7,0.7,'loss','units','normalized','color','k','fontsize',fs)

ylim([-0.2,1.1])
% arrow
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off
%text(0.25,0.8,'(RMSE^E + RMSE^I ) / 2','units','normalized','fontsize',fs)

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
line([optimal_param optimal_param],[mini+delta mini+2.5*delta],'color','k')
plot(optimal_param,mini+delta,'kv','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

xlim(xlimit)
ylim([0,57])

ylabel('firing rate','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%

mini=CVs(idx,2);
maxi=1.4;
delta= (maxi-mini)/3;
yt=0.5:0.5:1.5;

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
savefig3=1
pos_vec=plt2;
rec(:,1)=meanE(:,1)+meanE(:,2);
rec(:,2)=meanI(:,1)+meanI(:,2);

mini=min(rec(:));
maxi=max(rec(:))-2;
delta= (maxi-mini)/3;

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',col{ii})
    text(0.03,0.35-(ii-1)*0.18,0.9,['in ',namepop{ii}],'units','normalized','fontsize',fs,'color',col{ii})
end
% arrow
line([optimal_param optimal_param],[mini mini+2.5*delta],'color','k')
plot(optimal_param,mini+2.5*delta,'k^','markersize',msize+2,'Color','k','MarkerFaceColor','k','LineWidth',lw-0.5);
hold off
box off

title('average E-I balance')
ylabel('net current')
xlim(xlimit)
ylim([-5,0])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',[-4,0],'fontsize',fs)

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
title('temporal E-I balance','fontsize',fs)
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

mce=cat(2,meanE,meanE(:,1)+meanE(:,2));
pos_vec=plt2;
rec=meanE(:,1)+meanE(:,2);
yt=-2:2:2;

H=figure('name',figname4,'visible',vis{4});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,mce(:,ii),'color',colE{ii})
    text(0.05+ (ii-1)*0.15,0.8,nameE{ii},'fontsize',fs,'units','normalized','color',colE{ii})
    
end
plot(xvec,rec,'--','color',colE{3})
text(0.05+ (3-1)*0.15,0.8,nameE{3},'fontsize',fs,'units','normalized','color',colE{3})

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
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)+0.0]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')
%%%%%%%%%%%%

rec=meanI(:,1)+meanI(:,2);
yt=-8:8:8;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,meanI(:,ii),'color',colI{ii})
end
plot(xvec,rec,'--','color',colI{3})
for ii=1:3
    text(0.05+ (ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

hold off
box off

title('in Inhibitory','Fontsize',fs-1)
xlim([xvec(1),xvec(end-2)])
ylim([-13,13])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

axes
h1 = ylabel ('mean synaptic current','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel (xlab,'units','normalized','Position',[0.55,-0.01,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig4==1
    print(H,[savefile,figname4],'-dpng','-r300');
end


%% now evaluate the optimum wrt the error only, changing the weighting of the RMSE of E and I neurons 

gevec=0:0.01:1;
optimal_wrt_error=zeros(length(gevec),1);

for ii=1:length(gevec)
    error=(gevec(ii)*eps(:,1)) + ((1-gevec(ii))*eps(:,2));
    [~,idx]=min(error);
    optimal_wrt_error(ii)=xvec(idx);
end

display([optimal_wrt_error(1),optimal_wrt_error(end)],'range of optimal parameters for different weighting of RMSE^E and RMSE^I')

pos_vec=plt1;
xt=0:0.5:1;
yt=1:3;

H=figure('name',figname5,'visible','on');
%%%%%%%%%%%%%%%%%%
hold on
stem(gevec,optimal_wrt_error,'k')

hold off
box off

ylabel('optimal \sigma_w^I : \sigma_w^E','fontsize',fs)
xlabel('g_{\epsilon} (weighting RMSE^E vs. RMSE^I)','fontsize',fs)
ylim([0,4.5])
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

if savefig5==1
    print(H,[savefile,figname5],'-dpng','-r300');
end

%% test full range of weighting of error and cost

% assuming equal weighting between the 
error=(g_e*eps(:,1)) + ((1-g_e)*eps(:,2));
costm=(g_k*kappa(:,1)) + ((1-g_k)*kappa(:,2));

glvec=0:0.01:1;
optimal_gl=zeros(length(glvec),1);
for ii=1:length(glvec)
    loss_gl=(glvec(ii)*error) + ((1-glvec(ii)) * mcost);
    [~,idx]=min(loss_gl);
    optimal_gl(ii)=xvec(idx);
end

display([optimal_gl(1),optimal_gl(end)],'range of optimal parameters for different weighting of error vs. cost')

pos_vec=plt1;
xt=0:0.5:1;
yt=3:2:7;

H=figure('name',figname6,'visible','on');
%%%%%%%%%%%%%%%%%%
stem(glvec,optimal_gl,'r')
box off

ylabel('optimal \sigma_w^I : \sigma_w^E','fontsize',fs)
xlabel('g_L (weighting error vs. cost) ','fontsize',fs)
ylim([0,10])
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

