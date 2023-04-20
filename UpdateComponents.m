function components = UpdateComponents(FluxParams,DataParams,components)
componentNames = fieldnames(components) ;
for ss = 1:numel(componentNames)
    if(strcmp(components.(componentNames{ss}).type,'advective'))     % Only update advective components.
        component = componentNames{ss} ;
        [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(components.(component),FluxParams,DataParams) ;
        components.(component).vol_flux  =  vol_flux ;
        components.(component).mass_flux = mass_flux ;
        components.(component).salt_flux = salt_flux ;
        components.(component).heat_flux = heat_flux ;
        components.(component).LFC_flux  =  LFC_flux ;

        [salt_flux_correl,heat_flux_correl,LFC_flux_correl] = ComputeCorrelations(components.(component)) ;
        components.(component).salt_flux_correl = salt_flux_correl ;
        components.(component).heat_flux_correl = heat_flux_correl ;
        components.(component).LFC_flux_correl  =  LFC_flux_correl ;
    end % if
end % ss
end

%% Local functions
function [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(component, FluxParams, DataParams)
vol_flux  = component.parameters.area .* component.normal_speed ;
mass_flux =                   component.density .* vol_flux ;
heat_flux = DataParams.C_p .* component.density .* vol_flux .* (component.temperature - FluxParams.T_ref) ;
LFC_flux  =                                        vol_flux .* (FluxParams.S_ref - component.salinity)./FluxParams.S_ref ;
salt_flux =                   component.density .* vol_flux .*  component.salinity./1e3 ;         % g/kg -> kg/kg conversion
end

function [salt_flux_correl,heat_flux_correl,LFC_flux_correl] = ComputeCorrelations(component)

[r,p] = corrcoef([component.salt_flux component.vol_flux component.salinity]) ;
salt_flux_correl.vol_flux.r = r(1,2) ;
salt_flux_correl.vol_flux.p = p(1,2) ;
salt_flux_correl.salinity.r = r(1,3) ;
salt_flux_correl.salinity.p = p(1,3) ;

[r,p] = corrcoef([component.heat_flux component.vol_flux component.temperature]) ;
heat_flux_correl.vol_flux.r    = r(1,2) ;
heat_flux_correl.vol_flux.p    = p(1,2) ;
heat_flux_correl.temperature.r = r(1,3) ;
heat_flux_correl.temperature.p = p(1,3) ;

[r,p] = corrcoef([component.LFC_flux component.vol_flux component.salinity]) ;
LFC_flux_correl.vol_flux.r = r(1,2) ;
LFC_flux_correl.vol_flux.p = p(1,2) ;
LFC_flux_correl.salinity.r = r(1,3) ;
LFC_flux_correl.salinity.p = p(1,3) ;
    
end