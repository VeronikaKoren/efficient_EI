
% plots the synaptic strength vs tuning similarity of the optimal E-I network

clear
close all
clc

addpath([cd,'/code/function/'])

savefig=0;
savefile=pwd;

%% parameters

N=400;                                 % number of neurons 
M=3;                                   % number of input variables     

q=4;
d=3;

%%

[w,J] = w_fun(M,N,q,d);

J(1)=[];
J=J([2,1,3]);

mean_connectivity=cellfun(@(x) mean(mean(x)),J,'un',0);

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

%% plot

xt=-1:1:1;
delta=0.3;
yt={[0,2],[0,6],[0,0.5]};
pos_vec=[0,0,7,9];
ntype={'E to I','I to I','I to E'};

figname='phi_J';
fs=15;

H=figure('name',figname);
for ii=1:2
    
    delta=max(J{ii}(:))/10;
    y=(J{ii})';
    
    subplot(2,1,ii)
    plot(phi_all{ii},y(:),'.','color','k','markersize',5)
    box off
    title(ntype{ii},'fontsize',fs)
    
    axis([-1,1,-delta,max(J{ii}(:))])
    set(gca,'YTick',yt{ii})
    set(gca,'XTick',xt)
    if ii==2
        set(gca,'XTickLabel',xt,'fontsize',fs)
    else
        set(gca,'XTickLabel',[])
    end
    
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.07 op(2) op(3)-0.06 op(4)+0.04]); % OuterPosition = [left bottom width height]
    
end

axes
h1 = xlabel ('tuning similarity','units','normalized','Position',[0.5,-0.05,0],'fontsize',fs);
h2 = ylabel ('synaptic strength [mV]','units','normalized','Position',[-0.07,0.5,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

