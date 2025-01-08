function [dp] = dot_prod_fun(w)

%%
dp=cell(2,1);           % dot product of weights
for k=1:2
    
    A=w{k}'*w{k};
    dp{k} =nonzeros(tril(A-diag(diag(A))));
    
end

end


