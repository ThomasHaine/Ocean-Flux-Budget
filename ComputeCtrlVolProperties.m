function CtrlVol = ComputeCtrlVolProperties(budgets,DataParams)
CtrlVol.mass        = DataParams.InitCtrlVolMass + budgets.mass.total ;
CtrlVol.salt        = DataParams.InitCtrlVolSalt + budgets.salt.total ;
CtrlVol.salinity    = (CtrlVol.salt.*1e3)./CtrlVol.mass ;
CtrlVol.temperature = DataParams.InitCtrlVolTemp + budgets.heat.total./(CtrlVol.mass*DataParams.C_p) ;

% Currently, these variables aren't used:
% CtrlVol.density     = gsw_rho(CtrlVol.salinity,CtrlVol.temperature,DataParams.p_ref) ;
% CtrlVol.volume      = DataParams.InitCtrlVolVol  + budgets.volume.total ;
end