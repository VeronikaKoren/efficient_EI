
figname='connectivity_matrices';
savefig=0;

addpath([cd,'/function/'])
M=3;
N=400;
q=4;
d=3;

[w,J] = w_fun(M,N,q,d);
J(1)=[]; % E-E neurons are unconnected

idxo=[2,1,3];
a=0.3;  % unit constant
J=cellfun(@(x) x.*a,J,'UniformOutput',false);
%%

cmax=max(cellfun(@(x) max(max(x)),J,'UniformOutput',true));

titles={'E-I','I-I','I-E'};
pos_vec=[0,0,7,12];

H=figure('name',figname);
for ii=1:2
    subplot(2,1,ii)
    
    imagesc('CData',J{idxo(ii)},[0 cmax])
    %axis square
    colormap pink

    siz=size(J{idxo(ii)});
    title(titles{ii})
    axis([1 siz(2) 1 siz(1)])

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)-0.0 op(2)-0.02 op(3)-0.00 op(4)-0.00]);

    clb=colorbar;
    %.Position = clb.Position + [0.01,-0.025,.02,0.04];
    clb.FontSize=14;
    clb.Ticks=[0,1,2];
    
    set(gca,'XTick',[siz(2)/2,siz(2)])
    set(gca,'YTick',[siz(1)/2,siz(1)])

end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
cellfun(@(x) mean(mean(x)),J,'UNiformOutput',false)

