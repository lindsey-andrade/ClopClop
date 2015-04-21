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

function [Wnet_m, N, N_c] = OTECmainFunction(T1,T3,q1,q3,fluidName)
    % T1 is temperature at State 1
    % T3 is temperature at State 3
    % q1 is quality at State 1 (value between 0 and 1)
    % q3 is quality at State 3 (value between 0 and 1)
    % fluidName is the input fluid (needs to be a string)
    
    % returns P1 in [kPA], H1 in [J/kg], and S1 in [J/kgK]
    [P1,H1,S1] = refpropm('PHS','T',T1,'Q',q1,fluidName); %sets state 1
    [P3,H3,S3] = refpropm('PHS','T',T3,'Q',q3,fluidName); %sets state 3
    [T2,Q2,H2] = refpropm('TQH','P',P3,'S',S1,fluidName); %sets state 2
    [T4,Q4,H4] = refpropm('TQH','P',P1,'S',S3,fluidName); %sets state 4
    
    %P1
    %P3
    Wt_m = H1-H2; %[J/kg]
    Wp_m = H3-H4; %[J/kg]
    Wnet_m = Wt_m + Wp_m; %[J/kg]
    
    Qin_m = H1-H4; %[J/kg]
    N = Wnet_m/Qin_m;
    N_c = 1-T3/T1;
    %with ammonia: 91,184 J/kg
    %with R134a: 14,416 J/kg
    %with R22: 14,609 J/kg
    %with water: 188,220 J/kg something wrong? Probably. Operates between 1
    %and 4 kPa, 7% efficiency
    %Carnot Efficiency of cycle is 7.59%
    
end