function [] = plt_network_taus(x,xhat_e,xhat_i,ye,yi,fe,fi,dt,tau_fe,tau_fi,figname, savefig,savefile,pos_vec,taus_vec)
% plot of the signal, the E estimate, the spike trains and the firing rate
% in a simulation trial

%%
T=size(fe,2);
nsec=(T*dt)/1000;
N=size(ye,1);

%% figure parameters

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];

fs=14;
ms=4;
lw=1.7;
lwa=1;
tl=0.01;

grid=(1:N)'*ones(1,T);  % grid for spikes
tindex=nsec*(1:T)/T*1000;

Ni=size(yi,1);
gridI=N+(1:Ni)'*ones(1,T);

% ticks

xt=0:400:nsec*1000;                         % in milliseconds
yt=[0,50];
ytr=[10,20];
ytn=[N,N+Ni];
ytl=[N,Ni];

maxi=round(max(max(xhat_i)))+28;

colhat=[1,0.2,0];
colhatI=blue;

taus_txt={['\tau^s_1=',sprintf('%1.0i',taus_vec(1)),' ms'],['\tau^s_2=',sprintf('%1.0i',taus_vec(2)),' ms'],['\tau^s_3=',sprintf('%1.0i',taus_vec(3)),' ms']};

%% plot

H=figure('name',figname);

for d=1:3
    subplot(6,1,d)
    
    hold on
    plot(tindex,xhat_i(d,:),'color',blue,'linewidth',lw+0.5)
    plot(tindex,xhat_e(d,:),'color',red,'linewidth',lw-0.5)
    plot(tindex,x(d,:),'-.','color','k','linewidth',lw-1)  
    hold off
    line([tindex(1), tindex(end)], [0,0],'color',[0.2,0.2,0.2,0.5])
    box off

    text(0.95,0.95,taus_txt{d},'units','normalized','fontsize',fs-1)
    
    ylabel(['dim.',sprintf('%1.0i',d)],'Fontsize',fs)
    ylim([-maxi+5,maxi])
    xlim([0,nsec*1000]) 
    
    set(gca,'XTick',xt);
    set(gca,'YTick',yt);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',yt,'Fontsize',fs)
   
    if d==1
        text(0.05,0.9,'target','units','normalized','color','k','Fontsize',fs,'Interpreter','tex')
        text(0.18,0.9,'E estimate','units','normalized','color',colhat,'Fontsize',fs,'Interpreter','tex')
        text(0.35,0.9,'I estimate','units','normalized','color',colhatI,'Fontsize',fs,'Interpreter','tex')
    end

    set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
    set(gca,'TickDir','out');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(6,1,[4 5])
hold on
p1=plot(tindex,(grid.*single(ye))','.','color',red,'markersize',ms);
p2=plot(tindex,(gridI.*single(yi))','.','color',blue,'markersize',ms);
hold off
box off

legend([p1(1),p2(1)],'Exc','Inh','Fontsize',fs,'Location','NorthWest')
set(gca,'xtick',xt);
set(gca,'XTickLabel',[])
ylabel('neuron idx','Fontsize',fs)

xlim([0,nsec*1000])
ylim([0.5 N+Ni+0.5])

set(gca,'YTick',ytn)
set(gca,'YTickLabel',ytl,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'TickDir','out');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(6,1,6)
hold on                
plot(tindex,(mean(fe,1)*1000)/tau_fe,'color',red,'linewidth',lw)            % firing rate [spikes/sec]
plot(tindex,(mean(fi,1)*1000)/tau_fi,'color',blue,'linewidth',lw)
hold off
box off
%legend('Excitatory','Inhibitory')
%ylabel('f^Y(t) / \tau_f^Y','Fontsize',fs)
ylabel('r^y(t) / \tau_r^y','Fontsize',fs)
set(gca,'YTick',ytr);
set(gca,'YTickLabel',ytr,'Fontsize',fs)
set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'Fontsize',fs)

xlim([0,nsec*1000])
ylim([0,30])

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'TickDir','out');

%%%%%%%%%%%%%%%%%%%%%%%
axes

h1 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.07,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

end

