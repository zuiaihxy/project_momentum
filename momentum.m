clear
close all

return_m_hor=readtable('return_monthly.xlsx','ReadVariableNames',true,'PreserveVariableNames',true,'Format','auto');
return_m=stack(return_m_hor,3:width(return_m_hor),'NewDataVariableName','return_m','IndexVariableName','date');
return_m.date=char(return_m.date);
return_m.datestr=datestr(return_m.date);
return_m.date=datetime(return_m.datestr,'InputFormat','dd-MMM-yyyy','Locale','en_US');
return_m.return_m=return_m.return_m/100;

market_cap_lm_hor=readtable('me_lag.xlsx','ReadVariableNames',true,'PreserveVariableNames',true,'Format','auto');
market_cap_lm=stack(market_cap_lm_hor,3:width(market_cap_lm_hor),'NewDataVariableName','lme',...
'IndexVariableName','date');
market_cap_lm.date=char(market_cap_lm.date);
market_cap_lm.datestr=datestr(market_cap_lm.date);
market_cap_lm.date=datetime(market_cap_lm.datestr,'InputFormat','dd-MMM-yyyy','Locale','en_US');

% merge two files 
return_monthly=outerjoin(return_m,market_cap_lm,'Keys',{'date','code','name','datestr'},'MergeKeys',true,'Type','left');
return_monthly=sortrows(return_monthly,{'code','date'},{'ascend','ascend'});

index=~isnan(return_monthly.lme);
return_monthly=return_monthly(index,1:end);

save return_m.mat return_monthly;
