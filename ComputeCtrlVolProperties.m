function CtrlVol = ComputeCtrlVolProperties(budgets,DataParams)
CtrlVol.mass   = DataParams.InitCtrlVolMass + budgets.mass ;
CtrlVol.salt   = DataParams.InitCtrlVolSalt + budgets.salt ;
CtrlVol.volume = DataParams.InitCtrlVolVol  + budgets.volume ;
CtrlVol.sal    = (CtrlVol.salt.*1e-3)./CtrlVol.mass ;
CtrlVol.temp   = DataParams.InitCtrlVolTemp + budgets.heat./(CtrlVol.mass*DataParams.C_p) ;
CtrlVol.dens   = gsw_rho(CtrlVol.sal,CtrlVol.temp,DataParams.p_ref) ;
end