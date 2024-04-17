function [xhat,y,r] = network_1pop_fun(N,s,dt,tau,mu,nu,sigmav)

%% 
M=size(s,1);
lambda=1/tau;
T=size(s,2);
%% weights

W_ran=randn(M,N);
%rng(1)                                                             % to keep the same weights from one trial to another
%W_ran=sign(randn(M,N));                                            % for binary weights

norm=(sum(W_ran.^2,1)).^0.5;                                        % normalization of weights with the the number of inputs
norm_mat=(norm'*ones(1,M))';
W=W_ran./norm_mat;                                                  % weight matrix  
Id=eye(N,N);
omega=W'*W;

C=-(omega)-(mu*Id);                                                  % connectivity matrix
thres=diag(W'*W)/2+mu/2+nu/2;                                       % firing threshold

%% simulation shortcuts

leak_prefactor=(1-lambda*dt);
ff=W'*s*dt;
D=sigmav*sqrt(2*dt/tau);
noise=D*randn(N,T);

%%
V=zeros(N,T);
y=zeros(N,T);
r=zeros(N,T);

xhat=zeros(M,T);

%rng('shuffle')
V(:,1)=-3+randn(N,1);  % initialization with random membrane potentials

for t=1:T-1
     
    %V(:,t+1)=(1-lambda*dt)*V(:,t)+W'*s(:,t)*dt + C*y(:,t) + noise(:,t);
    V(:,t+1)=leak_prefactor.*V(:,t)+ff(:,t) + C*y(:,t) + noise(:,t);
    
    activation=V(:,t+1)>thres; 
    if sum(activation)>0
        y(:,t+1)=activation;
    end
    
    r(:,t+1)=leak_prefactor*r(:,t)+y(:,t+1);               
    xhat(:,t+1)=leak_prefactor*xhat(:,t)+W*y(:,t+1);     
    
end
%%

end

