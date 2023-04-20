function components = UpdateComponents(FluxParams,DataParams,components)
componentNames = fieldnames(components) ;
for ss = 1:numel(componentNames)
    if(strcmp(components.(componentNames{ss}).type,'advective'))     % Only update advective components.
        strait = componentNames{ss} ;
        [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(components.(strait),FluxParams,DataParams) ;
        components.(strait).vol_flux  =  vol_flux ;
        components.(strait).mass_flux = mass_flux ;
        components.(strait).salt_flux = salt_flux ;
        components.(strait).heat_flux = heat_flux ;
        components.(strait).LFC_flux  =  LFC_flux ;

        [salt_flux_correl,heat_flux_correl,LFC_flux_correl] = ComputeCorrelations(components.(strait)) ;
        components.(strait).salt_flux_correl = salt_flux_correl ;
        components.(strait).heat_flux_correl = heat_flux_correl ;
        components.(strait).LFC_flux_correl  =  LFC_flux_correl ;
    end % if
end % ss
end

%% Local functions
function [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(strait, FluxParams, DataParams)
vol_flux  =  strait.parameters.area .* strait.normal_speed ;
mass_flux =                   strait.density .* vol_flux ;
heat_flux = DataParams.C_p .* strait.density .* vol_flux .* (strait.temperature - FluxParams.T_ref) ;
LFC_flux  =                                     vol_flux .* (FluxParams.S_ref - strait.salinity)./FluxParams.S_ref ;
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