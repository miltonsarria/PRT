function result = prtTestClusterKmeans
result = true;

% BASELINE generation, uncomment to run to generate new baseline
% Run numIter times to get idea distribution of percentage
% Pick off the lowest % correct and use that as baseline
% numIter = 10;
% percentCorr = zeros(1,numIter);
% for i = 1:numIter
%     TestDataSet = prtDataGenUnimodal;
%     TrainingDataSet = prtDataGenUnimodal;
%     
%     cluster = prtClusterKmeans;
%     cluster.nClusters = 2;
%     cluster.internalDecider = prtDecisionMap;
%     cluster = cluster.train(TrainingDataSet);
%     classified = run(cluster, TestDataSet);
%     classes  = classified.getX -1 ;
%     % Check percent corr, if < 50%, classes are probably opposite from what
%     % they should be, so, invert;
%     pCorr = prtScorePercentCorrect(classes,TestDataSet.getTargets);
%     if pCorr < .5
%         pCorr = prtScorePercentCorrect(~classes,TestDataSet.getTargets);
%     end
%     percentCorr(i) = pCorr;
% end
% min(percentCorr)


%% Classification correctness test.
baselinePercentCorr = .95;

TestDataSet = prtDataGenUnimodal;
TrainingDataSet = prtDataGenUnimodal;
cluster = prtClusterKmeans;
cluster.nClusters = 2;


% check that the includes decision flag is correctly set
if ~isequal(cluster.includesDecision, 0)
   disp('prtCluster Kmeans includes decision flag incorrectly set to true')
   result = false;
end


cluster.internalDecider = prtDecisionMap;
cluster = cluster.train(TrainingDataSet);
classified = run(cluster, TestDataSet);
classes  = classified.getX -1 ;
% Check percent corr, if < 50%, classes are probably opposite from what
% they should be, so, invert;
pCorr = prtScorePercentCorrect(classes,TestDataSet.getTargets);
if pCorr < .5
    pCorr = prtScorePercentCorrect(~classes,TestDataSet.getTargets);
end


result = result & (pCorr > baselinePercentCorr);
if (pCorr < baselinePercentCorr)
    disp('prtClusterKmeans below baseline')
    result = false;
end

% check that the includes decision flag is correctly set
if ~isequal(cluster.includesDecision, 1)
   disp('prtCluster Kmeans includes decision flag incorrectly set to false')
   result = false;
end

%% Check that cross-val and k-folds work


% cross-val
keys = mod(1:400,2);
crossVal = cluster.crossValidate(TestDataSet,keys);
%[garbage,classInds] = max(crossVal.getX(),[],2);

classes  = classified.getX -1 ;
% Check percent corr, if < 50%, classes are probably opposite from what
% they should be, so, invert;
pCorr = prtScorePercentCorrect(classes,TestDataSet.getTargets);
if pCorr < .5
    pCorr = prtScorePercentCorrect(~classes,TestDataSet.getTargets);
end


% Check percent corr, if < 50%, classes are probably opposite from what
% they should be, so, invert;
pCorr = prtScorePercentCorrect(classes,TestDataSet.getTargets);
if pCorr < .5
    pCorr = prtScorePercentCorrect(~classes,TestDataSet.getTargets);
end


if (pCorr < baselinePercentCorr)
    disp('prtClusterKmeans cross-val below baseline')
    result = false;
end


%% Error checks

error = true;  % We will want all these things to error

try
    cluster.internalDecider = prtDecisionBinaryMinPe;
    disp('prtClusterKmeans, decider set to something other than MAP')
end
    

%% Object construction
% We want these to be non-errors
noerror = true;

try
    cluster = prtClusterKmeans('nClusters', 4);
catch
    noerror = false;
    disp('kmeans cluster param/val fail')
end

try
    TestDataSet = prtDataGenMary;
    
    cluster = prtClusterKmeans;
    cluster.internalDecider = prtDecisionMap;
  
    cluster = cluster.train(TrainingDataSet);
    cluster.plot();
    close
catch
    noerror = false;
    disp('k-meanse plot fail')
    close
end
%%
result = result & error & noerror;
