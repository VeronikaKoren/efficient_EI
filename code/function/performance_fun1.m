function [rmse,kappa] = performance_fun1(x,xhat,f)

%% root mean squared error

rmse=sqrt(mean(mean((x-xhat).^2,2))); % mean across dimensions and across time (per dt)

%% square root of the cost on spiking

kappa=sqrt(mean(sum(f.^2,1)));    

end
