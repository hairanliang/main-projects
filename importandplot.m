% Loads data_exp_24617-v6_task-nrfn.csv, calculates participant reaction
% median time and accuracy, then plots a histogram of these two values
% across participants

tooSlow = 3000;
tooFast = 100;

filteredArray = [];

%% importing data into table called rawdata

neededColumns = {'ParticipantPrivateID', 'ScreenName', 'ReactionTime', 'Correct', 'randomise_trials', 'matchType', 'validity', 'delaySOA'};

% Reading in experiments beginning with data/data_exp_55896 
directoryContents = dir('data/data_exp_55896*.csv');

fileNames = {directoryContents.name};
nFiles = length(fileNames);

rawdata = readtable(fileNames{1});

for fileInd = 2:nFiles
    newrawdata = readtable(fileNames{fileInd});
    % Append newrawdata to rawdata
    rawdata = [rawdata; newrawdata];
end
%%

if iscell(rawdata.ReactionTime)
    rawdata.ReactionTime = str2double(rawdata.ReactionTime);
end

tmpUniqueParticipants = rawdata.ParticipantPrivateID;
tmpUniqueParticipants(isnan(tmpUniqueParticipants)) = [];
uniqueParticipants = unique(tmpUniqueParticipants);
nUniqueParticipants = length(uniqueParticipants);

numCorrect = 0;

% medianArray = zeros(nUniqueParticipants, 1);
% participantAccuracy = zeros(nUniqueParticipants, 1);

validShortRtArray = zeros(nUniqueParticipants, 1);
validLongRtArray = zeros(nUniqueParticipants, 1);

invalidShortRtArray = zeros(nUniqueParticipants, 1);
invalidLongRtArray = zeros(nUniqueParticipants, 1);

validShortAccuracyArray = zeros(nUniqueParticipants, 1);
validLongAccuracyArray = zeros(nUniqueParticipants, 1);

invalidShortAccuracyArray = zeros(nUniqueParticipants, 1);
invalidLongAccuracyArray = zeros(nUniqueParticipants, 1);

dataFrame0 = rawdata(:, neededColumns);

% Array for overall Participant Accuracy and Reaction Time

overallAccuracyArray = zeros(nUniqueParticipants, 1);
overallRTArray = zeros(nUniqueParticipants, 1);

for currentParticipantInd = 1:nUniqueParticipants

    participantPrivateID = uniqueParticipants(currentParticipantInd);

    currentParticipantRowsBool = dataFrame0.ParticipantPrivateID == participantPrivateID;

    dataFrame1 = dataFrame0(currentParticipantRowsBool, :);

    dataFrame2 = dataFrame1(strcmp(dataFrame1.ScreenName, 'Probe'), :);
    dataFrame2.ScreenName = [];

    % Save dataFrame4 into a structure
    dataFrame3 = dataFrame2(dataFrame2.randomise_trials <= 10, :);

    % Remove trials based on extreme reaction times
    dataFrame4 = dataFrame3(dataFrame3.ReactionTime < tooSlow & ...
        dataFrame3.ReactionTime > tooFast, :);

    % Only consider reaction times of Correct trials
    dataFrameCorrect = dataFrame4(dataFrame4.Correct == 1, :);

    % Calculate overall median reaction time and mean accuracy
    test = 0;
    overallAccuracy = mean(dataFrame4.Correct);
    overallRT = median(dataFrame4.ReactionTime);

    overallAccuracyArray(currentParticipantInd) = overallAccuracy;
    overallRTArray(currentParticipantInd) = overallRT;

    % Separate valid and invalid trials as well as short vs long delay trials
    validTrials = dataFrame4(strcmp(dataFrame4.validity, 'valid'), :);
    invalidTrials = dataFrame4(strcmp(dataFrame4.validity, 'invalid'), :);

    validShortTrials = validTrials(eq(validTrials.delaySOA, 1150), :);
    validLongTrials = validTrials(eq(validTrials.delaySOA, 2350), :);

    invalidShortTrials = invalidTrials(eq(invalidTrials.delaySOA, 1150), :);
    invalidLongTrials = invalidTrials(eq(invalidTrials.delaySOA, 2350), :);

    validShortRtArray(currentParticipantInd) = median(validShortTrials.ReactionTime);
    validLongRtArray(currentParticipantInd) = median(validLongTrials.ReactionTime);

    invalidShortRtArray(currentParticipantInd) = median(invalidShortTrials.ReactionTime);
    invalidLongRtArray(currentParticipantInd) = median(invalidLongTrials.ReactionTime);

    validShortAccuracyArray(currentParticipantInd) = mean(validShortTrials.Correct);
    validLongAccuracyArray(currentParticipantInd) = mean(validLongTrials.Correct);

    invalidShortAccuracyArray(currentParticipantInd) = mean(invalidShortTrials.Correct);
    invalidLongAccuracyArray(currentParticipantInd) = mean(invalidLongTrials.Correct);

end

%% Combining arrays into one master array for Accuracy and Median for Short/Long and Valid/Invalid

MasterArray = cat(2, validShortRtArray, validLongRtArray, invalidShortRtArray, invalidLongRtArray, ...
    validShortAccuracyArray, validLongAccuracyArray, invalidShortAccuracyArray, invalidLongAccuracyArray);

%% Filtering Participants out due to extreme values and editing Master Array to reflect this

tooInaccurate = overallAccuracyArray < 0.85;
tooSlow = overallRTArray > 1000;

removeExtremeBool = tooInaccurate | tooSlow;

MasterArray(removeExtremeBool, :) = [];

%% Making Master Table and Master Accuracy and RT Arrays 

MasterTable = array2table(MasterArray, ...
    'VariableNames',{'ValidShortRt', 'ValidLongRt', 'InvalidShortRt', 'InvalidLongRt', ...
    'ValidShortAcc', 'ValidLongAcc', 'InvalidShortAcc', 'InvalidLongAcc'});

MasterAccuracyArray = MasterArray(:, 5:8);
MasterRTArray = MasterArray(:, 1:4);

%% Calculating Standard Error and Variance for Each of 8 Means and filtering participants
% out if they are four standard deviations away from the mean

% Calculating standard error correctly for within-subjects design by
% taking the average values and subtracting from each participant before
% taking the standard deviaion
stdErrorRT = std(MasterRTArray - mean(MasterRTArray, 2)) / sqrt(height(MasterRTArray));
stdErrorAcc = std(MasterAccuracyArray - mean(MasterAccuracyArray, 2)) / sqrt(height(MasterAccuracyArray));

variance = var(MasterArray);

% RTBool = (MasterRTArray < (mean(MasterRTArray, 1) - 4 * std(MasterRTArray - mean(MasterRTArray, 1)))) ... 
%     | (MasterRTArray > (mean(MasterRTArray, 1) + 4 * std(MasterRTArray - mean(MasterRTArray, 1))));
% 
% AccBool = (MasterAccuracyArray < (mean(MasterAccuracyArray, 1) - 4 * std(MasterAccuracyArray - mean(MasterAccuracyArray, 1)))) ... 
%     | (MasterAccuracyArray > (mean(MasterAccuracyArray, 1) + 4 * std(MasterAccuracyArray - mean(MasterAccuracyArray, 1))));

% removeSdBool = RTBool | AccBool;
% 
% MasterArray(removeSdBool, :) = [];

%% Checking Mean Accuracy and Reaction Time for Valid vs Invalid and Short vs Long Across All Participants

meanRtShortValid = mean(MasterArray(:, 1));
meanRtLongValid = mean(MasterArray(:, 2));
meanRtShortInvalid = mean(MasterArray(:, 3));
meanRtLongInvalid = mean(MasterArray(:, 4));

meanAccuracyShortValid = mean(MasterArray(:, 5));
meanAccuracyLongValid = mean(MasterArray(:, 6));
meanAccuracyShortInvalid = mean(MasterArray(:, 7));
meanAccuracyLongInvalid = mean(MasterArray(:, 8));

MasterRtMeanArray = cat(2, meanRtShortValid, meanRtLongValid, meanRtShortInvalid, meanRtLongInvalid);
MasterAccuracyMeanArray = cat(2, meanAccuracyShortValid, meanAccuracyLongValid, meanAccuracyShortInvalid, meanAccuracyLongInvalid);

MasterRtMeanTable = array2table(MasterRtMeanArray, ...
    'VariableNames',{'ValidShort', 'ValidLong', 'InvalidShort', 'InvalidLong'});

MasterAccuracyMeanTable = array2table(MasterAccuracyMeanArray, ...
    'VariableNames',{'ValidShort', 'ValidLong', 'InvalidShort', 'InvalidLong'});

%% Scatterplots
figure('Name', 'Mean Accuracy vs. Median Reaction Time'); clf

subplot(2,2,1)

validScatter = scatter(MasterArray(:, 5), MasterArray(:, 1));
title('Valid Short')
xlabel('Accuracy')
ylabel('Reaction Time (ms)')

subplot(2,2,2)

validScatter = scatter(MasterArray(:, 6), MasterArray(:, 2));
title('Valid Long')
xlabel('Accuracy')
ylabel('Reaction Time (ms)')

subplot(2,2,3)

validScatter = scatter(MasterArray(:, 7), MasterArray(:, 3));
title('Invalid Short')
xlabel('Accuracy')
ylabel('Reaction Time (ms)')

subplot(2,2,4)

invalidScatter = scatter(MasterArray(:, 8), MasterArray(:, 4));
title('Invalid Long')
xlabel('Accuracy')
ylabel('Reaction Time (ms)')
%% Histograms

figure('Name', 'Mean Accuracy Across Participants'); clf

subplot(2,2,1)
histogram(MasterArray(:, 5), 10);
title('Valid Short')
xlabel('Accuracy')
ylabel('Number of Participants')

subplot(2,2,2)
histogram(MasterArray(:, 6), 10);
title('Valid Long')
xlabel('Accuracy')
ylabel('Number of Participants')

subplot(2,2,3)
histogram(MasterArray(:, 7), 10);
title('Invalid Short')
xlabel('Accuracy')
ylabel('Number of Participants')

subplot(2,2,4)
histogram(MasterArray(:, 8), 10);
title('Invalid Long')
xlabel('Accuracy')
ylabel('Number of Participants')

figure('Name', 'Median Reaction Time Across Participants')

subplot(2,2,1)
histogram(MasterArray(:, 1), 10);
title('Valid Short')
xlabel('Reaction Time (ms)')
ylabel('Number of Participants')

subplot(2,2,2)
histogram(MasterArray(:, 2), 10);
title('Valid Long')
xlabel('Reaction Time (ms)')
ylabel('Number of Participants')

subplot(2,2,3)
histogram(MasterArray(:, 3), 10);
title('Invalid Short')
xlabel('Reaction Time (ms)')
ylabel('Number of Participants')

subplot(2,2,4)
histogram(MasterArray(:, 4), 10);
title('Invalid Long')
xlabel('Reaction Time (ms)')
ylabel('Number of Participants')

%% Bar Graphs 

RTerr = [stdErrorRT(1) stdErrorRT(2) stdErrorRT(3) stdErrorRT(4)];
AccErr = [stdErrorAcc(1) stdErrorAcc(2) stdErrorAcc(3) stdErrorAcc(4)];

figure(); clf
bar(MasterRtMeanArray);
set(gca,'XMinorTick','on','YMinorTick','on','xticklabel',{'Valid Short','Valid Long','Invalid Short', 'Invalid Long'})
ylabel('Reaction Time (ms)')
title('Mean Reaction Time Across Different Conditions', 'FontSize', 14)
ylim([550 700])
hold on
errorbar(MasterRtMeanArray, RTerr, '.')
grid on
grid minor
set(gca,'gridlinestyle','-')
set(gca,'XMinorGrid','on')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridLineStyle','-')
grid on

figure(); clf
bar(MasterAccuracyMeanArray);
set(gca,'XMinorTick','on','YMinorTick','on','xticklabel',{'Valid Short','Valid Long','Invalid Short', 'Invalid Long'})
ylabel('Accuracy')
title('Mean Accuracy Across Different Conditions', 'FontSize', 14)
ylim([0.9 1])
hold on
errorbar(MasterAccuracyMeanArray, AccErr, '.')
grid on
grid minor
set(gca,'XMinorGrid','on')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridLineStyle','-')
grid on

%% Do Stats 

% Do T-test of Validity at short/long delay between 
% two different validities

% T-Test of Validity at Short Delay between Valid/Invalid (RT)

[~, p, ~, stats] = ttest(MasterRTArray(:, 1), MasterRTArray(:, 3));
disp(p)
disp(stats)

% T-Test of Validity at Long Delay between Valid/Invalid (RT)
[~, p, ~, stats] = ttest(MasterRTArray(:, 2), MasterRTArray(:, 4));
disp(p)
disp(stats)

% T-Test of Delay at Valid between Short/Long (RT)
[~, p, ~, stats] = ttest(MasterRTArray(:, 1), MasterRTArray(:, 2));
disp(p)
disp(stats)

% T-Test of Delay at Invalid between Short/Long (RT)
[~, p, ~, stats] = ttest(MasterRTArray(:, 3), MasterRTArray(:, 4));
disp(p)
disp(stats)

%% 

% Two-Way Mixed Anova for Reaction Time

RTdata = MasterRTArray(:, [1 3 2 4])';  % validity order, 4 x subjects
% (changing to VE, IE, VL, IL)

RTdataR = reshape(RTdata, [2, 2, size(RTdata, 2)]); % validity x delay x subjects
RTdataRP = permute(RTdataR, [3, 1, 2]); % subjects x validity x delay
RTmixed_anova_table = simple_mixed_anova(RTdataRP, [], {'Validity', 'Delay'}, {})

% Two-Way Mixed Anova for Accuracy

ACCdata = MasterAccuracyArray(:, [1 3 2 4])'; 
ACCdataR = reshape(ACCdata, [2, 2, size(ACCdata, 2)]);
ACCdataRP = permute(ACCdataR, [3, 1, 2]);
ACCmixed_anova_table = simple_mixed_anova(ACCdataRP, [], {'Validity', 'Delay'}, {})


