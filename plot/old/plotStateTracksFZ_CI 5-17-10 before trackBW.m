% x_est is a cell array, where x_est{ii} is one trials of a 2D matrix
% of numStates x numFrames
%
% Author: Patrick J. Wolfe, Daniel Rudoy, Daryush Mehta
%
% Created: 05/12/2010
% Modified: 05/12/2010

function plotStateTracksFZ_CI(trueState,x_est,titleCell,nP)
% Plot estimated formant tracks for poles/zeros vs. ground truth with
% 95% confidence interval around mean

% Number of track estimates
numEst = size(x_est,2);
numStates = size(trueState,1);
numObs = size(trueState,2);
numTrials = length(x_est);

% repackage into 3D matrix of numTrials x numFrames x numStates
x_estPerFreq = zeros(numTrials, numObs, size(trueState,1));
for kk = 1:size(trueState,1)
    for jj = 1:numTrials
        x_estPerFreq(jj, :, kk) = x_est{jj}(kk, :);
    end
end

%Titles for plot legends
ii = 1:(numEst+1);
S = titleCell(1,ii);

xdata = 1:numObs;

% Assumes tracking all four formants
m = ceil(sqrt(numStates));
n = ceil(numStates/m);
yrangemax = 0;
figure; clf,
for ff = 1:numStates
    subplot(m,n,ff)
    %grid on;
    box off
    hold on;
    for tt = 1:numEst
        [ydata_lower ydata_upper ydata] = findCI(x_estPerFreq(:,:,ff), 95);
        fill([xdata xdata(end:-1:1)], [ydata_lower ydata_upper(end:-1:1)], [0.9 0.9 0.9], 'EdgeColor', 'none')
        plot(xdata, ydata, char(titleCell(2,tt+1)), 'LineWidth', 1)
    end
    plot(trueState(ff,:), char(titleCell(2,1)));
    yrange = get(gca, 'YLim');
    yrangemax = max(yrangemax, yrange(2)-yrange(1));
    
    if ff > nP
        title(['Anti-resonance ' int2str(ff-nP)]);
    else
        title(['Resonance ' int2str(ff)]);
    end
    
    if ff==1
        legend('95% CI', S{2},S{1})
        xlabel('Time Block');
        ylabel('Frequency (Hz)');
    end
end

for ff = 1:numStates
    subplot(m,n,ff)
    yrange = get(gca, 'YLim');
    set(gca, 'YLim', [yrange(1) yrange(1)+yrangemax])
end