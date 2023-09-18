function [] = plt_1pop_network(x,xhat,y,r,dt,tau,pos_vec,savefig,savefile,figname)
 % plot the signal and estimate, spike train and firing rate

%%

T=size(x,2);
nsec=(T*dt)/1000;
N=150;

%% figure parameters

magenta=[1,0,1,0.5];

fs=13;
ms=5;
lw=1.7;
lwa=1;
tl=0.01;

%% grid

grid=(1:N)'*ones(1,T);
tindex=nsec*(1:T)/T*1000;

%% ticks

xt=200:200:nsec*1000;                         % in milliseconds
signals=cat(1,x,xhat);

maxy=max(abs(signals(:)));
%ytr=round(maxy)/2;
ytr=30;
yt=[0,ytr];
ytn=N/2:N/2:N;

xlimit=[0,nsec*1000];
namex={'$x_1(t)$','$x_2(t)$','$x_3(t)$'};
namexhat={'$\hat{x}_1(t)$','$\hat{x}_2(t)$','$\hat{x}_3(t)$'};

y=y(1:N,:);
%% plot

H=figure('name',figname);

for d=1:3
    subplot(6,1,d)
    
    hold on
    plot(tindex,x(d,:),'color','k','linewidth',lw)
    plot(tindex,xhat(d,:),'color',magenta,'linewidth',lw-0.7)  
    hold off
    box off
    
    ylabel(['dim.',sprintf('%1.0i',d)],'FontName','Arial','Fontsize',fs)
    xlim(xlimit) 
    ylim([-maxy,maxy])
    
    text(0.02,0.85,namex{d},'units','normalized','color','k','Fontsize',fs+1,'Interpreter','latex')
    text(0.02+0.1,0.85,namexhat{d},'units','normalized','color',magenta,'Fontsize',fs+1,'Interpreter','latex')
    set(gca,'XTick',xt);
    set(gca,'YTick',yt);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',yt,'FontName','Arial','Fontsize',fs)
    
    set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
    set(gca,'TickDir','out');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(6,1,[4 5])
hold on
plot(tindex,(grid.*y)','k.','markersize',ms);
hold off
box off

set(gca,'xtick',xt);
set(gca,'XTickLabel',[])
ylabel('neural index','FontName','Arial','Fontsize',fs)

xlim(xlimit)
ylim([0.5 N+0.5])

set(gca,'YTick',ytn)
set(gca,'YTickLabel',ytn,'FontName','Arial','Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'TickDir','out');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(6,1,6)
plot(tindex,(mean(r,1)*1000)./tau,'k','linewidth',lw)            % firing rate [spikes/sec]
box off
ylabel('r(t) / \tau_r','FontName','Arial','Fontsize',fs)
%ylabel('firing rate [Hz]','FontName','Arial','Fontsize',fs)
set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'FontName','Arial','Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
xlim(xlimit)

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'TickDir','out');

%%%%%%%%%%%%%%%%%%%%%%%
axes

h1 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.07,0],'FontName','Arial','fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    saveas(H,[savefile,figname],'png');
end

end

