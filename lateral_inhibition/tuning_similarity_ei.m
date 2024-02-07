function [idx_di,idx_si,phi_veci] = tuning_similarity_ei(we,wi,cn)

%%
% compute dot product of weight vectors and gives the index of neurons with
% similar and with dissimilar weight to a selected neuron
maxnorm=max(max(we'*wi));

phi=(we'*wi)./maxnorm;
phi_veci=phi(cn,:);
phi_veci(cn)=NaN;

%%

idx_d=find(phi_veci<0);
n1=length(idx_d);
%idx_s=find(Avec>0);
%n2=length(idx_s)

%%
[~,idx_sorted]=sort(phi_veci,'ascend','MissingPlacement','first');

idx_di=idx_sorted(2:n1+1);
idx_si=idx_sorted(n1+2:end);
%
%{
n=length(phi_veci);

savefig=0;
figname='tuning_similarity_props';
pos_vec=[0,0,36,9];
xt=-1:1;

H=figure('name',figname);

subplot(1,3,1)
imagesc(1:size(phi,1),1:size(phi,2),phi',[-1,1])
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
plot(1:n,sort(phi_veci))
plot(2:n1+1,phi_veci(idx_di),'bx')
plot(n1+2:n,phi_veci(idx_si),'rx')
hold off
set(gca,'XTick',[1,n/2,n])
set(gca,'YTick',xt)
title('sorted tuning simil. to target')
ylabel('tuning similarity')
xlabel('neuron index (sorted)')

subplot(1,3,3)
histogram(phi_veci,20,'FaceColor',[0.7,0.7,0.7])
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
