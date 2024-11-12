function [dp] = dot_prod_fun(w)

%%
dp=cell(2,1);           % dot product of weights
for k=1:2
    
    A=w{k}'*w{k};
    dp{k} =nonzeros(tril(A-diag(diag(A))));
    
end

end
%%

%{
elseif k>=3
    if k==3
        A=w{1}'*w{2};
    else
        A=w{2}'*w{1};
    end
    At=A;
    dp{k} =At(:);
end
         
%}


