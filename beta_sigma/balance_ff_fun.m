function [r,rcurr] = balance_ff_fun(I1,I2,dt)

% r is the measure of temporal correlation of currents coming to single I neurons, averaged across neurons 
% mean_ei is the mean E and I current

%% convolution of currents with an exponential kernel (synaptic kernel, to model PSC)

n=size(I2,1);
T=size(I2,2);

L=1/dt;                                                     % length of the kernel                                  
support=0:L;                                                % support
lambda_syn=0.1;                                             % synaptic time constant (timestep units)                                                                          % time constant
kernel=exp(-lambda_syn.*support);
nkernel=kernel./sum(kernel);

%% convolution

curr1=I1;
curr2=zeros(n,T);
for ii=1:n
    curr2(ii,:)=conv(I2(ii,:),nkernel,'same');
end

%% temporal correlation of E-I currents

rcurr=zeros(n,1);                                 % correlation of E and I currents in single neurons
for ii=1:n
    rcurr(ii)=corr(curr1(ii,:)',curr2(ii,:)');
end


r=nanmean(rcurr);

end