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

xPos = L.*rand(1,numElec); % set random initial x position
yPos = W.*rand(1,numElec); % set random initial y position

%%
%
% Before moving forward, we must ensure all initial positions lie outisde
% the boxes.
%
for i = 1:numElec
    while ((xPos(i)>=(B.Left1*L)) && (xPos(i)<=(B.Right1*L))) && (((yPos(i)>=(B.Bottom1*W)) || (yPos(i)<=(B.Top2*W))))
        xPos(i) = L.*rand; % set random initial x position
        yPos(i) = W.*rand; % set random initial y position
    end
end

% velocities will also be assigned randomly according to the
% Maxwell-Boltzmann distribution with an average of the speeds being the
% thermal velocity.

xVel = sqrt(3*C.kb * T/C.m_n)*randn(1,numElec);
yVel = sqrt(3*C.kb * T/C.m_n)*randn(1,numElec);

% we also need to determine the probability of an electron scattering. This
% is given by the function: \[P_{scat} = 1 - e^{-dt/ \tau_{mn}}\]

Pscat = 1 - exp(-dt/t_mn);

for t = 1:numTimeStep
    
    % determine temperature
    E_k = C.m_n .* (sqrt(xVel.^2 + yVel.^2).^2) ./ 2;
    avgE_k = sum(E_k)/numElec;
    expTemp(t) = (2*avgE_k)/(3*C.kb);
    time(t) = t*dt;
    
    figure(6)
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

% Plot electron density map
finalPos = [xPos' yPos'];

figure(7)
hist3(finalPos, 'CDataMode', 'auto', 'FaceColor', 'interp', 'Nbins', [20 20])

% Plot temperature map
% use final velocities of electrons

elecDens = hist3(finalPos,'Nbins', [40 20]);

E_k = C.m_n .* (sqrt(xVel.^2 + yVel.^2).^2) ./ 2;
Temp = (2.*E_k)./(3*C.kb);
avgTemp = mean(Temp);

tempMap = elecDens.*avgTemp;
tempMap = tempMap';

figure(8)
s = pcolor(tempMap)
s.FaceColor = 'interp';
