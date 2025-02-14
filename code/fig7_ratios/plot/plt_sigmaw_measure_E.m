%% plots performance and activity as a function of the ratio mean I-I mean E-I
% measured as a function of the sigma_w^E (spread of tuning parameters in E neurons)

clear 
close all

vari='de';
g_l=0.7;            % weighting error vs. cost
g_eps=0.5;          % weighting error E vs. I

savefig1=0;
savefig2=0;
savefig3=1;
savefig4=0;
savefig5=0;

figname1=strcat('loss_',vari,'_',sprintf('%1.0i',g_l*10));
figname2=strcat('fr_cv_',vari);
figname3=strcat('balance_',vari);
figname4=strcat('currents_',vari);
figname5=strcat('weightings_',vari);

addpath('result/ratios/')
savefile=pwd;

loadname='measures_dE';
load(loadname)

vis={'on','on','on','on','on'};

%% compute optimal parameter

loss_ei=g_l.*ms + ((1-g_l).*cost);
avloss=mean(loss_ei,2); % average across E and I neurons
[~,idx]=min(avloss);
optimal_dE=devec(idx);
display(optimal_dE,'best parameter dE')

dI=parameters{8}{:};
optimal_ratio=dI/optimal_dE;
display(optimal_ratio,'best ratio sigmawI: sigmawE')
xvec=dI./devec;

%% normalized for plotting

cost_ei_norm= (cost-min(cost))./max(cost - min(cost));
cost_norm=mean(cost_ei_norm,2);
loss_norm=(avloss-min(avloss))./max(avloss - min(avloss));

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
xt=[3,6,9];
xlab='mean I-I : mean E-I (vary E-I)';
xlab_opt='mean E-I : mean I-I (vary E-I)';
xlimit=[xvec(end),xvec(1)];

%% plot loss

name_error={'RMSE^E','RMSE^I','(RMSE^E + RMSE^I)/2'};
pos_vec=plt2;
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
xlim(xlimit)

set(gca,'XTick',xt)
set(gca,'XTicklabel',[],'fontsize',fs)
    
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.04 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(xvec,cost_norm,'color',green)
plot(xvec,loss_norm,'color','k')
text(0.05,0.9,'cost','units','normalized','color',green,'fontsize',fs)
text(0.05,0.75,'loss','units','normalized','color','k','fontsize',fs)

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
h1 = ylabel ('loss measures','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+2);
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

pos_vec=plt2;
yt=0:20:40;

mini=frate(idx,2);
maxi=max(frate(:));

H=figure('name',figname2,'visible',vis{2});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,frate(:,ii),'color',colI{ii});
    text(0.1,0.85-(ii-1)*0.17,namepop{ii},'units','normalized','fontsize',fs,'color',colI{ii})
end

hold off
box off

xlim(xlimit)
ylim([0,40])

ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%
yt=1:0.5:1.5;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,CVs(:,ii),'color',colI{ii});
end

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

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% E-I balance

pos_vec=plt2;
rec(:,1)=meanE(:,1)+meanE(:,2);
rec(:,2)=meanI(:,1)+meanI(:,2);

H=figure('name',figname3,'visible',vis{3});
subplot(2,1,1)
hold on
for ii=1:2
    plot(xvec,rec(:,ii),'color',col{ii})
    text(0.05,0.95-(ii-1)*0.18,0.9,['to ',namepop{ii}],'units','normalized','fontsize',fs,'color',col{ii})
end
hold off
box off

title('average imbalance','fontsize',fs)
ylabel('net syn. input [mV]','fontsize',fs)
xlim(xlimit)
ylim([-4,1])

set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',[-2,0],'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%%%%%%%%%%%%

mini=0;
maxi=0.23;
delta= (maxi-mini)/4;
yt=0:.25:.5;

subplot(2,1,2)
hold on
for ii=1:2
    plot(xvec,abs(r_ei(:,ii)),'color',col{ii})
end
hold off
box off

title('instantaneous balance','fontsize',fs)
ylabel('corr. coefficient','fontsize',fs)
xlabel (xlab,'fontsize',fs);

xlim(xlimit)
ylim([0.0,0.7])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% mean syn. current

pos_vec=plt2;
mce=cat(2,meanE,meanE(:,1)+meanE(:,2));
yt=[-3,0];

H=figure('name',figname4,'visible',vis{4});
subplot(2,1,1)
hold on
for ii=1:3
    plot(xvec,mce(:,ii),'color',colE{ii})
    text(0.05+ (ii-1)*0.13,0.85,nameE{ii},'fontsize',fs,'units','normalized','color',colE{ii})
end
hold off
box off

title('to Excitatory','Fontsize',fs-1)
xlim(xlimit)
ylim([-4,1.5])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)-0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
%set(gca,'TickDir','out')
%%%%%%%%%%%%

mci=cat(2,meanI,meanI(:,1)+meanI(:,2));
rec=meanI(:,1)+meanI(:,2);
yt=[0,4];

subplot(2,1,2)
hold on
for ii=1:3
    plot(xvec,mci(:,ii),'color',colI{ii})
    text(0.05+(ii-1)*0.15,0.9,nameI{ii},'fontsize',fs,'units','normalized','color',colI{ii})
end

hold off
box off

title('to Inhibitory','Fontsize',fs-1)
xlim(xlimit)
ylim([-6,6])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.02 op(3)-0.05 op(4)+0.02]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

axes
h1 = ylabel ('mean synaptic input [mV]','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
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

%{
loss_ei=g_l.*ms + ((1-g_l).*cost);
avloss=mean(loss_ei,2); % average across E and I neurons
[~,idx]=min(avloss);
optimal_dE=devec(idx);
display(optimal_dE,'best parameter dE')

dI=parameters{8}{:};
optimal_ratio=dI/optimal_dE;
display(optimal_ratio,'best ratio sigmawI: sigmawE')
xvec=dI./devec;
%}

g_ei_vec=0:0.01:1;
optimal_ratio_ei=zeros(length(g_ei_vec),1);

for ii=1:length(g_ei_vec)

    avloss_g_ei=g_ei_vec(ii).*loss_ei(:,1) + (1-g_ei_vec(ii)).*loss_ei(:,2);

    [~,idx_ei]=min(avloss_g_ei); % index of the best dE
    optimal_ratio_ei(ii)=xvec(idx_ei); % best ratio
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
yt=[3,6,9];
ylimit=[0,11];

H=figure('name',figname5,'visible','on');
%%%%%%%%%%%%%%%%%%
subplot(2,1,1)
hold on
stem(g_ei_vec,optimal_ratio_ei,'color',red)
plot(g_eps,optimal_ratio_ei(hidx)+2,'kv','markersize',13)
hold off
box off

xlabel('weighting loss E vs. I','fontsize',fs)
ylim(ylimit)
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
plot(g_l,optimal_ratio_gl(glidx)+3,'kv','markersize',13)
hold off
box off

xlabel('weighting error vs. cost','fontsize',fs)
ylim(ylimit)
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
