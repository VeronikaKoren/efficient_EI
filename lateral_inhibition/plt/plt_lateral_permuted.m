
clear all
%close all
clc

savefig=1;

savefile=[cd,'/figure/lateral/Jstructure/'];
addpath([cd,'/result/perturbation/Jstructure/'])
addpath([cd,'/result/perturbation/'])

ntype={'noiseJ','full_perm','partial_perm'};
Jp_name={'E-E','I-I','E-I','I-E','all'}; % Connetivity matrix that is permuted

type=3; % [2,3] relevant values
Jp=5;   % [2,3,4,5]

%% load result

Ap=1.0;

loadname0=['perturbation_spont_EI_Ap',sprintf('%1.0i',Ap*10)];
load(loadname0,'mdri','mdre')

mdri0=mdri;
mdre0=mdre;
clear mdri
clear mdre

loadname=[ntype{type},'_',Jp_name{Jp},'_ap',sprintf('%1.0i',Ap*10)]
load(loadname)

%% prepare figure

pos_vec=[0,0,16,11];
figname=[ntype{type},'_',Jp_name{Jp},'_ap',sprintf('%1.0i',Ap*10)];

red=[0.7,0.2,0.1];
ylw=[0.7,0.6,0.0];
green=[0.2,0.8,0.1];
olive=[0.2,0.7,0.2];
magenta=[0.8,0,0.7];
purple=[0.3,0,0.8];
gray=[0.5,0.5,0.5];
darkgray=[0.2,0.2,0.2];

if type==2
    col={olive,ylw};                               % for "different", "similar"
else
    col={darkgray,purple};                               
end
col0={gray,magenta};

d=0.0005;

xlimit=[200,nsec*1000 - spont_on-100];
xt=100:100:600;
xtl=xt-200;
fs=14;

ylimitI=[-0.001,0.001]*5;
ytI=-0.003:0.003:0.003;
di=ylimitI(2)-ylimitI(1);
pos=[stim_on-spont_on,ylimitI(1),stim_off-stim_on,di];% [x y w h] rectangle for stim on

ylimitE=[-0.001,0.001]*1.7;
ytE=-0.001:0.001:0.001;
%pos=[stim_on-spont_on,-5*d,stim_off-stim_on,10*d];% [x y w h] rectangle for stim on

namepp={'different permuted','similar permuted'};
namepop={'different structured','similar structured'};
nametype={'','full permutation','partial permutation'};

%% plot dr1 and dr2 average across trials

x=tidx;

H=figure('name',figname);

subplot(2,1,1)
hold on
rectangle('Position',pos,'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
for ii=1:2
    y1=mdri{ii} - semdri{ii};
    y2=mdri{ii} + semdri{ii};
    patch([x fliplr(x)], [y1 fliplr(y2)], col{ii},'FaceAlpha',0.3,'EdgeColor',col{ii})
    plot(x,mdri0{ii},'color',col0{ii})
end
hold off
box off
for ii=1:2
    text(0.03,0.75+(ii-1)*0.15,namepp{ii},'units','normalized','color',col{ii},'fontsize',fs)
    text(0.65,0.75+(ii-1)*0.15,namepop{ii},'units','normalized','color',col0{ii},'fontsize',fs)
end

line([tidx(1) tidx(end)],[0 0],'color','k','LineStyle','--','LineWidth',1.5)
if Jp==3
    text(stim_on-spont_on+8,ylimitI(1)+di/10,'perturb','color',red,'fontsize',fs)
end
title([nametype{type},' ',Jp_name{Jp},' connectivity'],'fontsize',fs)

xlim(xlimit)
ylim(ylimitI)
ylabel('\Delta z^I(t)','fontsize',fs)
set(gca,'XTick',xt,'fontsize',fs)
set(gca,'XTickLabel',[])
set(gca,'YTick',ytI,'fontsize',fs)

subplot(2,1,2)
hold on
rectangle('Position',pos,'FaceColor',[0,1,1,0.2],'EdgeColor',[0,1,1,0.2],'Linewidth',1)
for ii=1:2
    y1=mdre{ii} - semdre{ii};
    y2=mdre{ii} + semdre{ii};
    patch([x fliplr(x)], [y1 fliplr(y2)], col{ii},'FaceAlpha',0.3,'EdgeColor',col{ii})
    plot(x,mdre0{ii},'color',col0{ii})
end
hold off
box off
line([tidx(1) tidx(end)],[0 0],'color','k','LineStyle','--','LineWidth',1.5)

ylabel('\Delta z^E(t)','fontsize',fs)
xlabel('time [ms]','fontsize',fs)
xlim(xlimit)
ylim(ylimitE)

set(gca,'YTick',ytE,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl,'fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    %savefile=[cd,'/figure/lateral/'];
    print(H,[savefile,figname],'-dpng','-r300');
end
%%


