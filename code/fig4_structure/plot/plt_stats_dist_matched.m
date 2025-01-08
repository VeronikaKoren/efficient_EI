%% plots metabolic cost for networks with and without connectivity structure
% with matched level of the net current

close all
clear 
clc

savefig=[0,0,0];
figname1='net_matched';
figname2='mc_matched';

namet={'structured','perm_full_all','perm_partial_all'};
addpath([cd,'/result/structure/']);
savefile=pwd;

rmse=cell(2,1);
mc=cell(2,1);
net=cell(2,1);
fr=cell(2,1);
r=cell(2,1);
CV=cell(2,1);

for typ=1:2
    loadname=['measures_matching_average_',namet{typ}];
    load(loadname,'kappa_tr','net_tr','fr_tr','r_tr','CV_tr','rmse_tr');

    net{typ}=net_tr;
    r{typ}=abs(r_tr);

    mc{typ}=kappa_tr;
    rmse{typ}=rmse_tr;
    
    fr{typ}=fr_tr;
    CV{typ}=CV_tr;

end

%% fig. stuff

tit={'in Excitatory','in Inhibitory'};
ntr=size(net{1},1);
namex={'structured','shuffled'};
%pos_vec=[0,0,10,12];
fs=15;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};
gray=[0.2,0.2,0.2];

lwa=1;

%% compare the metabolic cost

mce=zeros(ntr,2);
mci=zeros(ntr,2);

re=zeros(ntr,2);
ri=zeros(ntr,2);
for ii=1:2
    
    mce(:,ii)=mc{ii}(:,1);
    mci(:,ii)=mc{ii}(:,2);

    re(:,ii)=r{ii}(:,1);
    ri(:,ii)=r{ii}(:,2);
end


%% plot net current

pos_vec=[0,0,8,8];

mnet=cellfun(@mean,net,'un',0);
mmat=cell2mat(mnet);

yt=-1:0.5:0;

H=figure('name',figname1);
bb=bar(mmat);
bb(1).FaceColor=red;
bb(2).FaceColor=blue;
for ii=1:2
    text(0.3,0.2-(ii-1)*0.1,tit{ii},'color',col{ii},'units','normalized','fontsize',fs)
end
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
ylim([-1.4,0])
set(gca,'XTick',[1,2])
set(gca,'XTickLabel',namex)
ylabel('net synaptic input [mV]')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size


if savefig(1)==1
    print(H,[savefile,figname1],'-dpng','-r300');
end
%}
%%
pos_vec=[0,0,8,12];

H=figure('name',figname2,'Position',pos_vec);
subplot(2,1,1)
h=boxplot(mce,'symbol','.','MedianStyle','target','color','m');
box off
set(h,{'linew'},{1.5})

set(gca,'XTickLabel',[])
set(gca,'YTick',[4,5],'fontsize',fs)
set(gca,'YTicklabel',[4,5 ])
title(tit{1},'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.01 op(3)-0.02 op(4)+0.01]);

subplot(2,1,2)
h=boxplot(mci,namex,'symbol','.','MedianStyle','target','color','m');
set(h,{'linew'},{1.5})
box off

set(gca,'YTick',[2.8,3.2])
set(gca,'YTicklabel',[2.8,3.2],'fontsize',fs)
title(tit{2},'fontsize',fs)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.01 op(3)-0.02 op(4)+0.01]);

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = ylabel ('metabolic cost (matched net input)','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(2)==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%%
