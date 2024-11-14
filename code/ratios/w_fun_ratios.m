function [w,J] = w_fun_dE(M,N,q,dI,dE)

%% weights

%format long

Ni=round(N/q);                            % ratio E to I neurons is q to 1
N_all=[N,Ni];
d_all=[dE,dI];

w=cell(2,1);
for ii=1:2
    
    w_ran=randn(M,N_all(ii));
    
    norm=(sum(w_ran.^2,1)).^0.5;      % normalization of weights with the the number of inputs
    norm_mat=(norm'*ones(1,M))';
    weight=w_ran./norm_mat;    
                          
    w{ii}=weight.*d_all(ii);
    
    %{
    w_ran=randn(M,N_all(ii)); % no normalization
    w{ii}=w_ran./M;
    %}
    
end

%% connectivity matrices

J=cell(4,1);

weights1={w{1},w{2},w{2},w{1}};
weights2={w{1},w{2},w{1},w{2}};

for ii=2:4
    
    w1=weights1{ii};
    w2=weights2{ii};
    
    proj=w1'*w2;                                            % projection of weights + white noise
                                              
    J{ii}=(proj.*(sign(proj)==1));                          % keep only positive sign
    
end

end


