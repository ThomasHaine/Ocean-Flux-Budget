function tmp = InitializeDataParameters(N)
% Define data parameters.
tmp.N           = N ;                       % Number of entries in the timeseries
tmp.start_date  = datetime(1990,1,1) ;      % Default start date.
tmp.end_date    = datetime(2020,1,1) ;      % Default end date.
tmp.c           = 0.9 ;                     % Constant    parameter in AR(1) process
tmp.phi         = 0.8 ;                     % Persistence parameter in AR(1) process
tmp.p_ref       = 0.0 ;                     % Reference pressure [N/m^2]
tmp.massBalance = true ;                   % Default flag for overall mass balance, or not.
end