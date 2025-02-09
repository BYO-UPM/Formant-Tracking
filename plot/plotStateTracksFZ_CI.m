% x_est is a cell array, where x_est{ii} is one trials of a 2D matrix
% of numStates x numFrames
%
% Author: Patrick J. Wolfe, Daniel Rudoy, Daryush Mehta
%
% Created: 05/12/2010
% Modified: 05/12/2010, 06/01/2010 (trackBW and zeroes)

function plotStateTracksFZ_CI(trueState,x_est,titleCell,nP,trackBW)
% Plot estimated formant tracks for poles/zeros and bandwidths vs. ground truth with
% X % confidence interval around mean

CI = 68; % for plus/minus 1 standard deviation

% Number of track estimates
numEst = size(x_est,2);
numStates = size(trueState,1);
numObs = size(trueState,2);
numTrials = length(x_est);

if trackBW
    nZ = numStates/2-nP;
else
    nZ = numStates-nP;
end

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
        [L U ave] = findCI(x_estPerFreq(:,:,ff), CI);
        fill([xdata xdata(end:-1:1)], [L U(end:-1:1)], [0.9 0.9 0.9], 'EdgeColor', 'none')
        plot(xdata, ave, char(titleCell(2,tt+1)), 'LineWidth', 1)
    end
    plot(trueState(ff,:), char(titleCell(2,1)));
    yrange = get(gca, 'YLim');
    yrangemax = max(yrangemax, yrange(2)-yrange(1));
    
    if ~nZ
        if ~trackBW
            title(['Formant ' int2str(ff)]);
        else
            if ff > nP
                title(['Formant BW ' int2str(ff-nP)]);
            else
                title(['Formant ' int2str(ff)]);
            end            
        end
    else% zeros also
        if ~trackBW
            if ff > nP
                title(['Anti-formant ' int2str(ff-nP)]);
            else
                title(['Formant ' int2str(ff)]);
            end
        else
            if ff <= nP
                title(['Formant ' int2str(ff)]);
            end

            if ff > nP && ff <= 2*nP
                title(['Formant BW ' int2str(ff-nP)]);
            end

            if ff > 2*nP && ff <= (2*nP + nZ)
                title(['Anti-formant ' int2str(ff-2*nP)]);
            end
            
            if ff > (2*nP + nZ) && ff <= (2*nP + 2*nZ)
                title(['Anti-formant BW ' int2str(ff-2*nP-nZ)]);
            end
        end
    end
    
    if ff==1
        legend('+/- 1 SD', S{2},S{1})
        xlabel('Frame number');
        ylabel('Frequency (Hz)');
    end
    
    format_plot
end

for ff = 1:numStates
    subplot(m,n,ff)
    yrange = get(gca, 'YLim');
    set(gca, 'YLim', [yrange(1) yrange(1)+yrangemax])
end