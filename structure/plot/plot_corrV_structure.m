clear all
%

namet='perm_full';

savefig=0;
savefile='/users/vkoren/ei_net/figure/structure/';

figname=['corrV_', namet];

%% load result

% permuted
addpath('/Users/vkoren/ei_net/result/connectivity/')
loadname=['corrV_', namet];
load(loadname);

% regular

addpath('/Users/vkoren/ei_net/result/statistics/Vm/')
loadname='corr_Vm_normal.mat';
load(loadname)
rreg=(cellfun(@(x) permute(x,[2,1]),rVm(1:2),'un',0))';
dpreg=(cellfun(@(x) x./max(x),dp(1:2),'un',0))';
clear rVm
clear dp

%%
order=[2,3,4,1];
Cnew=Co(order);

fs=12;
ms=2;
lw=1.7;
lwa=1;
pos_vec=[0,0,15,10];

darkred=[0.7,0,0.2];
green=[0.2,0.7,0];
orange=[1,0.5,0];
col={'m',green,orange,darkred};
gray=[0.7,0.7,0.7];

n=length(col);
namepop={'E-E','I-I'};

%%

xt=[0,1];
yt=[0,0.5,1];
ax=[0,1,-0.3,1];

H=figure('name',figname);

for k=1:2
    for g=1:n
        subplot(2,4,g+(k-1)*n)
        gg=order(g);
        hold on
        scatter(dpo{gg,k},rV{gg,k},2,'MarkerFaceColor',col{g},'MarkerEdgeColor',col{g})
        scatter(dpreg{k},rreg{k},1,'MarkerFaceColor',gray,'MarkerEdgeColor',gray,'MarkerFaceAlpha',0.3,'MarkerEdgeAlpha',0.3)
        
        hold off
        
        axis(ax)
        set(gca,'YTick',yt)
        set(gca,'XTick',xt)
        if g==1
            set(gca,'YTicklabel',yt,'fontsize',fs)
        else
            set(gca,'YTickLabel',[])
        end
        if g==4
            th=text(1.05,0.45,namepop{k},'units','normalized','fontsize',fs);
            %set(th,'Rotation',0)
        end
        
        if k==1
            title(Cnew{g},'fontsize',fs,'fontweight','normal')
            set(gca,'XTicklabel',[])
        else
            set(gca,'XTicklabel',xt,'fontsize',fs)
        end

        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)-0.02 op(2)+0.02 op(3)+0.04 op(4)+0.0]);
        set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
        set(gca,'TickDir','out')
    end
    
end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('voltage correlation','units','normalized','Position',[-0.1,0.5,0],'fontsize',fs+1);
h2 = xlabel ('tuning similarity','units','normalized','Position',[0.5,-0.05,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% boxplot all correlations
%{
figure()
for k=1:2
    r=cell2mat(r_all(:,k));
    subplot(2,1,k)
    boxplot(r')

    set(gca,'XTick',1:5)
    set(gca,'XTickLabel',namec)
end
%%
colpop={'r','b'};
r_mean=cellfun(@mean,r_all);
r_sim=cellfun(@mean,r_similar);

figure
subplot(2,1,1)
hold on
for k=1:2
    plot(1:5,r_mean(:,k),colpop{k})
end
set(gca,'XTick',1:5)
set(gca,'XTickLabel',namec)
ylim([0,0.55])

subplot(2,1,2)
hold on
for k=1:2
    plot(1:5,r_sim(:,k),colpop{k})
end
set(gca,'XTick',1:5)
set(gca,'XTickLabel',namec)
ylim([0,0.55])
%}
