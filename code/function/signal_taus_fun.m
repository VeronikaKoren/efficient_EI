function [s,x]=signal_taus_fun(tau_s,sigma_s,tau_x,M,nsec,dt)

%%

lambda=1/tau_x;
lambda_s=1./tau_s;
T=1000*nsec*(1/dt);
%sigma_s=2;

D=(sigma_s*sqrt((2*dt).*lambda_s));

s=zeros(M,T);
%rng(1);
% external input is an O-U process
for t=1:T-1
    s(:,t+1)=(1-lambda_s*dt).*s(:,t)+ D.*randn(M,1);
end

%% signal is the leaky integration of the external input

x=zeros(M,T);
for t=1:T-1
    x(:,t+1)=(1-lambda*dt)*x(:,t)+s(:,t)*dt;  
end
%%

%%