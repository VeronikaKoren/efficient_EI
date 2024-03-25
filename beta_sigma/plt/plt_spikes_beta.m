close all
clear all
clc

savefig=0;
figname='spikes_mu';
savefile=[cd,'/figure/implementation/'];

addpath([cd,'/code/function/'])

%%
M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=0.5;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   

c=33;
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);
[w,C] = w_fun(M,N,q,d); 

%% get spikes for a couple of values of the metabolic constant

muvec=[1,6,15,30];
n=length(muvec)
spikes_E=cell(n,1);
spikes_I=cell(n,1);

for ii=1:n
    mu=muvec(ii);
    [ye,yi,xhat_e,xhat_i,fe,fi] = net_fun_complete(dt,sigmav,mu,tau_vec,s,w,C);
    spikes_E{ii}=ye;
    spikes_I{ii}=yi;
end


%% fig parameters

fs=16;
ms=4;
lw=1.7;
lwa=1;

pos_vec=[0,0,17,16];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};

%%
nit=length(spikes_E);
Ne=size(spikes_E{1},1);
Ni=size(spikes_I{1},1);

T=size(spikes_I{1},2);
tindex=[1:T].*dt;

xt=0:200:nsec*1000;                         % in milliseconds
gridE=(1:Ne)'*ones(1,T);
gridI=Ne+(1:Ni)'*ones(1,T);

%% plot spikes

H=figure('name',figname);
for ii=1:n
    
    ye=spikes_E{ii};
    yi=spikes_I{ii};
    
    subplot(nit,1,ii)
    hold on
    p1=plot(tindex,(gridE.*single(ye))','.','color',col{1},'markersize',ms);
    p2=plot(tindex,(gridI.*single(yi))','.','color',col{2},'markersize',ms);
    hold off
    box off
    if ii==1
        legend([p1(1),p2(1)],'Exc','Inh','Fontsize',fs-2,'Location','NorthWest')
    end
    set(gca,'xtick',xt);
    if ii==nit
        set(gca,'XTickLabel',xt,'Fontsize',fs)
    else
        set(gca,'XTickLabel',[])
    end
    
    set(gca,'YTick',Ne)
    set(gca,'YTickLabel',Ne,'Fontsize',fs)
    text(1.01,0.3,['\beta = ',sprintf('%1.0f',muvec(ii))],'units','normalized','fontsize',fs,'Rotation',35)
    
    if ii==5
        annotation('ellipse',[.89 .32 .022 .025],'EdgeColor','m','FaceColor','m')
    end
    xlim([0,nsec*1000])
    ylim([0.5 Ne+Ni+0.5])
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1) op(2) op(3)-0.05 op(4)])
    
end
axes

h1 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.07,0],'fontsize',fs);
h2 = ylabel ('neuron index','units','normalized','Position',[-0.09,0.5,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

