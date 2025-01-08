
%% plots 2-dimensional optimum for time constants of single neurons [\tau_r^E, \tau_r^I]
% for several weightings between the error and the cost

clear
close all

vari='local';   % local currentss
g_l=0.7;        % default weighting of the error vs cost

savefig=0;
figname=strcat('optimal_tc_',vari,'_gL');
 
namevar={'\tau_r^E','\tau_r^I'};

%%

addpath('/Users/vkoren/efficient_EI/result/adaptation/')
loadname= 'adaptation_2d_measures';
load(loadname)

savefile=pwd;

%%

fs=16;
lw=1.5;
lwa=1;
pos_vec=[0,0,10,8];

ticks=[0,10,20]+1;
tl=variable(ticks);

%% weighting E vs. I

geps_vec=0:0.1:1;
optimal_taur_geps=zeros(length(geps_vec),2);
loss_ei=log((g_l.*rms) + (1-g_l).*cost);

for ii=1:length(geps_vec)

    loss_tot=geps_vec(ii).*loss_ei(:,:,1) + (1-geps_vec(ii)).*loss_ei(:,:,2);
    mini=min(loss_tot(:));
    [idx,idy]=find(loss_tot==mini);
    optimal_taur_geps(ii,:)=[variable(idx),variable(idy)];
    
end

%% weighting error vs cost

glvec=0:0.1:1;
ng=length(glvec);
optimal_taur_gL=zeros(ng,2);

for ii=1:length(glvec)

    lossvar=log((glvec(ii)*mean(rms,3)) + ((1-glvec(ii))*mean(cost,3)));
    mini=min(lossvar(:));
    [idx,idy]=find(lossvar==mini);
    optimal_taur_gL(ii,:)=[variable(idx),variable(idy)];
    
end

%%

col=cat(1,glvec,zeros(1,ng),ones(1,ng))';

H=figure('name',figname);
hold on
scatter(optimal_taur_gL(:,1),optimal_taur_gL(:,2),25,col,'x','linewidth',3)

for ii=1:2:ng
    text(0.75,0.85-glvec(ii)*0.7,['g_L=',sprintf('%0.1f',glvec(ii))],'units','normalized','color',col(ii,:),'fontsize',fs-2)
end

hold off
axis([0,30,0,30])
xlabel(['optimal ',namevar{1}] ,'fontsize',fs)
ylabel(['optimal ',namevar{2}],'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(gca,'XTick',ticks)
set(gca,'YTick',ticks)
set(gca,'XTickLabel',tl,'fontsize',fs-1)
set(gca,'YTickLabel',tl,'fontsize',fs-1)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%



