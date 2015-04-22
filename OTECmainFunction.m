%% THERMO OTEC PROJECT
% Lindsey Andrade, Sean Karagianes, Meg Lidrbauch
% Spring 2015
function OTECmainFunction()

%% Iteration 1 - Closed System
% Assumptions: 
% At State 1, we assume that the working fluid is a saturated vapor. At
% State 3, we assume that the working fluid is a saturated liquid. The
% working fluid leaves both heat exchangers at the temperature of the other
% fluid in the exchanger. All of the components are modeled as control
% volumes at steady state. There are no internal irreversibilities in any
% of the cycle processes. The pump and turbine operate isentropically. No
% kinetic or potential energy effects. 

T1 = 303; % K
T3 = 280; % K
q1 = 1; 
q3 = 0; 
fluid = 'water';

[Wnet_m, N, N_c] = iteration1(T1, T3, q1, q3, fluid); 

disp('Net Work (J/kg)')
disp(Wnet_m)
disp('Thermal Efficiency')
disp(N)
disp('Carnot Efficiency')
disp(N_c)

function [Wnet_m, N, N_c] = iteration1(T1,T3,q1,q3,fluidName)
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
    function [Wnet_m, N, N_c] = iteration2(Tw,Tc,P1,P2,q2,q4,fluidName)
        %assume the working fluid is water throughout (Though state 1 is
        %really salt water)
        T1 = Tw;
        T4 = Tc;
        
        [T2,H2,S2] = refpropm('THS','P',P2,'Q',q2,fluidName); %sets state 2
        [P4,H4,S4] = refpropm('PHS','T',T4,'Q',q4,fluidName); %sets state 4 assuming saturated liquid
        [H3,S3] = refpropm('HS','T',T4,'P',P2,fluidName); %sets state 3 assuming T3 = T4
        [H1,S1] = refpropm('HS','T',T1,'P',P1,fluidName); %sets state 1 assuming water entering system is at atm pressure
    
        % Calculate how much water gets vaporized
        x = weightFractionVaporized(T1, P1, P2, 'water');
        y = x; 
        
        Wt_m = H1-H2; %[J/kg]; W_net is just W_t since there is no system pump
        Qin_m = H1-H4; %[J/kg]
        N = Wnet_m/Qin_m;
        N_c = 1-T3/T1;
        
        function x = weightFractionVaporized(Tup, Pup, Pdown, fluid)
            % Tup = Temperature of liquid into the evaporator
            % Pup = Pressure of liquid into the evaporator 
            % Pdown = Pressure of liquid/vapor out of the evaporator
            
            Hul = refprop('H', 'P', Pup, 'T', Tup, fluid);
            
            Hdl = refprop('H', 'P', Pdown, 'Q', 0, fluid); 
            Hdv = refprop('H', 'P', Pdown, 'Q', 1, fluid);
            
            x = (Hul - Hdl)/(Hdv - Hdl);
        end
        
    end

end
