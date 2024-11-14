clear all
close all
clc

savefig=0;

savefile='/Users/vkoren/ei_net/figure/lateral/Jstructure/';
addpath('/Users/vkoren/ei_net/result/perturbation/Jstructure/')
addpath('/Users/vkoren/ei_net/result/perturbation/')

ntype={'noiseJ','full_perm','partial_perm'};
Jp_name={'E-E','I-I','E-I','I-E','all'}; % Connetivity matrix that is permuted

type=3; % [2,3] relevant values
Jp=3;   % [2,3,4,5]
Ap=1.0;

%% load result

figname=['influence_tuning_',ntype{type},'_',Jp_name{Jp}];

F=cell(2,1);
phi=cell(2,1);
loadname=[ntype{type},'_',Jp_name{Jp},'_ap',sprintf('%1.0i',Ap*10)]
load(loadname,'infE','infI','phi_veci','phi_vec','namepop')

F{1}=infI;
F{2}=infE;

phi{1}=phi_veci;
phi{2}=phi_vec;

%% prepare fig.

plt1=[0,0,10,12];

fs=14;
msize=6;
lw=1.2;
lwa=1;

green=[0.1,0.82,0.1];
gray=[0.7,0.7,0.7];
olive=[0.2,0.7,0.2];
darkgray=[0.5,0.5,0.5];

col={gray,green};                               % for "different", "similar"
coltxt={darkgray,olive};
if type==2
    %titles=[ntype{type}(1:4),' permutation ',Jp_name{Jp}];
    titles=Jp_name{Jp};
else
    titles=[ntype{type}(1:7),' ',Jp_name{Jp}];
end
xt=[0.01,0.003];

%maxi=cellfun(@(x) max(abs(x)),F)+0.001;
maxi=[0.02,0.005];
pop={'I','E'};
%%

H=figure('name',figname);

for ii=1:2
    subplot(2,1,ii)
    
    plot(F{ii},phi{ii},'kx')
    
    line([0,0],[-1,1],'color','r','LineStyle','-')
    hls=lsline;
    hls.Color='m';
    box off

    if ii==1
        title(titles,'Fontsize',fs,'Fontsize',fs)
    end
    if Jp==3
        ylabel(['tuning similarity ',pop{ii}],'Fontsize',fs)
    end

    xlim([-maxi(ii),maxi(ii)])
    ylim([-1.2,1.2])
 
    xtic=-xt(ii):xt(ii):xt(ii);   
    set(gca,'XTick',xtic)
    set(gca,'XTickLabel',xtic,'Fontsize',fs)
    
    set(gca,'YTick',-1:1:1,'Fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.00 op(3)-0.05 op(4)-0.00]);

end

axes
h1 = xlabel ('effective connectivity','units','normalized','Position',[0.5,-0.07,0],'Fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% correlation coefficient

r=zeros(2,1);
for ii=1:2

    x=F{ii}';
    y=phi{ii}';
    x(100)=[];
    y(100)=[];
    r(ii)=corr(x,y);

end

display(r,'correlation coefficient')
