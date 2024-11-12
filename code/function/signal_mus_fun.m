function [s,x]=signal_mus_fun(tau_s,sigma_s,tau_x,M,nsec,dt,mu_s)

% for imbalanced stimuli (with mean away from zero)
lambda=1/tau_x;
lambda_s=1/tau_s;
T=1000*nsec*(1/dt);

D=sigma_s*sqrt((2*dt)/tau_s);
%% stimulus features

s=single(zeros(M,T));
for t=1:T-1
    s(:,t+1)=(1-lambda_s*dt)*s(:,t)+(mu_s/tau_s).*dt+ D*randn(M,1);
end

% target signal 
x=single(zeros(M,T));
for t=1:T-1
    x(:,t+1)=(1-lambda*dt)*x(:,t)+s(:,t)*dt;  
end

end



