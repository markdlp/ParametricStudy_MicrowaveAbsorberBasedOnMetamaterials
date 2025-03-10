clc; clear; close all

freq = 2.7e9:1e7:12.7e9;

epsilon_0 = 8.854187817e-12 ;% F/m
mu_0 = pi*4e-7 ;% H/m

Z0 = 377 ;% Free space impedance

lambda = physconst('LightSpeed')./freq ;% is different on each layer

mu_r1 = 1 ;% μ_r1
epsilon_r1 = 1 ;% ε_r1

h_1 = 9e-3 ;% 9mm -> air layer height

beta_1 = 2*pi*sqrt(mu_r1*epsilon_r1)./lambda ;% β

Zd1 = Z0*sqrt(mu_r1/epsilon_r1);

Zin_d1 = 1j*Zd1*tan(beta_1*h_1);

epsilon_r2 = 4.3 ;% relative permittivity (ε_r2)
mu_r2 = 1 ;% relative permeability (μ_r2)

epsilon_2 = epsilon_r2*epsilon_0;
mu_2 = mu_r2*mu_0;

aleph = 40;

sigma = sqrt(epsilon_2*(2*aleph)^2/(mu_2)) ;% σ

omega = 2*pi*freq;

beta_2 = omega*sqrt(mu_2*epsilon_2/2).*sqrt(sqrt(1+(sigma./(omega*epsilon_2)).^2)+1);

lambda = 2*pi./beta_2 ;% λ = 2π/β

% vita_2 = 2*pi*sqrt(mu_r2*epsilon_r2)./lambda ;% β

h_2 = 2e-4 ;% 0.2mm -> FR-4 layer height

Zd2 = Z0*sqrt(mu_r2/epsilon_r2);

Zin_d2 = Zd2*(Zin_d1 + 1j*Zd2.*tan(beta_2*h_2))./(Zd2 + 1j*Zin_d1.*tan(beta_2*h_2));

% S parameters are imported in dB
S_11 = importSparams("data/s11.txt", [2, Inf]); S_11 = S_11'; 
S_21 = importSparams("data/s21.txt", [2, Inf]); S_21 = S_21';

z = sqrt(((1+S_11).^2 - S_21)./((1-S_11).^2 + S_21));

syms Gamma Zpatch

eq1 = real(z)*Z0 == (1+Gamma)./(1-Gamma);
eq2 = Gamma == (((Zin_d2+Zpatch)./(Zin_d2*Zpatch))-Z0)./(((Zin_d2+Zpatch)./(Zin_d2*Zpatch))+Z0);

result = solve([eq1 eq2], Zpatch, ...
    Real=true, IgnoreAnalyticConstraints=true, ...
    ReturnConditions=true ...
);