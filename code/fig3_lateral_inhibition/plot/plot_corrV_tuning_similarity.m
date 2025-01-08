
clear all
close all

savefig=0;
type=3;

namet={'independent','normal','perm_full'};
nametyp={'independent input','efficient E-I','unstructured connectivity'};

addpath([cd,'/result/perturbation/'])
savefile=pwd;

loadname=['corr_Vm_',namet{type},'.mat'];
load(loadname)
   
%%

fs=11;
ms=3;
lw=1.7;
lwa=1;
pos_vec=[0,0,6,9];

namep={'E-E','I-I'};
gray=[0.7,0.7,0.7,0.7];

figname=['corr_Vm_',namet{type}];

%%

yt=-1:0.5:1;
xt=yt;

ytl={'-1','','0','','1'};
xtl=ytl;

H=figure('name',figname);
for k=1:2   % E,I
    
    x=dp{k}./max(dp{k});
    y=rVm{k};
    R=corr(x,y);

    subplot(2,1,k)
    plot(x,y,'.','Markersize',3,'Color',gray);
    line([min(x) max(x)],[0,0],'linestyle','--','Color','m')

    box off
    ylim([-0.7,1.0])
    xlim([-1,1])
    set(gca,'YTick',yt)
    set(gca,'XTick',xt)
    
    set(gca,'YTicklabel',ytl,'fontsize',fs)
    if k==1
        set(gca,'XTicklabel',[])
        title({nametyp{type},namep{k}},'fontweight','normal','fontsize',fs)
    else
        set(gca,'XTicklabel',xtl,'fontsize',fs)
        title(namep{k},'fontweight','normal','fontsize',fs)
    end
    
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')
    
    op=get(gca,'OuterPosition');
    if k==1
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.03 op(3)-0.05 op(4)-0.06]);
    else
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.03 op(3)-0.05 op(4)-0.03]);
    end
    
end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('voltage correlation coefficient','units','normalized','Position',[-0.05,0.5,0],'fontsize',fs+1);
h2 = xlabel ('tuning similarity','units','normalized','Position',[0.5,-0.055,0],'fontsize',fs+1);
set(gca,'Visible','off')
if type==2
    set(h1,'visible','on')
end
set(h2,'visible','on')

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%%
 

