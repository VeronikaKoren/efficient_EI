clear all
close all

savefig=0;
figname='varV_regular_permuted';

addpath('/Users/vkoren/ei_net/result/connectivity/')
%addpath('result/connectivity/')
savefile=[cd,'/figure/'];

%% load permuted

loadname='stdV_perm_full';
load(loadname)
order=[2,1,3,4];
Co=Ct(order);
stdv=stdV(order,:);

%% load regular
loadname='stdV_regular';
load(loadname)
std_regular={stdVe,stdVi};
%%

fs=14;
ms=7;
lw=1.7;
lwa=1;
pos_vec=[0,0,9,10];


darkred=[0.7,0,0.2];
green=[0.2,0.7,0];
orange=[1,0.5,0];
col={'m',green,orange,darkred};

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
colpop={red,blue};
%%

maxi=max(max(cellfun(@max,stdV)));
mini=min(min(cellfun(@min,stdV)));
xvec=linspace(mini-1,maxi+1,200);

%%
namepop={'E cell type','I cell type'};
xt=7:7:21;
yt=0:5:5;

H=figure('name',figname);
for k=1:2           % E and I

    subplot(2,1,k)
    hold on
    mr=mean(std_regular{k});
    line([mr mr],[0,6],'color','k','LineStyle','--');
    for t=1:4       % type
        f=ksdensity(stdv{t,k},xvec,'BoundaryCorrection', 'Reflection');
        plot(xvec,f,'color',col{t});
        if k==1
            text(0.7,0.8-(t-1)*0.2,Co{t},'units','normalized','fontsize',fs,'color',col{t})
        end
    end

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.03 op(3)-0.0 op(4)+0.0]);

    hold off
    box off
    
    xlim([5,maxi+1])
    ylim([0,7])

    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTicklabel',[])
    else
        set(gca,'XTicklabel',xt)
    end

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
    title(namepop{k},'fontweight','normal')
    
end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('density','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('STD membrane potential','units','normalized','Position',[0.5,-0.04,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

