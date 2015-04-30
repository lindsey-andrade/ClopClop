function OTECwrapFunction()
% Iteration 1 passed variables
T1 = 303; % K
T3 = 280; % K
q1 = 1; 
q3 = 0; 
fluid = 'ammonia';

[Wnet_m, N, N_c] = iteration1(T1, T3, q1, q3, fluid); 

 disp('Iteration 1')
 disp('Working Fluid')
 disp(fluid)
 disp('Net Work (J/kg)')
 disp(Wnet_m)
 disp('Thermal Efficiency')
 disp(N)
 disp('Carnot Efficiency')
 disp(N_c)

% Iteration 2 passed variables 
P1 = 101.3; %[kPa]
P2 = 1; %[kPa]
fluid2 = 'water';

[W_net,N] = iteration2(T1,T3,P1,P2,q1,q3,fluid2);
disp('Iteration 2')
disp('Net Work (J/kg)')
disp(W_net)
disp('Thermal Efficiency')
disp(N)

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

function [Wnet_m, N, N_c] = iteration2(Tw,Tc,P1,P2,q2,q4,fluidName)
        %assume the working fluid is water throughout (Though state 1 is
        %really salt water)
        T1 = Tw;
        T4 = Tc;
        
        [H1,S1] = refpropm('HS','T',T1,'P',P1,fluidName); %sets state 1
        [T2,H2,S2] = refpropm('THS','P',P2,'Q',q2,fluidName); %sets state 2
        [P4,H4,S4] = refpropm('PHS','T',T4,'Q',q4,fluidName); %sets state 4 assuming T3 = T4
        [T3,H3] = refpropm('TH','P',P2,'S',S4,fluidName); %sets state 3
    
        % Calculate how much water gets vaporized
        x = weightFractionVaporized();
        y = x; 
        
        Wnet_m = H1-H2; %[J/kg]; W_net is just W_t since there is no system pump
        Qin_m = H1-H4; %[J/kg]
        N = Wnet_m/Qin_m;
        N_c = 1-T3/T1;
        
        function x = weightFractionVaporized()
            % Tup = Temperature of liquid into the evaporator
            % Pup = Pressure of liquid into the evaporator 
            % Pdown = Pressure of liquid/vapor out of the evaporator
            Tup = 303; %[K] We want to change this if warm water temp changes
            Pup = 101.3; %[kPa]
            Pdown = 1; %[kPa]
            fluid = 'water';
            Hul = refpropm('H', 'T', Tup, 'P', Pup, fluid);
            
            Hdl = refpropm('H', 'P', Pdown, 'Q', 0, fluid); 
            Hdv = refpropm('H', 'P', Pdown, 'Q', 1, fluid);
            
            x = (Hul - Hdl)/(Hdv - Hdl);
        end
        
    end

   

end
