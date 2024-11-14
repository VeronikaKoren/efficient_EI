
clear all

saveres=0;

type=1;
namep={'structured','perm_full_all','perm_partial_all'};

ntr=200;  % number of trials
ptr=0.7;  % proportion of training data

disp(['training a decoder on activity from ',namep{type},' model'])
addpath([cd,'/code/function/'])
%% get activity
% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 

beta=14;                               % quadratic cost constant
sigmav=5;                              % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;

sigma_s=2;
tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
f=5; % 5 = all 3 connectivity matrices
%Jp={'','I to I','E to I','I to E','all'}; % connectivity submatrix that is permuted

%%

if type==1
    [w,J] = w_fun(M,N,q,d);
elseif or(type==2,type==3)
    [w,J,J_opti] = w_structure_fun(M,N,q,d,type,f);
end

% simulate network activity in trials (with different realization of stimuli and noise)

tic

target=cell(ntr,2);
rtr=cell(ntr,2);
rmse_shuffled=zeros(ntr,2);
rmse_opti=zeros(ntr,2);
for tr=1:ntr
    
    disp(ntr-tr)
    
    % stimulus and target signal
    [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
    
    % low-pass filtered spikes for the model with shuffled connectivity
    [~,~,xhat_e,xhat_i,re,ri] = net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J); 
    
    target{tr,1}=single(x);    
    rtr{tr,1}=single(re);
    rtr{tr,2}=single(ri);

    rmse_e=sqrt(mean(mean((x-xhat_e).^2,2))); % mean across dimensions and across time 
    rmse_i=sqrt(mean(mean((xhat_e-xhat_i).^2,2)));
    rmse_shuffled(tr,:)=cat(2,rmse_e,rmse_i);

    % performance of the model with optimal connectivity (% potentially unneccesary)
    if type>1  
        [~,~,xhat_e,xhat_i] = net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J_opti);
        target{tr,2}=single(xhat_e);

        rmse_e=sqrt(mean(mean((x-xhat_e).^2,2))); 
        rmse_i=sqrt(mean(mean((xhat_e-xhat_i).^2,2)));
        rmse_opti(tr,:)=cat(2,rmse_e,rmse_i);
    end
        
    target{tr,2}=single(xhat_e);
    
end
toc

%%

N_all=[size(rtr{1,1},1),size(rtr{1,2},1)];
T=size(target{1},2);

ntrain=ntr*ptr;
ntest=ntr-ntrain;

%% train linear model to find coefficients

tic

% split training data
y=cell(2,1);
X=cell(2,1);
for ii=1:2
    y{ii}=cell2mat(target(1:ntrain,ii)');
    X{ii}=cell2mat(rtr(1:ntrain,ii)');
end

%% get coefficients
w_d=cell(2,1);
for p=1:2
   
    wp=zeros(M,N_all(p));
    for k=1:M
        b=regress(y{p}(k,:)',X{p}');
        wp(k,:)=b;        
    end
    w_d{p}=wp;

end

%% error on training data

yhat_train=cellfun(@(a,b) a*b,w_d,X,'un',0); 
rmse_train=cellfun(@(a,b) sqrt(mean(mean((b-a).^2,2))),yhat_train,y,'un',1)';
%display(rmse_train,'training error E and I');

%% test on held out data in trials

rmse_d=zeros(ntest,2);
for ii=1:2
    for tr=1:ntest

        y_test=target{ntrain+tr,ii};
        X_test=rtr{ntrain+tr,ii};
        yhat=w_d{ii}*X_test;
        rmse_d(tr,ii)=sqrt(mean(mean((y_test-yhat).^2,2)));
    end
end
toc

%% test on held out data concatenated
%{
X_test=cell(2,1);
y_test=cell(2,1);
for ii=1:2
    
    y_test{ii}=cell2mat(target(ntrain+1:ntrain+ntest,ii)');
    X_test{ii}=cell2mat(rtr(ntrain+1:ntrain+ntest,ii)');
end

yhat=cellfun(@(a,b) a'*b,w_d,X_test,'un',0);
rmse_d=cellfun(@(a,b) sqrt(mean(mean((b-a).^2,2))),yhat,y_test,'un',1);
display(rmse_d,'testing error E and I');
%}


%% save result?

if saveres==1

    savefile='result/linear_regression/';
    savename=['rmse_w_',namep{type},'_',sprintf('%1.0i',ntr)];
    save([savefile,savename],'rmse_shuffled','rmse_opti','rmse_d','rmse_train','w_d','w','ptr','ntr');
end

