
%% Morris screening method
% Refs: Morris, 1991 and Campolongo and Saltelli, 1997
% This script performs morris sampling of parameter space needed for the
% morris screening method.
%
% Gurkan Sin, PhD
% Updated DTU Chemical Engineering July 11 2015
% Adapted by Amalia Pizarro Alonso for using it in the energy systems model
% Balmorel
% Updated by Juan Gea Bermudez 

%% Parameters range
%Read how many paremeters and the names of the parameters whose
%uncertainty range you want to evaluate through Morris screening

addpath('.\input\');
input = readtable(".\input\input_morris.csv");

% The name lp is the name you will have in legends, so write the name as
% you wish it to appear in Figures (use subscripts or superscripts for nicer names)  

lp=table2array(input(:,1))';


%This parameter is not used, in this case but you could use it if you wish
%to set an uncertainty range in % from the reference value, rather an a lower and upper range
%inputunc=[0.25 0.10]; % expert input uncertainty indicates degree of uncertainty [0: Low , 1: High]
%k=length(pmor); % number of parameters
%xl= pmor .* (ones(1,k)-inputunc);
%xu= pmor .* (ones(1,k)+inputunc);

%Read the uncertainty range
%Lower limit (relevant for uniform distributions)
xl=table2array(input(:,3))';
%Upper limit (relevant for uniform distributions)
xu=table2array(input(:,4))';
%Mean value (relevant for normal and uniform distributions)
pmor=table2array(input(:,5))';
%Standard deviation (relevant for normal distributions)
sigma_pmor=table2array(input(:,6))';

%Read which parameters have a normal distribution, and which ones a
%uniform one.
pmor_normal=strcmp(input.Distribution_type(:), 'normal');
pmor_unif=strcmp(input.Distribution_type(:), 'uniform');


%% Morris sampling parameters
% You need to specify "p" and "r", depending on the number of simulations
% you wish to conduct (computational limitations), but also knowing the
% disadvantages from decreasing sampling scenarios.
k = length(lp) ; % no of parameters or factors
p = 50 ; % number of levels {4,6,8}
dt = p/(2*(p-1)) ; % perturbation factor .
r = 1000; % number of repetion for calculating the EEi, e.g. 4 - 15

%% Morris sampling will produce discrete uniform probabilities for each
% factor.
X = morris(p,dt,k,r);
Xmean = mean(X) ;

%% from uniform distribution [0 1] to real values
Xnorm=X;

Xnorm(Xnorm==0)=0.01;
Xnorm(Xnorm==1)=0.99;

for i=1:length(X)
  Xval(i,pmor_normal) =norminv(Xnorm(i,pmor_normal),pmor(pmor_normal),sigma_pmor(pmor_normal));  
  Xval(i,pmor_unif) = xl(pmor_unif) + (xu(pmor_unif)-xl(pmor_unif)).*X(i,pmor_unif) ;
end

%% Plot Morris sampling results for the visualization
%Note: it can take a long time to run this section (by default not
%activated

 figure(1)
 [h,ax,bax,P] = plotmatrix(X) ;
 set(ax,'FontSize',6)
 for i=1:k
 ylabel(ax(i,1),lp(i))
 xlabel(ax(k,i),lp(i))
 end
 title(['Morris Sampling with r=', num2str(r),', p=',num2str(p),' levels,',' and \Delta =',num2str(dt,'%5.2f'),': unit range'])
 
 figure(2)
 [h,ax,bax,P] = plotmatrix(Xval) ;
 set(ax,'FontSize',6)
 for i=1:k
 ylabel(ax(i,1),lp(i))
 xlabel(ax(k,i),lp(i))
 end
 title(['Morris Sampling with r=', num2str(r),', p=',num2str(p),' levels,',' and \Delta =',num2str(dt,'%5.2f'),': real values'])

