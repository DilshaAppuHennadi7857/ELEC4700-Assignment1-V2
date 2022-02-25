global B

% simulation time
dt = 1e-15;
numTimeStep = 1000;

% Define boxes
% Box 1 (top)
B.Left1 = 0.35;
B.Right1 = 0.65;
B.Top1 = 1;
B.Bottom1 = 0.6;

% Box 2 (bottom)
B.Left2 = 0.35;
B.Right2 = 0.65;
B.Top2 = 0.4;
B.Bottom2 = 0;

% B.type = 's'; % specular boxes
B.type = 'd'; % diffusive boxes

xPos = zeros(1,numElec); % set random initial x position
yPos = (0.4*W) + (0.6*W - 0.4*W).*rand(1,numElec); % set random initial y position

% velocities will also be assigned randomly according to the
% Maxwell-Boltzmann distribution with an average of the speeds being the
% thermal velocity.

xVel = abs(sqrt(3*C.kb * T/C.m_n)*randn(1,numElec));
yVel = sqrt(3*C.kb * T/C.m_n)*randn(1,numElec);

% we also need to determine the probability of an electron scattering. This
% is given by the function: \[P_{scat} = 1 - e^{-dt/ \tau_{mn}}\]

Pscat = 1 - exp(-dt/t_mn);

for t = 1:numTimeStep
    
    figure(9)
    for n = 1:numDispElec
        plot(xPos(n), yPos(n),'.','color',Cols(n,:))
    end
    title('Electrons as Carriers in N-type Si crystal (with Collision)')
    axis([0 L 0 W])
    hold on
    makeBox(B.Left1,B.Right1,B.Top1,B.Bottom1,L,W);
    makeBox(B.Left2,B.Right2,B.Top2,B.Bottom2,L,W);
    
    % save old x and y positions
    xPrev = xPos;
    yPrev = yPos;
    
    randNum = rand(1, numElec); % generate a random number for each electron
    scatter = randNum < Pscat; % determine if electron scatters
    xVel(scatter) = sqrt(3*C.kb * T/C.m_n)*randn;
    yVel(scatter) = sqrt(3*C.kb * T/C.m_n)*randn;
    
    newXPos = xPos + xVel*dt;
    newYPos = yPos + yVel*dt;
    
    if B.type == 's' % specular boxes, just bounce

        for i = 1:numElec
            if ((newXPos(i)>=(B.Left1*L)) && (newXPos(i)<=(B.Right1*L))) && (((newYPos(i)>=(B.Bottom1*W)) || (newYPos(i)<=(B.Top2*W))))
                if (xPrev(i) <= B.Left1*L) || (xPrev(i) >= B.Right1*L )
                    xVel(i) = -xVel(i);
                elseif (yPrev(i) <= B.Bottom1*W) || (yPrev(i) >= B.Top2*W)
                    yVel(i) = -yVel(i);
                end
            end
        end
        
    elseif B.type == 'd' % diffusive boxes, re-thermalize
        
        for i = 1:numElec
            if ((newXPos(i)>=(B.Left1*L)) && (newXPos(i)<=(B.Right1*L))) && (((newYPos(i)>=(B.Bottom1*W)) || (newYPos(i)<=(B.Top2*W))))
                if (xPrev(i) <= B.Left1*L) || (xPrev(i) >= B.Right1*L )
                    xVel(i) = -xVel(i);
                    yVel(i) = sqrt(3*C.kb * T/C.m_n)*randn;
                elseif (yPrev(i) <= B.Bottom1*W) || (yPrev(i) >= B.Top2*W)
                    xVel(i) = sqrt(3*C.kb * T/C.m_n)*randn;
                    yVel(i) = -yVel(i);
                end
            end
        end
        
    end
    
    xPos = xPos + xVel*dt;
    
    crossTop = newYPos > W;
    crossBottom = newYPos < 0;
    yVel(crossTop) = -yVel(crossTop);
    yVel(crossBottom) = -yVel(crossBottom);
    yPos = yPos + yVel*dt;
    
    pause(0.01);
    
end