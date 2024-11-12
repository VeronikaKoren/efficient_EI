function [CV] = cv_fun(y1e,y1i)

%% computes coefficient of variation of the spike train of single neurons
N=size(y1e,1);
Ni=size(y1i,1);

CV_all=zeros(N,1);  % E neurons
for ii=1:N
    st=find(y1e(ii,:));
    ISI=st(2:end)-st(1:end-1);
    CV_all(ii)=nanstd(ISI)./nanmean(ISI);
end

CV_alli=zeros(Ni,1); % I neurons
for ii=1:Ni
    st=find(y1i(ii,:));
    ISI=st(2:end)-st(1:end-1);
    CV_alli(ii)=nanstd(ISI)./nanmean(ISI);
end

CV=cat(1,nanmean(CV_all),nanmean(CV_alli)); % average across neurons


end

