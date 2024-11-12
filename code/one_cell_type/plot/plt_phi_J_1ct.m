
% plots the synaptic strength vs. the similarity of weights
clear all
close all
clc

addpath([cd,'/function/'])

savefig=1;
savefile=['/Users/vkoren/ei_net/figure/weights_J/'];

%% parameters

N=400;                                 % number of neurons 
M=3;                                   % number of input variables     
a=1;                                   % unit constant

%% synaptic conectivity matrix

W_ran=randn(M,N);

norm=(sum(W_ran.^2,1)).^0.5;                                        % normalization of weights with the the number of inputs
norm_mat=(norm'*ones(1,M))';
W=W_ran./norm_mat;                                                  % weight matrix  

J=-(W'*W- diag(diag(W'*W))).*a;                                                  % connectivity matrix

%% tuning similarity

phi=W'*W; % vectors are normalized, so no need to divide with the norm 

%{
% long way to compute cosine similarity
phi=zeros(N^2,1);
idx=0;
for ii=1:N
    for jj=1:N
        idx=idx+1
        phi(idx)=(W(:,ii)'*W(:,jj))./(sqrt(sum(W(:,ii).^2))*sqrt(sum(W(:,jj).^2)));
    end
end
%}
%% plot
fs=14;
pos_vec=[0,0,7.5,7];

xt=-1:1:1;
yt=[-1:1:1].*a;

figname='phi_J_1ct';
H=figure('name',figname);
plot(phi(:),J(:),'.','color','k','markersize',3)
line([-1,1],[0 0],'LineStyle','--')
box off
%title('one cell type')
ylim([-1,1].*a)

set(gca,'YTick',yt,'fontsize',fs)
set(gca,'XTick',xt,'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.1 op(3)-0.05 op(4)-0.1]); % OuterPosition = [left bottom width height]
xlabel ('tuning similarity','fontsize',fs)
ylabel ('synaptic strength [mV]','fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

