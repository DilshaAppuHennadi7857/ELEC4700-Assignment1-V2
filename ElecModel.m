
% assign a random x and y initial position for each electron
% initial positions are chosen from a uniform distribution
% x positions will be between 0 and 200 nm and y positions
% will be between 0 and 100 nm.
xPos = L*rand(1,numElec);
yPos = W*rand(1,numElec);

% velocities will also be assigned randomly.
% a random direction is chosen from a uniform distribution of directions
% from 0 to 2*pi. The thermal velocity will be the magnitude of velocity
% for all electrons and the randomly chosen direction will determine the
% directional velocities.
elecDir = 2*pi*rand(1,numElec);
xVel = v_th*cos(elecDir);
yVel = v_th*sin(elecDir);

% simulation time
dt = 1e-15;

for t = 1:numTimeStep
    
    % determine temperature
    xyAvgVel = mean(sqrt(xVel.^2 + yVel.^2));
    expTemp(t) = (xyAvgVel^2)*(C.m_n/(2*C.kb));
    time(t) = t*dt;
    
    figure(1)
    for n = 1:numDispElec
        plot(xPos(n), yPos(n),'.','color',Cols(n,:))
    end
    title('Electrons as Carriers in N-type Si crystal')
    xlabel('Region Length (m)')
    ylabel('Region Width (m)')
    axis([0 L 0 W])
    hold on
    
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

figure(2)
plot(time,expTemp)
title('Experimental Temperature (K)')
ylabel('Temp (K)')
xlabel('Time')