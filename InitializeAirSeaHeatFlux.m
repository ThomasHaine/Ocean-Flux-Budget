function tmp = InitializeAirSeaHeatFlux(DataParams)

% Air/sea heat flux.
% Could split these into different components, like SW, LW, sensible
% fluxes.
tmp.type       = 'non-advective' ;
tmp.area       = DataParams.CtrlVolArea ;      % Surface area of control volume [m^2]
tmp.name       = "Air/sea heat exchange" ;     % 
tmp.flux_mean  = 100e12 ;                      % Air/sea heat flux mean value [W]. See H21 and Tetal12.  
tmp.flux_std   = 2e12 ;                        % Air/sea heat flux standard deviation [W].
tmp.flux_Delta = 0e12 ;                        % Air/sea heat flux change over timeseries [W].
fluxes         = ar1(DataParams.N,DataParams.c,DataParams.phi,tmp.flux_std) ;
fluxes         = fluxes - mean(fluxes) + tmp.flux_mean + linspace(-tmp.flux_Delta/2,tmp.flux_Delta/2,DataParams.N)' ;
tmp.fluxes     = fluxes ;

end