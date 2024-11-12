function [w,J] = w_structure_fun(M,N,q,d,type,f)

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
    
    proj=w1'*w2;                                            % projection of weights + white noise
                                              
    J{ii}=(proj.*(sign(proj)==1));                          % keep only positive sign (rectification)
    
end

%% noise


if type==2 %% full permutation
    
    if f==5         % permute elements in all J matrices
        for ii=2:4
            Jmat=J{ii};
            ns=size(Jmat);
            Jvec=Jmat(:);                       % make a vector
            Jperm=Jvec(randperm(length(Jvec))); % permute the order
            J{ii}=reshape(Jperm,ns(1),ns(2));    % put back in the original size of the matrix
        end
    else                      % permute a specific C matrix 
        Jmat=J{f};
        ns=size(Jmat);
        Jvec=Jmat(:);                       % make a vector
        Jperm=Jvec(randperm(length(Jvec))); % permute the order
        J{f}=reshape(Jperm,ns(1),ns(2));    % put back in the original size of the matrix
    end
elseif type==3  % partial permutation
    if f==5     % permute all 
        for ii=2:4
            
            Jmat=J{ii};
            ns=size(Jmat);
            Jvec=Jmat(:);

            nz=find(Jvec>0);                 % index of non-zero elements (connected neurons)
            Jvec_short=Jvec(nz);             % vector of non-zero elements
            perm_order=randperm(length(nz)); % permute order of non-zero el.
            Jvec(nz)=Jvec_short(perm_order); % insert permuted values into the full vector
            J{ii}=reshape(Jvec,ns(1),ns(2));    % put back in the original size of the matrix

        end
    else         % permute one specific connecrivity matrix

        Jmat=J{f};
        ns=size(Jmat);
        Jvec=Jmat(:);

        nz=find(Jvec>0);                 % index of non-zero elements (connected neurons)
        Jvec_short=Jvec(nz);             % vector of non-zero elements
        perm_order=randperm(length(nz)); % permute order of non-zero el.
        Jvec(nz)=Jvec_short(perm_order); % insert permuted values into the full vector
        J{f}=reshape(Jvec,ns(1),ns(2));    % put back in the original size of the matrix

    end
    
end

