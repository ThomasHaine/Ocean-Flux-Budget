function straits = UpdateStraits(FluxParams, straits)
straitNames = fieldnames(straits) ;
for ss = 1:numel(straitNames)
    strait = straitNames{ss} ;
    [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(straits.(strait),FluxParams) ;
    straits.(strait).vol_flux  =  vol_flux ;
    straits.(strait).mass_flux = mass_flux ;
    straits.(strait).salt_flux = salt_flux ;
    straits.(strait).heat_flux = heat_flux ;
    straits.(strait).LFC_flux  =  LFC_flux ;

    [salt_flux_correl,heat_flux_correl,LFC_flux_correl] = ComputeCorrelations(straits.(strait)) ;
    straits.(strait).salt_flux_correl = salt_flux_correl ;
    straits.(strait).heat_flux_correl = heat_flux_correl ;
    straits.(strait).LFC_flux_correl  =  LFC_flux_correl ;
end % ss
end

%% Local functions
function [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(strait, FluxParams)
vol_flux  =  strait.parameters.area .* strait.normal_speed ;
mass_flux =                   strait.density .* vol_flux ;
heat_flux = FluxParams.C_p .* strait.density .* vol_flux .* (strait.temperature - FluxParams.T_ref) ;
LFC_flux  =                                     vol_flux .* (strait.salinity    - FluxParams.S_ref) ;
salt_flux =                   strait.density .* vol_flux .*  strait.salinity./1e3 ;         % g/kg -> kg/kg conversion
end

function [salt_flux_correl,heat_flux_correl,LFC_flux_correl] = ComputeCorrelations(strait)

[r,p] = corrcoef([strait.salt_flux strait.vol_flux strait.salinity]) ;
salt_flux_correl.vol_flux.r = r(1,2) ;
salt_flux_correl.vol_flux.p = p(1,2) ;
salt_flux_correl.salinity.r = r(1,3) ;
salt_flux_correl.salinity.p = p(1,3) ;

[r,p] = corrcoef([strait.heat_flux strait.vol_flux strait.temperature]) ;
heat_flux_correl.vol_flux.r    = r(1,2) ;
heat_flux_correl.vol_flux.p    = p(1,2) ;
heat_flux_correl.temperature.r = r(1,3) ;
heat_flux_correl.temperature.p = p(1,3) ;

[r,p] = corrcoef([strait.LFC_flux strait.vol_flux strait.salinity]) ;
LFC_flux_correl.vol_flux.r = r(1,2) ;
LFC_flux_correl.vol_flux.p = p(1,2) ;
LFC_flux_correl.salinity.r = r(1,3) ;
LFC_flux_correl.salinity.p = p(1,3) ;
    
end