% T1o = 303; % K
% T3c = 280; % K
% P1o = 101.3; %[kPa]
% P2o = 1; %[kPa]
% fluidName = 'ammonia';

function [Wnet_mH, NH] = iteration3(T1o,T3c,P1o,fluidName)
    q1 = 1;
    q3 = 0;
    P2o = exp(20.306-5132/T1o)*.133322368;
    % Open cycle part of system 
    [H1o,S1o] = refpropm('HS','T',T1o,'P',P1o,'water'); %sets state 1
    [T2o,H2o,S2o] = refpropm('THS','P',P2o,'Q',q1,'water'); %sets state 2
    
    T1c = T2o;
     % Closed cycle part of system
    [P1h,H1,S1] = refpropm('PHS','T',T1c,'Q',q1,fluidName); %sets state 1
    [P3,H3,S3] = refpropm('PHS','T',T3c,'Q',q3,fluidName); %sets state 3
    [T2,Q2,H2] = refpropm('TQH','P',P3,'S',S1,fluidName); %sets state 2
    [T4,Q4,H4] = refpropm('TQH','P',P1h,'S',S3,fluidName); %sets state 4
    
    P2h = P3; P4 = P1h;
    S2 = S1; S4 = S3;
        
    x = weightFractionVaporized();
    y = x; 
        
    m = 1686*y; %mass flow rate through turbine [kg/s]
        
    Wt_m = H1-H2; %[J/kg]
    Wp_m = H3-H4; %[J/kg]
    Wnet_mH = Wt_m + Wp_m; %[J/kg]
    
    Qin_m = H1-H4; %[J/kg]
    NH = Wnet_mH/Qin_m;
    
    function x = weightFractionVaporized()
            % Tup = Temperature of liquid into the evaporator
            % Pup = Pressure of liquid into the evaporator 
            % Pdown = Pressure of liquid/vapor out of the evaporator
            Tup = T1o; %[K] We want to change this if warm water temp changes
            Pup = P1o; %[kPa]
            Pdown = P2o; %[kPa]
            fluidx = 'water';
            Hul = refpropm('H', 'T', Tup, 'P', Pup, fluidx);
            
            Hdl = refpropm('H', 'P', Pdown, 'Q', 0, fluidx); 
            Hdv = refpropm('H', 'P', Pdown, 'Q', 1, fluidx);
            
            x = (Hul - Hdl)/(Hdv - Hdl);
        end
end