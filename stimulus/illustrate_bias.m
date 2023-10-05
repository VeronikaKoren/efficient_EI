clear all
%clc

savefig=0;
figname='illustrate_bias';
savefile=[cd,'/figure/stimulus/'];

addpath([cd,'/code/function/'])
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

mu_s=30;
%%

[s,x]=signal_sepdim_fun(tau_s,tau_x,M,nsec,dt,mu_s);
[w,C] = w_fun(M,N,q,d);

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
fs=13;
ms=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={'k',blue,red};
coltr={[0.2,0.7,0.5],[0.7,0.2,0.5],[0.5,0.7,0.2]};

pos_vec=[0,0,8,10];

xt=0:100:200;
%yt=0:200:200;
yt=[250,300];
ylimit=[230 360];
xtl=[xt-100];

tindex=(1:T)*dt;
%nameg={'signal','I estimate','E estimate'};
nameg={'$x_1(t)$','$\langle \hat{x}^I_1(t) \rangle$','$\langle \hat{x}^E_1(t) \rangle$'};

ax=[100,200,230,330];
%%

d=[0.0,0.2,0.25];
hx=170;
dx=10;
hx2=hx+dx;
mI=squeeze(mean(estI(:,1,:)));
mE=squeeze(mean(estE(:,1,:)));

H=figure('name',figname);
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
set(gca,'XTicklabel',xt-100,'fontsize',fs)

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

%red arrow
line([hx hx],[mE(hx/dt) x(1,hx/dt)],'color',red,'linewidth',lw)
plot(hx,mE(hx/dt)+3,'v','color',red,'MarkerFaceColor',red,'MarkerSize',3)
plot(hx,x(1,hx/dt)-3,'^','color',red,'MarkerFaceColor',red,'MarkerSize',3)

% blue arrow
line([hx2 hx2],[mI((hx2)/dt) mE(hx2/dt)],'color',blue,'linewidth',lw)
plot(hx2,mI(hx2/dt)+1,'v','color','k','MarkerFaceColor',blue,'MarkerSize',3)
plot(hx2,mE(hx2/dt)-1,'^','color','k','MarkerFaceColor',blue,'MarkerSize',3)
hold off

axis(ax)

idxp=[1,3,2];
for ii=1:3
    text(0.05+(ii-1)*d(ii),0.9,nameg{idxp(ii)},'units','normalized','interpreter','latex','fontsize',fs+1,'color',col{idxp(ii)})
end
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt-100,'fontsize',fs)

%ylabel ('sig.,estimate','fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.03 op(3)-0.05 op(4)-0.03]);
axes
h1 = ylabel ('signal estimate','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.04,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')
set(h1,'visible','on')
set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%



