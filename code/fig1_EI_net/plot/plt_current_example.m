
close all
clear
clc

savefig=0;
addpath([cd,'/code/function/']);
savefile=pwd;

figname='I_syn_example';

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
beta=14;                           % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% set the input

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);

%% get synaptic currents for example E and I neuron

cn=[randi(N,1),randi(N/q,1)]; % choose rnaodmly one E and one I neuron
[I_E,I_I] = current_fun_time(dt,sigmav,beta,tau_vec,s,N,q,d,cn);

%%
red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
colE={'k',blue};
colI={red,blue};

fs=13;
ms=6;
lw=1.2;
lwa=1;

pos_vec=[0,0,16,9];

namec={'ff','Inh';'Exc','Inh'};
%%

tindex= ((1:T).*dt);

xt=0:400:800;
%yt=0:5:5;

H=figure('name',figname);
subplot(2,1,1)
hold on
for ii=1:2
    plot(tindex,I_E(ii,:),'color',colE{ii},'linewidth',lw)
    text(0.05+(ii-1)*0.12,0.9,namec{1,ii},'units','normalized','color',colE{ii},'Fontsize',fs)
end
hold off
%ylim([-1,1].*2.4)

set(gca,'XTick',xt);
set(gca,'XTickLabel',[])
%set(gca,'YTick',0:2:2);
%set(gca,'YTickLabel',0:2:2,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out');
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.03 op(3)-0.02 op(4)-0.01]);

%%%%
subplot(2,1,2)
hold on
for ii=1:2
    plot(tindex,I_I(ii,:),'color',colI{ii},'linewidth',lw)
    text(0.05+(ii-1)*0.1,0.9,namec{2,ii},'units','normalized','color',colI{ii},'Fontsize',fs)
end
hold off
%ylim([-1,1].*7.8)

set(gca,'XTick',xt);
set(gca,'XTickLabel',xt)
%set(gca,'YTick',yt);
%set(gca,'YTickLabel',yt,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out');

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.01 op(2)+0.03 op(3)-0.02 op(4)+0.02]);

axes
h1 = ylabel ('synaptic input [mV]','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs+1);
h2 = xlabel ('time [ms]','units','normalized','Position',[0.55,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')


set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
