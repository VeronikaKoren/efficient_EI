function [] = plt_2trials(spikes,est,dt,figname, savefig,savefile,pos_vec,type)
% plot of the signal, the E estimate, the spike trains and the firing rate
% in a simulation trial

%%
T=size(spikes{1},2);
nsec=(T*dt)/1000;
N=size(spikes{1},1);

%% figure parameters

red=[0.85,0.32,0.1];
green=[0.2,0.7,0.0];
%darkred=[1,0.2,0];
%blue=[0,0.48,0.74];

if type==1
    col1=red;
else
    col1=green;
end

fs=15;
ms=4;
lw=1.7;
lwa=1;
tl=0.01;

grid=(1:N)'*ones(1,T);  % grid for spikes
tindex=nsec*(1:T)/T*1000;

% ticks

xt=0:200:nsec*1000;                         % in milliseconds
yt=[0,40];
ytn=N;
ytl=N;

maxi=round(max(abs(est{1}(:))))+12;

colhat={'k',col1};
colspike={'k',col1};

linsty={'-','--'};
tit={'different noise across trials','same noise across trials'};
%% plot

H=figure('name',figname);

subplot(3,1,1)
hold on
for ii=1:2
    
    %plot(tindex,xhat_i(d,:),'color',blue,'linewidth',lw+0.5)
    plot(tindex,est{ii}(1,:),'color',colhat{ii},'linewidth',lw,'LineStyle',linsty{ii})
    %plot(tindex,x(d,:),'-.','color','k','linewidth',lw-1)
    text(0.02 + (ii-1)*0.15,0.9,['trial ',sprintf('%1.0i',ii)],'units','normalized','color',colhat{ii},'Fontsize',fs,'Interpreter','tex')
    
end

hold off
line([tindex(1), tindex(end)], [0,0],'color',[0.2,0.2,0.2,0.5])
box off

ylabel('estimate','Fontsize',fs)
ylim([-maxi+5,maxi])
xlim([0,nsec*1000])

set(gca,'XTick',xt);
set(gca,'YTick',yt);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',yt,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'TickDir','out');

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1) op(2) op(3)+0.03 op(4)+0.03])

title(tit{type},'Fontsize',fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,[2 3])
hold on
p1=plot(tindex,(grid.*single(spikes{1}))','.','color',colspike{1},'markersize',ms);             % black
p2=plot(tindex,(grid.*single(spikes{2}))','.','MarkerEdgeColor',colspike{2},'markersize',ms);   % green
%p2=plot(tindex,(grid.*single(spikes{2}))','.','MarkerEdgeColor',colspike{2},'markersize',ms);
hold off
box off

%legend([p1(1),p2(1)],'trial 1','trial 2','Fontsize',fs,'Location','NorthWest')
set(gca,'xtick',xt);
set(gca,'XTickLabel',[])
ylabel('neuron index','Fontsize',fs)

xlim([0,nsec*1000])
ylim([0.5 N+0.5])

set(gca,'YTick',ytn)
set(gca,'YTickLabel',ytl,'Fontsize',fs)
set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
set(gca,'TickDir','out');
xlabel('time [ms]')

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1) op(2) op(3)+0.03 op(4)+0.03])

%%%%%%%%%%%%%%%%%%%%%%%
%{
axes

h1 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.07,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
%}
set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

end

