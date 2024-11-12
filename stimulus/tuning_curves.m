% for the plot of the activity

%close all
clear all
%clc

saveres=0;
addpath([cd,'/code/function/'])
disp('tuning curves in E and I neurons')

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
sigmav=5;                       % noise intensity

dt=0.02;                               % time step in ms     
q=4;                                 % ratio number E to I neurons
d=3;                                   % ratio IPSP/EPSP 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
[w,J] = w_fun(M,N,q,d);

%% set the input

a_s=1.6;

T=(nsec*1000)./dt;
s=ones(M,T).*a_s;
Ni=N/q;

%% simulate network activity

ntr=100;
as1=-5:0.1:5;
ns=length(as1);

tuningE=zeros(ns,N);
tuningI=zeros(ns,Ni);
for k=1:ns
    disp(ns-k)

    s(1,:)=as1(k);
    sc_E=zeros(ntr,N);
    sc_I=zeros(ntr,Ni);
    for tr=1:ntr
        [fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J);
        sc_E(tr,:)=sum(fe,2)./nsec;              
        sc_I(tr,:)=sum(fi,2)./nsec;
    end

    tuningE(k,:)=mean(sc_E);
    tuningI(k,:)=mean(sc_I);

end

% normalized tuning
maxi=max(tuningE,[],1);
tunE=tuningE./repmat(maxi,ns,1);

maxi=max(tuningI,[],1);
tunI=tuningI./repmat(maxi,ns,1);

%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/stimulus/';
    savename='tuning_curves';
    save([savefile,savename],'tuningE','tuningI','as1','a_s','tunE','tunI','parameters','param_name')

end

%% normalized firing rate

%{
savefig=0;
figname='tuning_curves';
savefile='/Users/vkoren/ei_net/figure/stimulus/';
colormap pink

fs=14;

pos_vec=[0,0,12,12];

H=figure('name',figname);
subplot(2,1,1)
hold 
for jj=1:10
    plot(as1,tunE(:,jj))
end
hold off
title('E neurons')

subplot(2,1,2)
hold on
for jj=1:10
    plot(as1,tunI(:,jj))
end
hold off
title('I neurons')

axes
h1 = ylabel ('normalized firing rate','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs);
h2 = xlabel ('stimulus features s_k(t)','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end
%}
%%
%% sharpness of tuning
%{
xsiE=mean(abs(diff(tunE)),1);
xsiI=mean(abs(diff(tunI)),1);

figure()
histogram(xsiE)
hold on
histogram(xsiI)
%}


%%
%{
figure()
subplot(2,1,1)
hold 
for jj=1:10
    plot(as1,tuningE(:,jj))
end
hold off

subplot(2,1,2)
hold on
for jj=1:10
    plot(as1,tuningI(:,jj))
end
hold off

axes
h1 = ylabel ('firing rate [Hz]','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs);
h2 = xlabel ('stimulus features s_k(t)','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname1],'-dpng','-r300');
end
%}