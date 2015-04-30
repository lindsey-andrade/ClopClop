function [X] = vaporFrac( HDL, HDV)
    HUL = 125.2;  % [J/kg]  
    X = (HUL - HDL)/(HDV-HDL)
end