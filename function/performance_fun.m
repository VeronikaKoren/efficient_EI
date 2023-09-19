function [rmse,kappa] = performance_fun(x,xhat_e,xhat_i,re,ri)

%% root mean squared error


rmse_e=sqrt(mean(mean((x-xhat_e).^2,2))); % mean across dimensions and across time (per dt)
rmse_i=sqrt(mean(mean((xhat_e-xhat_i).^2,2)));

rmse=cat(1,rmse_e,rmse_i);

kappa_e=sqrt(mean(sum(re.^2,1)));    
kappa_i=sqrt(mean(sum(ri.^2,1)));

kappa=cat(1,kappa_e,kappa_i);


end
