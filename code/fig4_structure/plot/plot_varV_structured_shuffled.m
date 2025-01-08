
clear all
close all

savefig=0;
figname='stdV_structured_shuffled';

addpath('result/connectivity/')
savefile=[cd,'/figure/structure/fully_permuted/'];

%% load structured and shuffled 

ntype={'structured','full_perm_all','partial_perm_all'};

stdve=cell(2,1);
stdvi=cell(2,1);
for t=1:2
    loadname=['stdV_',ntype{t}];
    load(loadname);
    stdve(t,:)=stdV(1);
    stdvi(t,:)=stdV(2);
end

stdv=cat(2,stdve,stdvi);
%%

fs=14;
ms=7;
lw=1.7;
lwa=1;
pos_vec=[0,0,8,10];

darkred=[0.8,0,0.1];
green=[0.2,0.7,0];
orange=[1,0.5,0];
%col={'m',green,orange,darkred};
col={'k',darkred};
%red=[0.85,0.32,0.1];
%blue=[0,0.48,0.74];
%colpop={red,blue};

texts={'structured','shuffled'}
%%

maxi=max(max(cellfun(@max,stdvi)));
mini=min(min(cellfun(@min,stdvi)));
xvec=linspace(mini-1,maxi+1,200);

%%
namepop={'E neurons','I neurons'};
xt=7:7:21;
yt=0:1:2;

H=figure('name',figname);
for k=1:2           % E and I

    subplot(2,1,k)
    hold on
    
    for t=1:2       % type
        f=ksdensity(stdv{t,k},xvec,'BoundaryCorrection', 'Reflection');
        plot(xvec,f,'color',col{t});
        if k==1
            text(0.6,0.85-(t-1)*0.17,texts{t},'color',col{t},'units','normalized','fontsize',fs-1)
        end

    end

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.03 op(3)-0.0 op(4)+0.0]);

    hold off
    box off
    
    xlim([5,18])
    ylim([0,1.7])

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
    title(namepop{k},'fontsize',fs)
    
end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('density [1/mV]','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('STD membrane potential','units','normalized','Position',[0.5,-0.04,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

