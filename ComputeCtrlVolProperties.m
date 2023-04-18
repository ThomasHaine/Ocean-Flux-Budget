function CtrlVol = ComputeCtrlVolProperties(budgets,DataParams)
CtrlVol.mass   = DataParams.InitCtrlVolMass + budgets.mass.total ;
CtrlVol.salt   = DataParams.InitCtrlVolSalt + budgets.salt.total ;
CtrlVol.volume = DataParams.InitCtrlVolVol  + budgets.volume.total ;
CtrlVol.sal    = (CtrlVol.salt.*1e3)./CtrlVol.mass ;
CtrlVol.temp   = DataParams.InitCtrlVolTemp + budgets.heat.total./(CtrlVol.mass*DataParams.C_p) ;
CtrlVol.dens   = gsw_rho(CtrlVol.sal,CtrlVol.temp,DataParams.p_ref) ;
end