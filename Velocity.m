function [VelocityMB] = Velocity(numElec,T, v_th,C)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = sqrt(C.kb * T/C.m_n)*randn(1,numElec) + v_th;

VelocityMB = abs((log(n.*(C.m_n/(2*pi*C.kb*T))^(-1/2)) .* (-(2*C.kb*T)/C.m_n)) .^ (1/2));
end

