function [idx_d_sorted,idx_s_sorted,phi_vec] = tuning_similarity_idx(w1,cn)

%%
% compute dot product of weight vectors and gives the index of neurons with
% similar and with dissimilar weight to a selected neuron


phi=w1'*w1;
phi_vec=phi(cn,:);
phi_vec(cn)=NaN;

%%

idx_d=find(phi_vec<0);
n1=length(idx_d);
%idx_s=find(Avec>0);
%n2=length(idx_s)

%%
[~,idx_sorted]=sort(phi_vec,'ascend','MissingPlacement','first');

idx_d_sorted=idx_sorted(2:n1+1);
idx_s_sorted=idx_sorted(n1+2:end);
%%

%{
savefig=0
figname='tuning_similarity_props';
pos_vec=[0,0,36,9];
xt=-1:1;

H=figure('name',figname)

subplot(1,3,1)
imagesc(1:N,1:N,phi',[-1,1])
axis square
axis xy

title('pair-wise tuning similarity')
ylabel('neuron index')
xlabel('neuron index')
colormap jet
cb=colorbar;
set(cb,'XTick',xt)


subplot(1,3,2)
hold on
plot(1:N,sort(phi_vec))
plot(2:n1+1,phi_vec(idx_d_sorted),'bx')
plot(n1+2:N,phi_vec(idx_s_sorted),'rx')
hold off
set(gca,'XTick',[1,200,400])
set(gca,'YTick',xt)
title('sorted tuning simil. to target')
ylabel('tuning similarity')
xlabel('neuron index (sorted)')

subplot(1,3,3)
histogram(phi_vec,20,'FaceColor',[0.7,0.7,0.7])
title('histogram of tuning simil. to target')
xlabel('tuning similarity')
ylabel('number of neurons')
set(gca,'XTick',xt)
box off

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    savefile=[cd,'/figure/perturbation/'];
    print(H,[savefile,figname],'-dpng','-r300');
end

%}

end
%%
