function [xhat,f,r] = network_1pop_fun(N,s,dt,tau,beta,nu,sigmav)

%% 
M=size(s,1);
lambda=1/tau;
T=size(s,2);

%% tuning parameters and connectivity weights

W_ran=randn(M,N);

norm=(sum(W_ran.^2,1)).^0.5;                                        % normalization of weights with the the number of inputs
norm_mat=(norm'*ones(1,M))';
W=W_ran./norm_mat;                                                  % weight matrix  
Id=eye(N,N);

omega=W'*W;

J=-(omega)-(beta*Id);                                                  % connectivity matrix
thres=diag(W'*W)/2+beta/2+nu/2;                                       % firing threshold

%% for faster simulation

leak_prefactor=(1-lambda*dt);
ff=W'*s*dt;
D=sigmav*sqrt(2*dt/tau);
noise=D*randn(N,T);

%%
V=zeros(N,T);
f=zeros(N,T);
r=zeros(N,T);
xhat=zeros(M,T);

V(:,1)=-3+randn(N,1);  % initialization with randomly distributed membrane potentials
for t=1:T-1
     
  
    V(:,t+1)=leak_prefactor.*V(:,t)+ff(:,t) + J*f(:,t) + noise(:,t);
    
    activation=V(:,t+1)>thres; 
    if sum(activation)>0
        f(:,t+1)=activation;
    end
    
    r(:,t+1)=leak_prefactor*r(:,t)+f(:,t+1);               
    xhat(:,t+1)=leak_prefactor*xhat(:,t)+W*f(:,t+1);     
    
end
%%

end

