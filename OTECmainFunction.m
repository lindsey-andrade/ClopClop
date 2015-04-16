%% THERMO OTEC PROJECT
% Lindsey Andrade, Sean Karagianes, Meg Lidrbauch
% Spring 2015


%% Iteration 1 - Closed System
% Assumptions: 
% At State 1, we assume that the working fluid is a saturated vapor. At
% State 3, we assume that the working fluid is a saturated liquid. The
% working fluid leaves both heat exchangers at the temperature of the other
% fluid in the exchanger. All of the components are modeled as control
% volumes at steady state. There are no internal irreversibilities in any
% of the cycle processes. The pump and turbine operate isentropically. No
% kinetic or potential energy effects. 

function [Wc] = WAH10_2 (T1,T3,q1,q3,fluidName)
    % returns P1 in [kPA], H1 in [J/kg], and S1 in [J/kgK]
    [P1,H1,S1] = refpropm('PHS','T',T1,'Q',q1,fluidName); %sets state 1
    [P3,H3,S3] = refpropm('PHS','T',T3,'Q',q3,fluidName); %sets state 3
    [T2,Q2,H2] = refpropm('TQH','P',P3,'S',S1,fluidName); %sets state 2
    [T3,Q3,H3] = refpropm('TQH','P',P1,'S',S3,fluidName); %sets state 4
    
end