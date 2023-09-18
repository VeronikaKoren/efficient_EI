clear all
close all
clc

savefig=0;
figname='influence_ap';

savefile=[cd,'/figure/lateral/'];
addpath([cd,'/result/perturbation/'])

%% load result

ap_vec=0:0.1:1;
nap=length(ap_vec);

D=zeros(2,nap);

for ii=1:nap
    loadname=['perturbation_trials_Ap',sprintf('%1.0i',ap_vec(ii)*10)];
    load(loadname,'md','namepop')
    D(:,ii)=mean(md,2);
end

%%
plt1=[0,0,8,7];

green=[0.1,0.82,0.1];
gray=[0.7,0.7,0.7];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,green};                               % for "different", "similar"
coltxt={darkgray,olive};

fs=13;
msize=6;
lw=1.2;
lwa=1;

d=0.0005;
yt=-2*d:d:d;

%%

H=figure('name',figname);

hold on
for ii=1:2
    plot(ap_vec,D(ii,:),'color',col{ii})
    text(0.05,0.9-(ii-1)*0.1,namepop{ii},'units','normalized','fontsize',fs,'color',coltxt{ii})
end
hold off
box off

line([0,1],[0,0],'LineStyle','--','color',[0.2,0.2,0.2])
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.06 op(3)-0.0 op(4)-0.06]);

xlim([0,1])
ylim([-0.001,0.0005])
xlabel('perturbation strength')
ylabel('influence')

set(gca,'YTick',yt)
%set(gca,'YTicklabel',yt)
%set(gca,'XTick',xt)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
