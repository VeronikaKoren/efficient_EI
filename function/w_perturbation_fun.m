function [w,J] = w_perturbation_fun(M,N,q,d,f)

%% weights

Ni=round(N/q);                            % ratio E to I neurons is q to 1
N_all=[N,Ni];
w=cell(2,1);

for ii=1:2
    
    w_ran=randn(M,N_all(ii)); 
    
    norm=(sum(w_ran.^2,1)).^0.5;      % normalization of weights with the the number of inputs
    norm_mat=(norm'*ones(1,M))';
    weight=w_ran./norm_mat;    
                          
    w{ii}=weight;
    
end

w{2}=w{2}.*d;

%% connectivity matrices

J=cell(4,1);

weights1={w{1},w{2},w{2},w{1}};
weights2={w{1},w{2},w{1},w{2}};

for ii=2:4
    
    w1=weights1{ii};
    w2=weights2{ii};
    
    proj=w1'*w2;                                            % dot product of weights 
                                              
    J{ii}=(proj.*(sign(proj)==1));                          % keep only positive sign (rectification)
    
end

%% perturbation with unstructured connectivity

for ii=2:4

    sigma_J=f*J{ii};                          % noise intensity is proportional to the connectivity weight (unconnected pairs get a 0)
    eta=randn(size(J{ii},1),size(J{ii},2));   % matrix of random numbers
    signmat=J{ii}>0;                          % positive part of eta  

    noise=sigma_J.*(eta.*signmat);
    J{ii}=J{ii}+noise;

end


