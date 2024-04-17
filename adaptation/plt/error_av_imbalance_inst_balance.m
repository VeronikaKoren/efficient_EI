
clear all
close all

g_l=0.7;        % weighting of the error vs cost

savefig=0;
showfig=0;
namepop={'in E','in I'}
%%

addpath('/Users/vkoren/ei_net/result/adaptation/')
loadname= 'adaptation_2d_measures';
load(loadname,'rms','meanE','meanI','r_ei','variable','cost')

figname1='correlation_error_balance';
figname2='correlation_efficiency_balance';

savefile='/Users/vkoren/ei_net/figure/adaptation/';

idx=find(variable==10);
vec=idx:length(variable);

%% correlation (loss, average imbalance) / (loss,instantaneous balance)

loss_ei=log(g_l*rms(vec,vec,:) +((1-g_l).*cost(vec,vec,:)));
net=meanE(vec,vec,:)+meanI(vec,vec,:);
rei=abs(r_ei(vec,vec,:));

r_inst=zeros(2,1);
r_average=zeros(2,1);
for p=1:2
    x=loss_ei(:,:,p);
    y=rei(:,:,p);
    z=net(:,:,p);
    r_inst(p)=corr(x(:),y(:));
    r_average(p)=corr(x(:),z(:));
end

display(r_average,'r_loss average_imbalance');
display(r_inst,'r_loss inst_balance')
%%

if showfig==1
    
    fs=15;
    lw=1.5;
    lwa=1;
    yt=-0.5:0.5:0.5;
    pos_vec=[0,0,8,12];
    red=[0.85,0.32,0.1];
    blue=[0,0.48,0.74];
    col={red,blue}

    H=figure();
    subplot(2,1,1)
    b=bar(r_average);
    b.FaceColor = 'flat';
    b.CData(1,:) = red;
    b.CData(2,:) = blue;
    axis([0,3,-0.5,0.5])
    set(gca,'XTick',[1,2])
    set(gca,'XTickLabel',[])
     set(gca,'YTick',yt,'fontsize',fs)
    box off
    title('loss vs. average imbalance','fontsize',fs,'fontweight','normal')

    subplot(2,1,2)
    b=bar(r_inst);
    b.FaceColor = 'flat';
    b.CData(1,:) = red;
    b.CData(2,:) = blue;
    axis([0,3,-0.5,0.5])
    set(gca,'XTick',[1,2])
    set(gca,'XTickLabel',namepop,'fontsize',fs)
    box off
    axis
    title('loss vs. inst. balance','fontsize',fs,'fontweight','normal')
    set(gca,'YTick',yt,'fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    %set(gca,'TickDir','out')

    axes
    h2 = ylabel ('correlation coefficient','units','normalized','Position',[-0.06,0.5,0],'fontsize',fs);
    set(gca,'Visible','off')
    set(h2,'visible','on')

    set(H, 'Units','centimeters', 'Position', pos_vec)
    set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

    if savefig==1
        print(H,[savefile,figname],'-dpng','-r300');
    end
end
%%

