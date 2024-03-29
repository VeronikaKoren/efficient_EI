
clear all
close all
clc

savefig=0;

%cases=1;

namec={'local_current_E','local_current_I'};
namevar={'\tau_r^E','\tau_r^I'};

figname1='rmse_net';
figname2='rmse_inst';

addpath('/Users/vkoren/ei_net/result/adaptation/')
savefile='/Users/vkoren/ei_net/figure/adaptation/';

rms=cell(2,1);
net=cell(1,1);
inst=cell(1,1);
for cases=1:2
    loadname=['measures_', namec{cases}];
    load(loadname)

    idx=find(variable==10);
    vec=idx:length(variable);
    
    net{cases}=meanE(vec,1)+meanE(vec,2);
    inst{cases}=abs(r_ei(vec,:));

    mse=ms(vec,:);
    rms{cases}=sqrt(mse);
end

%%

fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];

col={red,blue};
namepop={'in Exc','in Inh'};
tit={'adapt. in E','adapt. in I'};

%%

pos_vec=[0,0,13,6.5];

H=figure('name',figname1)

for cases=1:2
    subplot(1,2,cases)
    hold on
    plot(rms{cases}(:,1),net{cases},'x','color',col{1})
    plot(rms{cases}(:,2),net{cases},'x','color',col{2})
    hold off

    if cases==1
        for ii=1:2
            text(0.15,0.9-(ii-1)*0.17,namepop{ii},'units','normalized','color',col{ii},'fontsize',fs)
        end
    end

    title(tit{cases},'fontsize',fs)
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.04 op(3)-0.00 op(4)-0.05]);
end

axes
h1 = ylabel ('net current','units','normalized','Position',[-0.1,0.5,0],'fontsize',fs);
h2 = xlabel ('RMSE','units','normalized','Position',[0.5,-0.03,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right siz

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%%
pos_vec=[0,0,13,6.5];

H=figure('name',figname2)

for cases=1:2
    subplot(1,2,cases)
    hold on
    plot(rms{cases}(:,1),inst{cases},'x','color',col{1})
    plot(rms{cases}(:,2),inst{cases},'x','color',col{2})
    hold off

    if cases==1
        for ii=1:2
            text(0.15,0.9-(ii-1)*0.17,namepop{ii},'units','normalized','color',col{ii},'fontsize',fs)
        end
    end

    title(tit{cases},'fontsize',fs)
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.04 op(3)-0.00 op(4)-0.05]);
end

axes
h1 = ylabel ('corr. coefficient','units','normalized','Position',[-0.1,0.5,0],'fontsize',fs);
h2 = xlabel ('RMSE','units','normalized','Position',[0.5,-0.03,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right siz

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%corr(error,net)
%%
%{
pos_vec=plt2;
yt=[1,10,100,1000];
ytl={'10^0','10^1','10^2','10^3'};

H=figure('name',figname,'visible',vis{1});
subplot(2,1,1)
hold on
plot(xvec,frate(:,1),'color',colI{1},'linewidth',lw);
plot(xvec,frate(:,2),'color',colI{2},'linewidth',lw);
hold off
box off
%set(gca,'YScale','log')

for ii=1:2
    text(0.7,0.8-(ii-1)*0.15,nameI{ii},'units','normalized','fontsize',fs-1,'color',colI{ii})
end

xlim(xlimit)
ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',ytl,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yt=[0.5,1];

subplot(2,1,2)
hold on
plot(xvec,CVs(:,1),'color',red,'linewidth',lw);
plot(xvec,CVs(:,2),'color',blue,'linewidth',lw);
hold off
box off

ylabel('coeff. variation','fontsize',fs)
xlabel (xlab,'fontsize',fs);
xlim(xlimit)
ylim([0.5,1.3])

set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%}
%%
