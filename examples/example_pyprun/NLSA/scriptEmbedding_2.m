% scriptEmbedding
%
% copyright (c) Ourmazd Lab 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 param.env1=getenv('EPHEMERAL');
 nS         = 115031;   % Number of samples
 nEigs      = 4;        % Number of eigenfunctions to compute
 %nEigs      = 2;
 nA         = 0;        % Autotuning parameter 
 nN         = 15000;     % Number of nearest neighbors
 nNA        = 0;        % No. of nearest neighbors used for autotuning
 %sigma      = 1420.0;     % Gaussian Kernel width (=1 for autotuning)
 sigma      = 0.29;
 alpha      = 1;        % Kernel normalization (=1 for Laplace Beltrami)
 
ifEmbed    = true;

mkdir ~/pyp_run11/dataPYP/dataPsi
mkdir ~/pyp_run11/dataPYP/dataYA
addpath( './Dimitris', '~/pyp_run11/dataPYP/dataPsi', ...
         '~/pyp_run11/dataPYP/dataYA' );

if ifEmbed

    logfileEmbed = [ '~/pyp_run11/dataPYP/dataPsi/dataPsi', ...
                      '_nS',     int2str( nS ), ...
		              '_nN',     int2str( nN ),  ...
	                  '_nA',    int2str( nA ), ...
		              '_sigma', num2str( sigma, '%1.2E' ), ...
		              '_nEigs', int2str( nEigs ), ...
                      '_embed.log' ];

    logfileLaplacian = [ '~/pyp_run11/dataPYP/dataPsi/dataPsi', ...
                          '_nS',     int2str( nS ), ...fig
		                  '_nN',     int2str( nN ),  ...
	                      '_nA',    int2str( nA ), ...
			              '_sigma', num2str( sigma, '%1.2E' ), ...
		                  '_nEigs', int2str( nEigs ), ...
		                  '_laplacian.log' ];

    
    fileNameDist = [ './test_results/dataY', ...
                         '_nS',    int2str( nS ), ...
                         '_nN',    int2str( nN ),  ...
                         '_sym.mat' ];
    if nA > 0

        fileNameTune = [ '~/pyp_run11/dataPYP/dataYA/dataYA', ...
                         '_nS', int2str( nS ), ...
                         '_nN',    int2str( nNA ),  ...
                         '_nA',    int2str( nA ), ...
                         '.mat' ];
        load( fileNameTune, 'yA' );
        yA = sqrt( yA );

        [ lambda, v ] = sembedding_autotune( fileNameDist, nS, ... 
                         'sigma', yA, ...
                         'alpha', alpha, ...
                         'nEigs', nEigs, ...
		        		 'laplacianLogfile', logfileLaplacian, ...
					     'logfile', logfileEmbed );
    else


        [ lambda, v ] = sembedding( fileNameDist, nS, ... 
                                    'sigma', sigma, ...
                                    'alpha', alpha, ...
                                    'nEigs', nEigs );

    end

    psi = v( 1 : end, 2 : nEigs + 1 ) ...
        ./ repmat( v( 1 : end, 1 ), 1, nEigs );
    
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    % the Riemannian measure. 
    mu = v( 1 : end, 1 ) ;
    mu = mu.*mu; % note: sum(mu)=1
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    fileName = [ '~/pyp_run11/dataPYP/dataPsi/dataPsi', ...
                 '_nS',    int2str( nS ), ...
                 '_nN',    int2str( nN ),  ...
                 '_nA',    int2str( nA ), ...
                 '_sigma', num2str( sigma, '%1.2E' ), ...
                 '_nEigs', int2str( nEigs ), '.mat' ];
    save( fileName, 'psi', 'lambda' , 'mu' );

end

%EOF