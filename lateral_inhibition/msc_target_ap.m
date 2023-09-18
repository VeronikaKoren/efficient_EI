clear all
close all
clc

savefig=0;
figname='msc_target_ap';

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%% load result

ap_vec=0:0.1:1;
nap=length(ap_vec);

msc_tar=zeros(nap,1);

for ii=1:nap
    loadname=['perturbation_trials_Ap',sprintf('%1.0i',ap_vec(ii)*10)];
    load(loadname,'msc_target')
    msc_tar(ii)=msc_target
end

%%
plt1=[0,0,8,7];


fs=13;
msize=6;
lw=1.2;
lwa=1;
red=[0.7,0.2,0.1];

yt=0:25:50;

%%

H=figure('name',figname);
plot(ap_vec,msc_tar,'color',red)
box off

xlim([0,1])
ylim([0,50])
xlabel('perturbation strength')
ylabel('firing rate target [Hz]')

set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt)
%set(gca,'XTick',xt)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.06 op(3)-0.0 op(4)-0.06]);

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%