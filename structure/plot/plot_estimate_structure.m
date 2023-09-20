
clear all
close all

savefig=0;

figname='estimate_structureJ';
loadname='estimate_permC';
load(loadname)

addpath('/Users/vkoren/ei_net/result/statistics/Vm/')
%addpath([cd,'/result/connectivity/'])
savefile=[cd,'/figure/weights_J'];

%%
fs=15;
ms=7;
lw=2;
lwa=1;
pos_vec=[0,0,16,12];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={'k',red,blue};
%%

nsec=parameters{9}{:};
dt=parameters{8}{:};

T=nsec*1000/dt;
tindex=nsec*(1:T)/T*1000;
xt=0:400:800;                         % in milliseconds
yt=[0,50];
maxi=92;

lab={'$x_1(t)$','$\hat{x}_1^E(t)$','$\hat{x}_1^I(t)$'};

%% plot

H=figure('name',figname);
    
for jj=1:4
    subplot(2,2,jj)
    
    hold on
    
    plot(tindex,x(1,:),'color',col{1})
    plot(tindex,estE(jj,:),'color',col{2})
    plot(tindex,estI(jj,:),'-.','color',col{3},'linewidth',lw-0.5)
    hold off
    
    title(['permuted ' Co{jj}])
    if jj==1
        for ii=1:3
            text(0.05+(ii-1)*0.28,0.86,lab{ii},'units','normalized','color',col{ii},'Fontsize',fs+1,'Interpreter','latex')
        end
    end
    xlim([0,nsec*1000])
    ylim([-maxi,maxi])
    
    set(gca,'XTick',xt);
    set(gca,'YTick',yt);
    
    if jj>2
        set(gca,'XTickLabel',xt);
    else
       set(gca,'XTickLabel',[]);
    end
    set(gca,'YTickLabel',yt)
    
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.04 op(3)-0.0 op(4)-0.04]); % OuterPosition = [left bottom width height]
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
    
end
axes

h1 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.06,0],'Fontsize',fs);
h2 = ylabel ('signal, estimate','units','normalized','Position',[-0.09,0.5,0],'Fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end


%%

