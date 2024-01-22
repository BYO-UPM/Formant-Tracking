% processAudio.m
function processAudio(sAudio, numFormants, numAntiF, aParams, cepOrder, cepType, algFlag)

    % Add any required paths
    addpath(genpath('/home/alexjorguer/GitHub/CUCOdb/karma_formantes_2.1'));

    % Calculate x0, bwStates, formantInds, and trackBW
    x0 = 500 + 1000*(0:(numFormants - 1))';
    x02 = 1000 + 1000*(0:(numAntiF - 1))';
    x0 = [x0; x02];

    bwStates = 80 + 40*(0:(numFormants - 1))';
    bwStates2 = 80 + 40*(0:(numAntiF - 1))';
    bwStates = [bwStates; bwStates2];

    formantInds = 1;
    trackBW = 1;

    [x_est, x_errVar, x, params] = karma_byo(sAudio, numFormants, numAntiF, aParams, cepOrder, cepType, algFlag, x0, bwStates, formantInds, trackBW);

    % Plot the spectrogram
    plotSpecTracks2_estVar(x, x_est, x_errVar, params.aParams, params.numAntiF, params.trackBW);
    set(gca, 'PlotBoxAspectRatio', [5 1 1]);

    % Save the image in the best resolution possible
    outputImagePath = strrep(sAudio, '.wav', '.png');
    saveas(gcf, outputImagePath, 'png');
    close(gcf);

    % Generate a MAT file
    % Create a structure to store the data
    data.x_est = x_est;
    data.x_errVar = x_errVar;
    data.x = x;
    data.params = params;

    % Save the data as a MAT file
    matFilePath = strrep(sAudio, '.wav', '.mat');
    save(matFilePath, 'data');

end
