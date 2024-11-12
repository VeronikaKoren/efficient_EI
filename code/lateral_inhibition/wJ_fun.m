function [w,J] = wJ_fun(M,N,q,d)

%% weights

%format long

Ni=round(N/q);                            % ratio E to I neurons is q to 1
N_all=[N,Ni];
w=cell(2,1);

for ii=1:2
    
    w_ran=randn(M,N_all(ii));
    
    norm=(sum(w_ran.^2,1)).^0.5;      % normalization of weights with the the number of inputs
    norm_mat=(norm'*ones(1,M))';
    weight=w_ran./norm_mat;    
                          
    w{ii}=weight;
    
    %{
    w_ran=randn(M,N_all(ii)); % no normalization
    w{ii}=w_ran./M;
    %}
    
end
%%
w{2}=w{2}.*d;


%% connectivity matrices

J=cell(4,1);

weights1={w{1},w{2},w{2},w{1}};
weights2={w{1},w{2},w{1},w{2}};
p=[0.15,1,1,1];

for ii=1:4
    
    w1=weights1{ii};
    w2=weights2{ii};
    
    proj=w1'*w2;                                            % dot product of decoding vectors
    
    if ii==1
        np=numel(proj);
        k=round(np*2*p(ii));
        zeromat=cat(1,zeros(np-k,1),ones(k,1));
        zeromat=zeromat(randperm(np));
        mask=reshape(zeromat,size(proj,1),size(proj,2));
        proj=proj.*mask;
    end
     
    J{ii}=(proj.*(sign(proj)==1));                          % keep only positive sign
    
end


%% connection probability
%numel(nonzeros(J{1}))/N^2

end


