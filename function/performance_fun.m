function [rmse] = performance_fun(x,xhat_e,xhat_i)

%% root mean squared error


rmse_e=sqrt(mean(mean((x-xhat_e).^2,2))); % mean across dimensions and across time (per dt)
rmse_i=sqrt(mean(mean((xhat_e-xhat_i).^2,2)));

rmse=cat(1,rmse_e,rmse_i);


end
