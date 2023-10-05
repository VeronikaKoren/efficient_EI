close all
clear all

addpath([cd,'/code/function/'])
saveres=1;
showfig=0;

disp('computing rsc as a function of the stimulus strength distinguishing aligned and misaligned and 3 levels of weight similarity (strong sim, weak similar and different)');

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=12;                                % duration of the trial in seconds 

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

%% weights, dot product and 3 groups for the weight similarity

[w,C] = w_fun(M,N,q,d);

%% compute noise correlation of spike counts for neurons with similar and different tuning

ntr=100;
L=30;                               % bin length in ms
Ldt=L/dt;  

mus_vec=0:5:50;
%mus_vec=0:5:50;
n=length(mus_vec);

r_divided_a=zeros(n,2,3);
r_divided_mis=zeros(n,2,3);

for g=1:n
    
    display(n-g,' to go')
    mu_abs=mus_vec(g);
    mu_s=[mu_abs,mu_abs,mu_abs]';
    
    if sum(abs(mu_s))==0
        sign_E =sign(sum(w{1}))';
        sign_I =sign(sum(w{2}))';
    else
        sign_E=sign(w{1}'*mu_s);
        sign_I=sign(w{2}'*mu_s);
    end

    idxp=find(sign_E>0);
    idxn=find(sign_E<0);
    idxpi=find(sign_I>0);
    idxni=find(sign_I<0);
    
    idxe={idxp,idxn};       % excitatory
    idxi={idxpi,idxni};     % inhibitory

    idxpos={idxp;idxpi};    % positive
    idxneg={idxn;idxni};    % negative
    
    wpos=cellfun(@(x,y) x(:,y),w,idxpos,'un',0);
    wneg=cellfun(@(x,y) x(:,y),w,idxneg,'un',0);

    [s,x]=signal_sepdim_fun(tau_s,tau_x,M,nsec,dt,mu_s);

    r_a_e=[];
    r_mis_e=[];
    r_a_i=[];
    r_mis_i=[];
    
    r_a=cell(2,1);
    r_m=cell(2,1);
    for tr=1:ntr

        [ye,yi] = net_fun_complete(dt,sigmav,mu,tau_vec,s,w,C);
         
        % compute correlation in trials, separately for aligned and
        % misaligned neurons
        for c=1:2
            
            [~,corr_vec] = rsc_fun(ye(idxe{c},:),yi(idxi{c},:),Ldt);
            
            if c==1  % aligned
                r_a_e=cat(1,r_a_e,corr_vec{1});
                r_a_i=cat(1,r_a_i,corr_vec{2});
            else    % misaligned
                r_mis_e=cat(1,r_mis_e,corr_vec{1});
                r_mis_i=cat(1,r_mis_i,corr_vec{2});
            end
        end
    end
    
    % average across trials
    r_a{1}=squeeze(nanmean(r_a_e));
    r_a{2}=squeeze(nanmean(r_a_i));
    r_m{1}=squeeze(nanmean(r_mis_e));
    r_m{2}=squeeze(nanmean(r_mis_i));

    % divide w.r.t. weight similarity
    r_divided_a(g,:,:) = divider_fun(wpos,r_a);      % aligned
    r_divided_mis(g,:,:) = divider_fun(wneg,r_m);     % misaligned

end

%%

if showfig==1

    namepop={'E-E','I-I'};
    green=[0.2,0.7,0];
    orange=[0.72,0.5,0.09];
    col={orange,green,'k'};

    figure()
    for d=1:2
        subplot(2,1,d)
        hold on
        for k=1:3
            plot(mus_vec,squeeze(r_divided_mis(:,d,k)),'color',col{k})
            
        end

        title(namepop{d})
        hold off
        if k==1
            legend('similar \gamma','different \gamma','Location','NorthWest')
        end
    end
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{d},{dt},{nsec}};
    
    savefile='result/stimulus/';
    savename='rsc_mus_3g2';
    save([savefile,savename],'r_divided_a','r_divided_mis','mus_vec','L','parameters','param_name')
    
end

