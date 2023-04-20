function tmp = InitializeAirSeaHeatFlux(DataParams)

% Air/sea heat flux.
% Could split these into different components
AirSeaHeatFlux.area         = DataParams.CtrlVolArea ;      % Surface area of control volume [m^2]
AirSeaHeatFlux.name         = "Air/sea heat exchange" ;     % 
AirSeaHeatFlux.flux_mean    = 100e12 ;                      % Air/sea heat flux mean value [W]. See H21 and Tetal12.  
AirSeaHeatFlux.flux_std     = 2e12 ;                        % Air/sea heat flux standard deviation [W].
AirSeaHeatFlux.flux_Delta   = 0e12 ;                        % Air/sea heat flux change over timeseries [W].
fluxes = ar1(DataParams.N,DataParams.c,DataParams.phi,AirSeaHeatFlux.flux_std) ;
fluxes = fluxes - mean(fluxes) + AirSeaHeatFlux.flux_mean + linspace(-AirSeaHeatFlux.flux_Delta/2,AirSeaHeatFlux.flux_Delta/2,DataParams.N)' ;
AirSeaHeatFlux.fluxes       = fluxes ;

% Assemble all gateway straits
tmp.RpPmEStrait    = RpPmEStrait ;
tmp.AirSeaStrait   = AirSeaHeatFlux ;

end