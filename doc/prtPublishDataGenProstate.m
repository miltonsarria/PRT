%% prtDataGenProstate
%
% This data generation method can be used to generate a data set containing
% measurements of prostate cancer subjects, including medical treatments
% and effectiveness.  This data is freely available here:
%
% http://lib.stat.cmu.edu/S/Harrell/data/descriptions/prostate.html
%
% The output of this function is a prtDataSetClass.
%
% <matlab:doc('prtDataGenProstate') M-file documentation>
%
% <prtPublishDataGen.html prtDataGen Functions>
%
% <prtPublishGettingStarted.html Getting Started> 
%

ds = prtDataGenProstate;
pca = prtPreProcPca;
pca = train(pca,ds);
dsPca = pca.run(ds);
plot(dsPca);

%%
% See also: 
% <prtPublishDataGenBimodal.html prtDataGenBimodal>
% <prtPublishDataGenCircles.html prtDataGenCircles>
% <prtPublishDataGenIris.html prtDataGenIris>
% <prtPublishDataGenManual.html prtDataGenManual>
% <prtPublishDataGenMary.html prtDataGenMary>
% <prtPublishDataGenNoisySinc.html prtDataGenNoisySinc>
% <prtPublishDataGenOldFaithful.html prtDataGenOldFaithful>
% <prtPublishDataGenPca.html prtDataGenPca>
% <prtPublishDataGenProstate.html prtDataGenProstate>
% <prtPublishDataGenSinc.html prtDataGenSinc>
% <prtPublishDataGenSpiral.html prtDataGenSpiral>
% <prtPublishDataGenSpiral3.html prtDataGenSpiral3>
% <prtPublishDataGenSwissRoll.html prtDataGenSwissRoll>
% <prtPublishDataGenUnimodal.html prtDataGenUnimodal>
% <prtPublishDataGenXor.html prtDataGenXor>
% <prtPublishDataGenBimodal prtDataGenBimodal>
% <prtPublishDataGenCircles prtDataGenCircles>
% <prtPublishDataGenIris prtDataGenIris>
% <prtPublishDataGenManual prtDataGenManual>
% <prtPublishDataGenMary prtDataGenMary>
% <prtPublishDataGenNoisySinc prtDataGenNoisySinc>
% <prtPublishDataGenOldFaithful prtDataGenOldFaithful>
% <prtPublishDataGenPca prtDataGenPca>
% <prtPublishDataGenProstate prtDataGenProstate>
% <prtPublishDataGenSinc prtDataGenSinc>
% <prtPublishDataGenSpiral prtDataGenSpiral>
% <prtPublishDataGenSpiral3 prtDataGenSpiral3>
% <prtPublishDataGenSwissRoll prtDataGenSwissRoll>
% <prtPublishDataGenUnimodal prtDataGenUnimodal>
% <prtPublishDataGenXor prtDataGenXor>