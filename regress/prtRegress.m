classdef prtRegress < prtAction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prtRegress is an abstract base class for all regression objects.

    properties
        plotOptions = prtRegress.initializePlotOptions(); % Plotting Options
    end
    
    properties (SetAccess = protected)
        isSupervised = true;
    end
    
    methods (Hidden = true)
        function featureNames = updateFeatureNames(obj,featureNames)
            for i = 1:length(featureNames)
                featureNames{i} = sprintf('%s Output_{%d}',obj.nameAbbreviation,i);
            end
        end
    end    
    
    methods
        function obj = prtRegress()
            % As an action subclass we must set the properties to reflect
            % our dataset requirements
            obj.classInput = 'prtDataSetRegress';
            obj.classOutput = 'prtDataSetRegress';
            obj.classInputOutputRetained = true;
        end        
        
        function varargout = plot(Obj)
            % PLOT  Plot the output confidence of a prtClass object
            %
            %   OBJ.plot() plots the output confidence of a prtClass
            %   object. This function only operates when the dimensionality
            %   of dataset is 3 or less. When verboseStorage is set to
            %   'true', the training data points are also displayed on the
            %   plot.
            
            
            assert(Obj.isTrained,'Regressor must be trained before it can be plotted.');
            assert(Obj.dataSetSummary.nFeatures < 2, 'nFeatures in the training dataset must be 1');
            
            [OutputDataSet, linGrid] = runRegressorOnGrid(Obj);
            
            colors = Obj.plotOptions.colorsFunction(Obj.dataSetSummary.nTargetDimensions);
            lineWidth = Obj.plotOptions.lineWidth;
            HandleStructure.regressorPlotHandle = plot(linGrid,OutputDataSet.getObservations,'color',colors(1,:),'lineWidth',lineWidth);
            
            holdState = get(gca,'nextPlot');
            if ~isempty(Obj.dataSet)
                hold on
                HandleStructure.dataSetPlotHandle = plot(Obj.dataSet);
            end
            set(gca,'nextPlot',holdState);
            
            axis tight;
            title(Obj.name)
            
            varargout = {};
            if nargout > 0
                varargout = {HandleStructure};
            end
        end
        
        function [OutputDataSet, linGrid, gridSize] = runRegressorOnGrid(Obj, upperBounds, lowerBounds)
            
            if nargin < 3 || isempty(lowerBounds)
                lowerBounds = Obj.dataSetSummary.lowerBounds;
            end
            
            if nargin < 2 || isempty(upperBounds)
                upperBounds = Obj.dataSetSummary.upperBounds;
            end
            
            [linGrid, gridSize] = prtPlotUtilGenerateGrid(upperBounds, lowerBounds, Obj.plotOptions.nSamplesPerDim);
            
            OutputDataSet = run(Obj,prtDataSetRegress(linGrid));
        end
    end
    methods (Static, Hidden = true)
        function plotOptions = initializePlotOptions()
            plotOptions = prtOptionsGet('prtOptionsRegressPlot');
        end
    end
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%