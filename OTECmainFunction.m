%% THERMO OTEC PROJECT
% Lindsey Andrade, Sean Karagianes, Meg Lidrbauch
% Spring 2015


%% Iteration 1 - Closed System
function [Wc] = WAH10_2 (T1,q1,fluidName)
    % returns P1 in [kPA], H1 in [J/kg], and S1 in [J/kgK]
    [P1,H1,S1] = refpropm('PHS','T',T1,'Q',q1,fluidName)
end