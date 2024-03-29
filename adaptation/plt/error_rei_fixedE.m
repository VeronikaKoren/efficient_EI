
clear all
close all

savefig=0; 

addpath('/Users/vkoren/ei_net/result/adaptation/')
savefile='/Users/vkoren/ei_net/figure/adaptation/';
%%
loadname='local_2d_measures';
load(loadname)
figname='error_rei_fixedE';

fs=16;
lw=1.5;
ms=5;
lwa=1;
pos_vec=[0,0,10,8];
green=[0.2,0.7,0];
gray=[0.5,0.5,0.5];

%%
idx=find(variable==10);                 % adaptation regime only
vec=idx:length(variable);           

g=0.5;                                  % weighting ofthe RMSE of E andI cell type
error=g*rms(vec,vec,1)+(1-g)*rms(vec,vec,2); % equally weighted coding error
rei=abs(r_ei(vec,vec)); 

n=size(error,1);
zvar=zeros(n,n);
err=zeros(n,n);
r=zeros(n,1);

for g=1:n
    err(g,:)=error(g,:)./max(error(g,:));
    zvar(g,:)=rei(g,:);
    r(g)=corr(err(g,:)',zvar(g,:)');
end

meanr=nanmean(r);
display(meanr,'average correlation coefficient')
roundedr=round(meanr*100)/100; % to 2 decimals

%%
xt=0:0.5:1;
yt=0:0.2:0.4;
d=abs(min(min(zvar))-max(max(zvar)))/7;

gvec=2:n;
%gvec=[1,11,16,21,23];

tau_f_fixed=variable(idx-1+gvec);
usemap=parula;
vec_col=1:floor(size(usemap,1)/n):size(usemap,1);
colmap=usemap(vec_col,:);

H=figure('name',figname);
hold on
for k=1:2:length(gvec)-5
    g=gvec(k);
    h=plot(err(g,:),zvar(g,:),'v','markersize',ms,'color',colmap(g,:));
    plot(err(g,:),zvar(g,:),'--','color',gray);
end
for k=1:5:length(gvec)-5
    g=gvec(k);
    text(0.02,0.75-(k-1)*0.03,['\tau_f^E=',sprintf('%1.0i',tau_f_fixed(g))],'units','normalized','color',colmap(g,:),'fontsize',fs-2)
end
hold off
ylim([0.1,0.5])
xlim([-0.2,1.03])
xlabel('encoding error (normalized)','fontsize',fs)
ylabel('correlation coeff. in I','fontsize',fs)

text(0.3,0.3,['$\langle r \rangle = - $',sprintf('%0.2f',abs(roundedr))],'interpreter','latex','units','normalized','color','k','fontsize',fs)

set(gca,'XTick',xt)
set(gca,'XTickLabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTickLabel',yt,'fontsize',fs)

text(0.05,0.95,'instantaneous balance','color',gray,'units','normalized','fontsize',fs)
%text(0.05,0.05,'weak temporal balance','color',gray,'units','normalized','fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
%{
figure()
surf(zvar')
axis xy
xlabel('\tau_f^E')
ylabel('\tau_f^I')
zlabel('corr. coeff')
%}