clear all
%clc

savefig=0;
figname='illustrate_bias_trials';

savefig2=0;
figname2='illustrate_bias_trials_and_average';
%savefile=[cd,'/figure/'];
savefile='/Users/vkoren/ei_net/figure/implementation/';

addpath([cd,'/function/'])
disp('illustrate bias');

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=0.3;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
mu=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

sigma_s=2;                              % STD of input features
%%

[s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
[w,C] = w_fun(M,N,q,d);

figure()
plot(x(1,:))

%% compute performance with noise in the connectivity

T=nsec*1000/dt;
ntr=100;

estE=zeros(ntr,M,T);
estI=zeros(ntr,M,T);

for ii=1:ntr
    
    [~,~,xhat_e,xhat_i] = net_fun_complete(dt,sigmav,mu,tau_vec,s,w,C);
    %[r,mean_eiff,CV,fr,xhat_e,xhat_i,ms,ratio] = current_fun2(dt,sigmav,mu,tau_vec,s,N,q,d,x);
    
    estE(ii,:,:)=xhat_e;
    estI(ii,:,:)=xhat_i;
    
end

% time-dependent bias of the estimate
BE=squeeze(mean(estE)) - x;
BI=squeeze(mean(estI)) - squeeze(mean(estE));

% time-dependent variance of the estimate
%VE=squeeze(var(estE));
%VI=squeeze(var(estI));

%%

fs=14;
ms=6;
lw=1.2;
lwa=1;

coltr={[0.2,0.7,0.5],[0.7,0.2,0.5],[0.5,0.7,0.2]};

pos_vec=[0,0,8,6];

xt=0:100:200;
%yt=0:200:200;
yt=[0,30];

tindex=(1:T)*dt;
ax=[0,300,-40,45];

H=figure('name',figname);
hold on
for ii=1:3
    plot(tindex,squeeze(estE(ii,1,:)),'color',coltr{ii},'linewidth',lw-0.5)
end
plot(tindex,x(1,:),'k','linewidth',lw)
for ii=1:3
    text(0.15+(ii-1)*.27,0.95,['trial ',sprintf('%1.0i',ii)],'units','normalized','fontsize',fs,'color',coltr{ii})
end
hold off
axis(ax)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.07 op(3)-0.03 op(4)-0.03]);

axes
h1 = ylabel ('estimate','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.03,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')
set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% plot trials and trial average

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={'k',blue,red};

%nameg={'signal','I estimate','E estimate'};
nameg={'$x_1(t)$','$\langle \hat{x}^I_1(t) \rangle$','$\langle \hat{x}^E_1(t) \rangle$'};

pos_vec=[0,0,8,10];
ax=[0,300,-33,50];
d=[0.0,0.2,0.25];

mI=squeeze(mean(estI(:,1,:)));
mE=squeeze(mean(estE(:,1,:)));

H2=figure('name',figname2);
subplot(2,1,1)
hold on
for ii=1:3
    plot(tindex,squeeze(estE(ii,1,:)),'color',coltr{ii},'linewidth',lw-0.5)
end
plot(tindex,x(1,:),'k','linewidth',lw)
for ii=1:3
    text(0.05+(ii-1)*.27,0.95,['trial ',sprintf('%1.0i',ii)],'units','normalized','fontsize',fs,'color',coltr{ii})
end
hold off
axis(ax)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.03 op(3)-0.05 op(4)-0.03]);

%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2)
hold on
plot(tindex,x(1,:),'color',col{1},'linewidth',lw)
plot(tindex,mI,'color',col{2},'linewidth',lw)
plot(tindex,mE,'color',col{3},'linewidth',lw)
axis(ax)

idxp=[1,3,2];
for ii=1:3
    text(0.05+(ii-1)*d(ii),0.95,nameg{idxp(ii)},'units','normalized','interpreter','latex','fontsize',fs+1,'color',col{idxp(ii)})
end
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)

%ylabel ('sig.,estimate','fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.03 op(3)-0.05 op(4)+0.03]);

axes
h1 = ylabel ('signal estimate','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.04,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')
set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end

%%



