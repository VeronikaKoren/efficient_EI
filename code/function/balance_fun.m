function [r,rcurr] = balance_fun(ce,ci,dt)

% r is the measure of temporal correlation of currents coming to single I neurons, averaged across neurons 
% mean_ei is the mean E and I current

%% convolution of currents with an exponential kernel (synaptic kernel, to model PSC)

Ni=size(ci,1);
T=size(ci,2);

L=1/dt;                                                     % length of the kernel                                  
support=0:L;                                                % support
lambda_syn=0.1;                                             % synaptic time constant (timestep units)                                                                          % time constant
kernel=exp(-lambda_syn.*support);
nkernel=kernel./sum(kernel);

%% convolution

Ie=zeros(Ni,T);
Ii=zeros(Ni,T);
for ii=1:Ni
    Ie(ii,:)=conv(ce(ii,:),nkernel,'same');
    Ii(ii,:)=conv(ci(ii,:),nkernel,'same');
end

%% temporal correlation of E-I currents

rcurr=zeros(Ni,1);                                 % correlation of E and I currents in single neurons
for ii=1:Ni
    rcurr(ii)=corr(Ie(ii,:)',Ii(ii,:)');
end

r=nanmean(rcurr);


end

