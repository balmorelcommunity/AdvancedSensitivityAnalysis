%% Sampling strategies: Stratified random (LHS) for Monte Carlo Simulation
%Code provided by Gurkan Sin during the course XXXX (August, 2016)
%Modified by Amalia Pizarro Alonso for the preparation of the report for
%the abovementioned course
%it is all above how you subsample from the k dimensional (continous) input space.
% Updated by Juan Gea-Bermudez (January, 2020)

clear all
clc
close all

%% Parameters range, as specified for the Global Sensitivity Analysis 
addpath('.\input\');
%Read relevant parameters to be used in montecarlo
input = readtable(".\input\input_montecarlo.csv");

% The name lp is the name you will have in legends, so write the name as
% you wish it to appear in Figures (use subscripts or superscripts for nicer names) 
lpMC=table2array(input(:,1))';

%Read the uncertainty range
%Lower limit (relevant for uniform distributions)
xlMC=table2array(input(:,3))';
%Upper limit (relevant for uniform distributions)
xuMC=table2array(input(:,4))';
%Mean value (relevant for normal and uniform distributions)
pMC=table2array(input(:,5))';
%Standard deviation (relevant for normal distributions)
sigmaMC=table2array(input(:,6))';

%Read which parameters have a normal distribution, and which ones a
%uniform one.
pmor_normal=strcmp(input.Distribution_type(:), 'normal');
pmor_unif=strcmp(input.Distribution_type(:), 'uniform');

%% Sampling method: Latin Hypercube sampling 
k=length(pMC);

%n. of sample points (N), please select how many Monte Carlo simulations you
%want to perform, based on the number of parameters you are considering and
%the the computational constraints.
N=300; 
X = lhs(N, k);

%% Now we will calculate the sample metdhology with real values
%From uniform distribution [0 1] to real values
Xnorm=X;
Xnorm(Xnorm==0)=0.01;
Xnorm(Xnorm==1)=0.99;

for i=1:N
  Xval(i,pmor_normal) =norminv(Xnorm(i,pmor_normal),pMC(pmor_normal),sigmaMC(pmor_normal));  
  Xval(i,pmor_unif) = xlMC(pmor_unif) + (xuMC(pmor_unif)-xlMC(pmor_unif)).*X(i,pmor_unif) ;
end

%save output
fl =strcat('./output/','LHS_Sampling_k',num2str(k),'_N',num2str(N),'.mat');
save(fl, 'Xval', 'X','N','xlMC','xuMC','k','lpMC','pMC','sigmaMC')

%% Plot of the results
%Note: Plotting the results can take quite some time, by default not
%activated

% figure(1)
% [h,ax,bax,P] = plotmatrix(X) ;
% set(ax,'FontSize',8)
% for i=1:k
% ylabel(ax(i,1),lpMC(i));
% xlabel(ax(k,i),lpMC(i));
% end
% title(['Latin Hypercube Sampling for k input ',num2str(k),' with sampling number N = ',num2str(N)])
% 
% figure(2)
% [h,ax,bax,P] = plotmatrix(Xval) ;
% set(ax,'FontSize',10)
% for i=1:k
% ylabel(ax(i,1),lpMC(i));
% xlabel(ax(k,i),lpMC(i));
% end
% title(['Latin Hypercube Sampling for k input ', num2str(k),' with sampling number  N = ',num2str(N),' and real values'])

%% Step 3. Perform the Monte Carlo simulations. 
% In this step, N model simulations are performed using the sampling
% matrix from the LHS (Xval) and the model outputs are recorded in a
% matrix form to be processed in the next step.
% As the model is written in Gams and this code in Matlab and both codes
% were kept separately, this step has been done independently in GAMS and
% the results of the simulation are mannually imported
% Amalia Pizarro Alonso (October, 2016)

