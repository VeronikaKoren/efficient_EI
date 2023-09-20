
% plots the synaptic strength vs. the similarity of weights
clear all
close all
clc

addpath([cd,'/code/function/'])

savefig=0;
savefile=[cd,'/figure/weights_J/'];

%% synaptic connectivity

N=400;                                 % number of neurons 
M=3;                                   % number of input variables     

q=4;
d=3;
a=0.3;                                  % unit constant

[w,J] = w_fun(M,N,q,d);

J(1)=[];  % remove E-E (not connected)
J{1}=J{1} - diag(diag(J{1})); % remove the diagonal from I-I (as it is included in the reset)
%%
J=J([2,1,3]);  % change order

J_units=cellfun(@(x) x.*a,J,'un',0);
mean_connectivity=cellfun(@(x) mean(mean(x)),J_units,'un',0)

%% tuning similarity

weights1={w{2},w{2},w{1}};
weights2={w{1},w{2},w{2}};

phi_all=cell(3,1);
for k=1:3

    Wpost=weights1{k};
    Wpre=weights2{k};

    Npost=size(Wpost,2);
    Npre=size(Wpre,2);
    
    phi=zeros(Npost*Npre,1);
    idx=0;
    for ii=1:Npost
        for jj=1:Npre
            idx=idx+1;
            phi(idx)=(Wpost(:,ii)'*Wpre(:,jj))./(sqrt(sum(Wpost(:,ii).^2))*sqrt(sum(Wpre(:,jj).^2))); % cosine similarity
        end
    end

    phi_all{k}=phi;

end

max_phi=cellfun(@(x) max(x), phi_all,'un',1); % maximal similarity
display(max_phi,'maximal similarity');

%% plot all cases

xt=-1:1:1;
yt={[0,0.5],[0,1.5],[0,0.5]};
pos_vec=[0,0,6,14];
ntype={'E to I','I to I','I to E'};

figname='phi_J';
H=figure('name',figname);
for ii=1:3
    
    
    x=phi_all{ii};
    y=(J_units{ii})';
    d=max(y(:))/10;

    subplot(3,1,ii)
    plot(x,y(:),'.','color','k','markersize',3)
    box off
    title(ntype{ii})
    
    axis([-1,1,min(J_units{ii}(:))-d,max(J_units{ii}(:))+d])
    set(gca,'YTick',yt{ii})
    set(gca,'XTick',xt)
    if ii==3
        set(gca,'XTickLabel',xt)
    else
        set(gca,'XTickLabel',[])
    end
    
    %set(gca,'LineWidth',lwa,'TickLength',[tl tl]);
    set(gca,'TickDir','out');

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.07 op(2) op(3)-0.06 op(4)]); % OuterPosition = [left bottom width height]
    
end

axes
h1 = xlabel ('tuning similarity','units','normalized','Position',[0.5,-0.05,0]);
h2 = ylabel ('synaptic strength [mV]','units','normalized','Position',[-0.07,0.5,0]);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%% %% plot distribution of synaptic weights
%{
pos_vec=[0,0,7,6];

ii=1;
maxy=max(C{ii}(:));
delta=maxy*0.1;

xt=-1:0.5:1;
yt=0:0.5:1;
figname='connectivity_tuning';

H=figure('name',figname);

plot(angle,C{ii}(:),'.','color','k')
box off
%xlim([-maxy-delta, maxy])
%ylim([0-delta,maxy])

%set(gca,'XTick',xt)
%set(gca,'XTickLabel',xt,'fontsize',fs)
%set(gca,'YTick',yt)
%set(gca,'YTickLabel',yt,'fontsize',fs)
grid on
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.1 op(3)-0.05 op(4)-0.1]); % OuterPosition = [left bottom width height]

axes
h1 = xlabel ('tuning similarity','units','normalized','Position',[0.5,-0.02,0]);
h2 = ylabel ('synaptic strength','units','normalized','Position',[-0.07,0.5,0]);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%}