%% ELEC 4700 Assignment 1: Monte-Carlo Modeling of Electron Transport
%
% Dilsha Appu-Hennadi, 101107857
% Latest rev. Feb. 24, 2022

clear all
clearvars
clearvars -GLOBAL
close all
% set(0,'DefaultFigureWindowStyle','docked')

global C L W

C.q_0 = 1.60217653e-19;             % electron charge
C.hb = 1.054571596e-34;             % Dirac constant
C.h = C.hb * 2 * pi;                % Planck constant
C.m_0 = 9.10938215e-31;             % electron mass
C.kb = 1.3806504e-23;               % Boltzmann constant
C.eps_0 = 8.854187817e-12;          % vacuum permittivity
C.mu_0 = 1.2566370614e-6;           % vacuum permeability
C.c = 299792458;                    % speed of light
C.m_n = 0.26*C.m_0;                 % effective mass of electrons

L = 200e-9;
W = 100e-9;

numElec = 5000;
numDispElec = 15;

numTimeStep = 500;%50;

Cols = hsv(numDispElec);

%%
%
% In this assignment, we will be modelling the movement of electrons
% through a semiconductor region. Specifically, we are modeling carriers as
% a population of electrons in an N-type Si semiconductor crystal. To do
% this we will be using $$ m_n = 0.26m_0 $$ as the effective mass of the
% electron and the size of the region will be 200 nm by 100 nm.
%

%% 1 Electron Modeling
%
% First, assuming the temperature of the system is 300 K, the thermal
% velocity of the electrons is: $$ v_{th} = \sqrt{2\frac{k T}{m_n}} $$
%

T = 300;
v_th = sqrt(2*C.kb * T/C.m_n);

%%
%
% Given that the mean time between collisions is $$ \tau_{mn} = 0.2 ps $$, the
% mean free path can be calculated as: $$ L_n = \tau_{mn} * v_{th} $$
%

t_mn = 0.2e-12;
L_n = t_mn * v_th;

%%
%
% With this information, we can create a simulation to visualize the
% trajectories of electrons through a region.
%

ElecModel;

%%
%
% In the simulation plot, we see the trajectories of a sample of electrons.
% They are given an initial position in the plane along with an initial
% velocity - the magnitude is the thermal velocity for all electrons, but
% the direction is randomly assigned. As the simulation runs, the electrons
% position updates according to Newton's laws. The top and bottom of the
% plane - i.e. y = 0,W - are rigid and electrons bounce off of them.
% Meanwhile the x boundaries - i.e. x = 0,L - are periodic, so if an
% electron drifts off on one side, it'll reappear on the other side.
%

%%
%
% Plotting the average temperature of the system, we see that it's 300K.
% This makes sense as the magnitude of the velocity of all electrons is the
% thermal velocity which is based on the temperature of the system (which
% was set to 300K). The temperature is also constant over time as the
% magnitude of the velocity never changes.
%

%% 2 Collisions with Mean Free path (MFP)
%
% In this part of the assignment, we will simulate electrons in a region
% similar to the previous part. However, now we will also add in the
% probability of electron collisions and velocities will now be chosen from
% the Maxwell-Boltzmann distribution.
%

CollwMFP;

%%
%
% This part adds on to the previous part as we add in scattering and assign
% electron velocities according to the Maxwell-Boltzmann Distribution. In
% Figure 3, a histogram shows the distribution of velocities. The shape of
% the distribution confirms that the velocity distribution is the
% Maxwell-Boltzmann Distribution. This was accomplished by obtaining the
% directional velocities from a Gaussian Distribution with a standard
% deviation of the thermal velocity.
%

%%
%
% Since the velocities of each electron are a lot more varried, it's
% unsurprising to see that the temperature of the system overtime varies
% quite a bit. It should also be noted that the temperature varies around
% 600K rather than 300K. Because each velocity direction is based on the
% thermal velocity (rather than the magnitude) we see that the temperature
% is essentially double that of the previous part.
%

%%
%
% From the simulation, we calculate the mean time between collisions to be
% about 0.13 ps, slightly less than the expected 0.2 ps, and the Mean Free
% Path is calculated as about 42.8 nm which is also slightly below the
% expected 45.8 nm.
%

%% 3 Enhancements
%
% In this last part we will add some boxes into the region to create a
% bottle-neck. These boxes may be either specular or diffusive - for the
% purpose of the report, the boxes have been left as diffusive.
%

Enhancements;

%%
%
% Because of the boxes, the electrons are a bit more restricted in where
% their initial position can be set to and where they can travel. So, when
% the simulation first starts, we see a lot of electrons appear to the
% sides of the boxes, with maybe a few in the bottle-neck area. Then,
% depending on the scattering, some other electrons may find their way into
% the bottle-neck.
%

%%
%
% Creating a density map to observe the distribution of the electrons in
% the region confirms our original observation of many more elctrons being
% located towards the sides of the boxes.
%

%%
%
% In the distribution plot, we see that the highest densities are located
% in the regions to the left and right of the boxes. This makes sense as
% there is a higher probability of an electron with an initial position in
% the larger open areas rather than the smaller bottle-neck. Additionally,
% with the probability of scattering it is possible for an electron to not
% find itself inside the bottle neck.
%

%%
%
% These results are also reflected in the temperature map (as electron
% density effects the temperature of the material). We see higher
% temperatures on the sides of the material as they have a higher density
% of electrons.
%

%%
%
% Making some small adjustments to the previous simulation, we can simulate
% and injection of negative charge carriers into the system.
%

InjectionMod;

%%
%
% Not too much to note here, but we see that with scattering, it can take a
% while for electrons to start going through the bottle-neck and towards
% the otherside of the region.
%
