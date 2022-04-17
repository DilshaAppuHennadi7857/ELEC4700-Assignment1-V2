% simulation time
dt = 1e-15;

% assign a random x and y initial position for each electron
% initial positions are chosen from a uniform distribution
% x positions will be between 0 and 200 nm and y positions
% will be between 0 and 100 nm.
xPos = L*rand(1,numElec);
yPos = W*rand(1,numElec);

% velocities will also be assigned randomly according to the
% Maxwell-Boltzmann distribution with an average of the speeds being the
% thermal velocity.

xVel = sqrt(3*C.kb * T/C.m_n)*randn(1,numElec);
yVel = sqrt(3*C.kb * T/C.m_n)*randn(1,numElec);

magVel = sqrt(xVel.^2 + yVel.^2);

figure(3)
hist(magVel,20)
title('Velocity Distribution')
xlabel('Velocity (m/s)')

% we also need to determine the probability of an electron scattering. This
% is given by the function: \[P_{scat} = 1 - e^{-dt/ \tau_{mn}}\]

Pscat = 1 - exp(-dt/t_mn);
% Pscat = 0.5 % temp probability for debugging

% to determine MFP and mean time between collisions, observe the trajectory
% of a single electron
scatRecord = [];
index = 1;

for t = 1:numTimeStep
    
    % determine temperature
    xyAvgVel = mean(sqrt(xVel.^2 + yVel.^2));
    expTemp(t) = (xyAvgVel^2)*(C.m_n/(2*C.kb));
    time(t) = t*dt;
    
    figure(4)
    for n = 1:numDispElec
        plot(xPos(n), yPos(n),'.','color',Cols(n,:))
    end
    title('Electrons as Carriers in N-type Si crystal (with Collision)')
    xlabel('Region Length (m)')
    ylabel('Region Width (m)')
    axis([0 L 0 W])
    hold on
    
    randNum = rand(1, numElec); % generate a random number for each electron
    scatter = randNum < Pscat; % determine if electron scatters
    xVel(scatter) = sqrt(3*C.kb * T/C.m_n)*randn;
    yVel(scatter) = sqrt(3*C.kb * T/C.m_n)*randn;
    
    % record the time in which a scattering event occured at. Note, this is
    % not the time between collisions but a time stamp of when a collision
    % has occured
    if scatter(1)
        scatRecord(index) = t*dt;
        index = index + 1;
    end
    
    newXPos = xPos + xVel*dt;
    newYPos = yPos + yVel*dt;
    
    crossRight = newXPos >= L;
    crossLeft = newXPos <= 0;
    xPos = xPos + xVel*dt;
    xPos(crossRight) = 0;
    xPos(crossLeft) = L;
    
    crossTop = newYPos > W;
    crossBottom = newYPos < 0;
    yVel(crossTop) = -yVel(crossTop);
    yVel(crossBottom) = -yVel(crossBottom);
    yPos = yPos + yVel*dt;
    
    pause(0.01);
    
end

figure(5)
plot(time,expTemp)
title('Experimental Temperature (K)')
ylabel('Temp (K)')
xlabel('Time')

timeBetweenColl = [];

for i = 1:length(scatRecord)-1
    timeBetweenColl(i) = scatRecord(i+1) - scatRecord(i);
end

meanTimeBetweenColl = sum(timeBetweenColl)/length(scatRecord)

MFP_calc = meanTimeBetweenColl * sqrt(xVel(1)^2 + yVel(1)^2)
