
%% plots the error and the loss for adaptation in E and for adaptation in I neurons

clear all
close all
clc

g_l=0.7;

ntype={'tau_re','tau_ri'};
namevar={'\tau_r^E (\tau_r^I=10 ms)','\tau_r^I (\tau_r^E=10 ms)'};

figname1='mse_taure_tauri';
figname2='cost_taure_tauri';
figname3='loss_taure_tauri';
figname4='inst_balance_taure_tauri';
figname5='average_imbalance_taure_tauri';
figname6='CV_taure_tauri';
figname7='fr_taure_tauri';
savefig=[0,0,0,0,0,0,0];

addpath('/Users/vkoren/ei_net/result/adaptation/')
savefile='/Users/vkoren/ei_net/figure/adaptation/taure_tauri_comparison/';

rmse=cell(2,1);
mc=cell(2,1);
loss_ei=cell(2,1);
inst_balance=cell(2,1);
average_imbalance=cell(2,1);
cv=cell(2,1);
fr=cell(2,1);

for type=1:2

    loadname=['measures_adaptation_', ntype{type}];
    load(loadname,'variable','rms','cost','r_ei','meanE','meanI','CVs','frate')
    
    rmse{type}=rms;
    mc{type}=cost;
    loss_ei{type}=(g_l.*rms) + ((1-g_l).*cost);
    inst_balance{type}=abs(r_ei);
    average_imbalance{type}=cat(2,sum(meanE,2),sum(meanI,2));
    cv{type}=CVs;
    fr{type}=frate;


    clear rms cost r_ei meanE meanI CVs frate 
    
end

%%
fs=15;
msize=6;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];

col={red,blue};

name_error={'RMSE^E','RMSE^I'};
name_cost={'MC^E','MC^I'};
name_loss={'LOSS^E','LOSS^I'};
namepop={'Exc','Inh'};


plt2=[0,0,8,10];

xlab=namevar;
xvec=variable;
xt=[10,60,200];
xlimit=[xvec(1),200];

%% encoding error

pos_vec=plt2;
yt=[1,10,100,1000,10000];
ytl={'10^0','10^1','10^2','','10^{4}'};
ylimit=[0,50];

H=figure('name',figname1);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,rmse{k}(:,ii),'color',col{ii});
    end
    hold off
    box off
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    xlim(xlimit)
    ylim(ylimit)
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',ytl,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        for ii=1:2
            text(0.08,0.9-(ii-1)*0.2,name_error{ii},'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.05 op(3)-0.03 op(4)+0.1])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)
    

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes
h2 = ylabel ('encoding error','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(1)==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% metabolic cost

ylimit=[0,15];
yt=[0,10];

H=figure('name',figname2);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,mc{k}(:,ii),'color',col{ii});
    end
    hold off
    box off
    %set(gca,'YScale','log')
    set(gca,'XScale','log')
    xlim(xlimit)
    ylim(ylimit)
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        for ii=1:2
            text(0.08,0.9-(ii-1)*0.2,name_cost{ii},'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.05 op(3)-0.03 op(4)+0.1])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)
    

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes

h2 = ylabel ('metabolic cost','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(2)==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% loss

pos_vec=plt2;
yt=[10,100];
ytl={'10^1','10^2'};
ylimit=[0,100];

H=figure('name',figname3);
for k=1:2
    subplot(2,1,k)

    hold on
    
    for ii=1:2
        plot(xvec,loss_ei{k}(:,ii),'color',col{ii});
    end
    plot(xvec,mean(loss_ei{k},2),':.','color','k');
    hold off
    box off

    set(gca,'YTick',yt)
    set(gca,'YTicklabel',ytl,'fontsize',fs)
    set(gca,'XTick',xt)
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    xlim(xlimit)
    ylim(ylimit)
    
    
    if k==1
        for ii=1:2
            text(0.08,0.9-(ii-1)*0.2,name_loss{ii},'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.05 op(3)-0.03 op(4)+0.1])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)
    
    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes
h2 = ylabel ('average loss','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(3)==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% inst balance

ylimit=[0.0,0.5];
yt=[0,0.5];

H=figure('name',figname4);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,inst_balance{k}(:,ii),'color',col{ii});
    end
    hold off
    box off
    
    xlim(xlimit)
    ylim(ylimit)
     set(gca,'XScale','log')
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        title('instantaneous balance','fontsize',fs)
        for ii=1:2
            text(0.03,0.32-(ii-1)*0.2,['in ',namepop{ii}],'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.04 op(3)-0.03 op(4)+0.05])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes

h2 = ylabel ('correlation coefficient','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(4)==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%% average imbalance

ylimit=[-3,12];
yt=[0,5];

H=figure('name',figname5);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,average_imbalance{k}(:,ii),'color',col{ii});
    end
    hold off
    box off
    
    xlim(xlimit)
    ylim(ylimit)
    set(gca,'XScale','log')
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        title('average imbalance','fontsize',fs)
        for ii=1:2
            text(0.03,0.85-(ii-1)*0.2,['in ',namepop{ii}],'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.04 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.05 op(3)-0.03 op(4)+0.1])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes

h2 = ylabel ('net synaptic input [mV]','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(5)==1
    print(H,[savefile,figname5],'-dpng','-r300');
end

%% CV

ylimit=[0,1.2];
yt=[0,0.5,1];

H=figure('name',figname6);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,cv{k}(:,ii),'color',col{ii});
    end
    hold off
    box off
    
    xlim(xlimit)
    ylim(ylimit)
    set(gca,'XScale','log')
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)

    if k==1
        for ii=1:2
            text(0.07,0.55-(ii-1)*0.2,namepop{ii},'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.05 op(3)-0.03 op(4)+0.1])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes

h2 = ylabel ('coefficient of variation','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(6)==1
    print(H,[savefile,figname6],'-dpng','-r300');
end

%% fiting rate

ylimit=[0,45];
yt=[0,20,40];

H=figure('name',figname7);
for k=1:2
    subplot(2,1,k)

    hold on
    for ii=1:2
        plot(xvec,fr{k}(:,ii),'color',col{ii});
    end
    hold off
    box off
    
    xlim(xlimit)
    ylim(ylimit)
    set(gca,'XScale','log')
    
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        for ii=1:2
            text(0.07,0.7-(ii-1)*0.2,namepop{ii},'units','normalized','fontsize',fs-1,'color',col{ii})
        end
        set(gca,'XTicklabel',[])
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.03 op(4)+0.05])
        
    else
        set(gca,'XTicklabel',xt)
        op=get(gca,'OuterPosition');
        set(gca,'OuterPosition',[op(1)+0.06 op(2)-0.05 op(3)-0.03 op(4)+0.1])
        
    end
    
    xlabel (namevar{k},'fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.018 0.018]);
    set(gca,'TickDir','out')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes

h2 = ylabel ('firing rate [Hz]','units','normalized','Position',[-0.08,0.6,0],'fontsize',fs);
set(gca,'Visible','off')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(7)==1
    print(H,[savefile,figname7],'-dpng','-r300');
end

