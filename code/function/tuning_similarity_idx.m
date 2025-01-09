function [idx_d_sorted,idx_s_sorted,phi_vec] = tuning_similarity_idx(w1,cn)

%%
% compute dot product of weight vectors and gives the index of neurons with
% similar and with dissimilar weight to a selected neuron

%w1=w{1}
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
magenta=[0.8,0,0.7,0.6];
gray=[0.5,0.5,0.5];
col={gray,magenta};   

savefig=1;
figname='tuning_similarity_props';
pos_vec=[0,0,46,9];
xt=-1:1;
fs=14;

namepop={'different tuning','similar tuning'};

H=figure('name',figname)

subplot(1,4,1)
imagesc(1:N,1:N,tril(phi)-eye(N,N),[-1,1])
axis square
axis xy

set(gca,'Xtick',[100,300],'fontsize',fs)
set(gca,'Ytick',[100,300],'fontsize',fs)

title('pair-wise tuning similarity','fontsize',fs)
ylabel('neuron index E','fontsize',fs)
xlabel('neuron index E','fontsize',fs)
colormap pink
cb=colorbar;
set(cb,'XTick',xt,'fontsize',fs)
set(cb,'YTick',xt,'fontsize',fs)

subplot(1,4,2)
histogram(nonzeros(tril(phi-eye(N,N))),25,'FaceColor',[0.6,0.6,0.6],'FaceAlpha',0.3)
xlabel('tuning similarity','fontsize',fs)
ylabel('number of neurons','fontsize',fs)
set(gca,'XTick',xt,'fontsize',fs)
set(gca,'YTick',[3000],'fontsize',fs)
box off
title('histogram tuning simil. (all)','fontsize',fs)

subplot(1,4,3)
hold on
plot(1:N,sort(phi_vec))
plot(2:n1+1,phi_vec(idx_d_sorted),'x','color',col{1})
plot(n1+2:N,phi_vec(idx_s_sorted),'x','color',col{2})
hold off

for ii=1:2
    text(0.04,0.75+(ii-1)*0.13,namepop{ii},'units','normalized','color',col{ii},'fontsize',fs)
end

set(gca,'XTick',[1,200,400])
set(gca,'YTick',xt)
title('sorted tuning simil. to target','fontsize',fs)
ylabel('tuning similarity','fontsize',fs)
xlabel('neuron index E (sorted)','fontsize',fs)

subplot(1,4,4)
histogram(phi_vec,25,'FaceColor',[0.6,0.6,0.6],'FaceAlpha',0.3)
title('histogram tuning simil. to target')
xlabel('tuning similarity','fontsize',fs)
ylabel('number of neurons','fontsize',fs)
set(gca,'XTick',xt)
box off

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    savefile=[cd,'/figure/lateral/'];
    print(H,[savefile,figname],'-dpng','-r300');
end
%}

end
%%
