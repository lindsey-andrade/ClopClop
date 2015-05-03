function [Wnet_m, N, N_c, State] = iteration1(T1,T3,q1,q3,fluidName)
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
    
    P2 = P3; P4 = P1;
    S2 = S1; S4 = S3;
    
    Wt_m = H1-H2; %[J/kg]
    Wp_m = H3-H4; %[J/kg]
    Wnet_m = Wt_m + Wp_m; %[J/kg]
    
    Qin_m = H1-H4; %[J/kg]
    N = Wnet_m/Qin_m;
    N_c = 1-T3/T1;
end