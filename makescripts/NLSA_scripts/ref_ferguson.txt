function [a, logSumWij] = ferguson(D, logEps, a0, nS, nN, plotFerg)
% D: Distance matrix
% logEps: range of \epsilon values to try
% nS: number of snapshots as in dataY_nS*_nN*_sym.mat (just for the plot)
% nN: number of nearest-neighbors as in dataY_nS*_nN*_sym.mat (for the plot)
% a0: a vector of four random numbers
% plotFerg: 1 to plot the result, 0 otherwise
%
% Example of how to run this code: 
% - load dataY_nS*_nN*_sym.mat
% - logEps = [-20:0.2:40];
% - ferguson(sqrt(yVal),logEps,1*(rand(4,1)-.5),nS,nN,1);
%
% Notice: First run of this function may not converge to the right fit. If
% so, repeat until the fit (of the green curve to the blue curve) happens.
% Copyright (c) Ourmazd Lab, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(0,'DefaultAxesFontSize',20);
set(0,'DefaultLineLineWidth', 2);
set(0,'defaultfigurecolor','w')

% Range of values to try
logSumWij = zeros(1,length(logEps)); % Initialization

for k = 1:length(logEps)
    eps = exp(logEps(k));
    Wij = exp(-(D.^2)/(2*eps));    % See Coifman 2008
    %A_ij = sparse(A_ij);
    logSumWij(k) = log(sum(Wij(:)));
end

% curve fitting of a tanh()
[a, resnorm] = lsqcurvefit(@fun, a0, logEps, logSumWij);

 plot_Ferguson = plotFerg;
if plot_Ferguson
 figure;
 plot(logEps, logSumWij,'bo-'), hold on, axis tight
 xlabel('ln \epsilon','fontsize',18)
 ylabel('ln \Sigma W_{ij}','fontsize',18)
 ylim([min(logSumWij)-0.1,max(logSumWij)+0.1]);

 x = logEps;
 plot(x,a(4)+a(3)*tanh(a(1)*x+a(2)),'green');
 text(-a(2)/a(1),a(4),sprintf('\\leftarrow ln \\epsilon = %7.4f',-a(2)/a(1)),...
                               'HorizontalAlignment','left','fontsize',16);
 plot(x,a(4)+a(1)*a(3)*(x+a(2)/a(1)),'red');
 set(gca,'linewidth',2)
%hold off;
% % %
% %************************************************************************
% %
 title('\fontsize{18}{\color{black}{Ferguson plot}}');
 xx=min(logEps)+2;
 yy=max(logSumWij);
 
 text(xx,yy-1,sprintf('\\sigma = %3.2e',sqrt(2*exp(-a(2)/a(1)))),'fontsize',16);
 text(xx,yy-1.5,sprintf('nS = %6d',nS),'fontsize',16);
 text(xx,yy-2,sprintf('nN = %5d',nN),'fontsize',16);
 text(xx,yy-2.5,sprintf('Dim. = %3.2f',2*a(1)*a(3)),'fontsize',16);
% % 
% %************************************************************************
end

fprintf('Dimension = %f\n', 2*a(1)*a(3));
fprintf('logEps_opt = %f\n', -a(2)/a(1));
fprintf('sigma_opt = %f\n', sqrt(2*exp(-a(2)/a(1))));

end
  function F = fun(aa, xx)
        F = aa(4) + aa(3)*tanh(aa(1)*xx+aa(2));
  end
  
%EOF