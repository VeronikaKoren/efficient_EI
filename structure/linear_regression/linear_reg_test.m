
clear all

saveres=1;
showfig=0;

namep='perm_full_all';

addpath([cd,'/result/linear_regression/'])
loadname='activity_shuffle_all';

load(loadname)

%% 

M=size(signal{1},1);
N=[size(rtr{1,1},1),size(rtr{1,2},1)];
T=size(signal{1},2);
ntr=size(signal,1);

ptr=0.7;

ntrain=ntr*ptr;
ntest=ntr-ntrain;

%% train linear model to find coefficients

tic

% training data
y=single(cell2mat(signal(1:ntrain)'));
X=cell(2,1);
X{1}=single(cell2mat(rtr(1:ntrain,1)'));
X{2}=single(cell2mat(rtr(1:ntrain,2)'));

% get coefficients

w_d=cell(2,1);
for p=1:2
   
    w=zeros(N(p),M);
    for k=1:M
        b=regress(y(k,:)',X{p}');
        w(:,k)=b;        
    end
    w_d{p}=w;

end

% error on training data
yhat_train=cellfun(@(a,b) a'*b,w_d,X,'un',0); 
rmse_train=cellfun(@(x) sqrt(mean(mean((y-x).^2,2))),yhat_train,'un',1);

display(rmse_train,'training error E and I');
toc

%% test on held out data

ytest=single(cell2mat(signal(ntrain+1:ntrain+ntest)'));
X_test=cell(2,1);
X_test{1}=single(cell2mat(rtr(ntrain+1:ntrain+ntest,1)'));
X_test{2}=single(cell2mat(rtr(ntrain+1:ntrain+ntest,2)'));

yhat=cellfun(@(a,b) a'*b,w_d,X_test,'un',0);
rmse_d=cellfun(@(x) sqrt(mean(mean((ytest-x).^2,2))),yhat,'un',1);
display(rmse_d,'testing error E and I');

%% save result?

if saveres==1

    savefile='result/linear_regression/';
    savename=['rmse_w_',namep];
    save([savefile,savename],'rmse_d','rmse_train','w_d','ptr');
end

%% show figure?

if showfig==1
    figure()
    hold on
    for p=1:2
        histogram(w_d{p}(:))
    end
    hold off
end