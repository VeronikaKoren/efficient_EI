
clear all
close all

savefig=0; 

addpath('/Users/vkoren/ei_net/result/adaptation/')
savefile='/Users/vkoren/ei_net/figure/adaptation/';
%%
loadname='local_2d_measures';
load(loadname)

figname='error_net_fixedI';

fs=15.5;
lw=1.5;
ms=5;
lwa=1;
pos_vec=[0,0,10,8];
green=[0.2,0.7,0];
gray=[0.5,0.5,0.5];

%%
idx=find(variable==10);             % adaptation regime only
vec=idx:length(variable);           

a=0.3;
g=0.5;                                  % weighting ofthe RMSE of E andI cell type
error=g*rms(vec,vec,1)+(1-g)*rms(vec,vec,2); % equally weighted coding error
net=a.*(mean_curr(vec,vec,1)+mean_curr(vec,vec,2)); % average net synaptic current in I neurons 

n=size(error,1);
zvar=zeros(n,n);
err=zeros(n,n);
r=zeros(n,1);

for g=1:n
    err(:,g)=error(g,:)./max(error(g,:));
    zvar(:,g)=net(:,g);
    r(g)=corr(err(:,g),zvar(:,g));
end

meanr=nanmean(r);
display(meanr,'average correlation coefficient')
roundedr=round(meanr*100)/100; % to 2 decimals

%%

xt=0:0.5:1;
yt=0:2:4;
d=abs(min(min(zvar))-max(max(zvar)))/7;

gvec=1:n;

tau_f_fixed=variable(idx-1+gvec);
usemap=parula;
vec_col=1:floor(size(usemap,1)/n):size(usemap,1);
colmap=usemap(vec_col,:);

H=figure('name',figname);
hold on
for k=3:length(gvec)-5
    g=gvec(k);
    h=plot(err(:,g),zvar(:,g),'v','markersize',ms,'color',colmap(g,:));
    plot(err(:,g),zvar(:,g),'--','color',gray);
end
for k=3:5:length(gvec)-5
    g=gvec(k);
    text(0.03,0.79-(k-1)*0.03,['\tau_r^I=',sprintf('%1.0i',tau_f_fixed(g))],'units','normalized','color',colmap(g,:),'fontsize',fs-2)
end
hold off
%xlim([0,1.02])
ylim([-1,4.5])

xlabel('encoding error (normalized)','fontsize',fs)
ylabel('net syn. input','fontsize',fs)

text(0.23,0.8,['$\langle r \rangle= - $',sprintf('%0.2f',abs(roundedr))],'interpreter','latex','units','normalized','color','k','fontsize',fs)

set(gca,'XTick',xt)
set(gca,'XTickLabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTickLabel',yt,'fontsize',fs)

text(0.1,0.95,'average imbalance','color',gray,'units','normalized','fontsize',fs)
%text(0.1,0.05,'stronger average balance','color',gray,'units','normalized','fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) 

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%
%{
xt=0:10:20;
xtl=variable(idx+xt);

figure()

surf(log(error))
set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl)
set(gca,'YTick',xt)
set(gca,'YTickLabel',xtl)
xlabel('\tau_f^E')
ylabel('\tau_f^I')
zlabel('error')
%%
figure()
surf(dvar)
%set(gca,'XTick',xt)
xlabel('\tau_f^E')
ylabel('\tau_f^I')
zlabel('net current')
set(gca,'XTick',xt)
set(gca,'XTickLabel',xtl)
set(gca,'YTick',xt)
set(gca,'YTickLabel',xtl)
%}