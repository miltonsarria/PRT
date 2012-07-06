classdef prtRvIndependent < prtRv & prtRvMemebershipModel
    % prtRvIndependent  Independent random variables
    %
    %   RV = prtRvIndependent creates a prtRvIndependent object.
    %   prtRvIndependent objects enable the training of independent
    %   versions of a base random variable type on each column of a data
    %   set.  By default, prtRvIndependent assumes Gaussian distributed
    %   random variables.
    %
    %   RV = prtRvIndependent('baseRv', VALUE) specifies the type of RV to
    %   be trained on each column of input data.  VALUE must specify a
    %   valid prtRV class.  By default the baseRv field is a
    %   prtRvIndependent.
    %
    %   RV = prtRvIndependent(PROPERTY1, VALUE1,...) creates a
    %   prtRvIndependent object RV with properties as specified by
    %   PROPERTY/VALUE pairs.
    %
    %   A prtRvIndependent object inherits all properties from the prtRv
    %   class. In addition, it has the following properties:
    %
    %   baseRv          - A prtRv object specifying the type of classifier
    %                     to create independent versions of.
    %
    %   rvArray         - An array of objects of type baseRv that are
    %                     generated by calling the MLE method.  Can also be
    %                     manually set to specify particular parameters.
    %   
    %  A prtRvIndependent object inherits all methods from the prtRv class. 
    %  The MLE method can be used to estimate the distribution parameters from
    %  data.
    %
    %  Example:
    %
    %  dataSet    = prtDataGenUnimodal;   % Load a dataset consisting of 2
    %                                     % classes
    %  % Extract one of the classes from the dataSet
    %  dataSetOneClass = prtDataSetClass(dataSet.getObservationsByClass(1));
    %
    %  mvnRv = prtRvIndependent;            % Create a prtRvIndependent
    %                                       % object, with mvn components
    %  mvnRv = mvnRv.mle(dataSetOneClass);  % Compute the maximum
    %                                       % likelihood estimate from the
    %                                       % data
    %
    %  indepRv = prtRvIndependent;          %Created an indepednent RV
    %                                       %(default baseRv is gaussian)
    %
    %  indepRv = indepRv.mle(dataSetOneClass);
    %
    %  subplot(2,2,1); mvnRv.plotPdf; 
    %  hold on; dataSetOneClass.plot;
    %  title('MVN RV Pdf');
    %
    %  subplot(2,2,2); indepRv.plotPdf; 
    %  hold on; dataSetOneClass.plot;
    %  title('Independent Gaussian RV Pdf');
    %
    %
    %   See also: prtRv, prtRvGmm, prtRvMultinomial, prtRvUniform,
    %   prtRvUniformImproper, prtRvVq, prtRvDiscrete
    
    properties (SetAccess = private)
        name = 'Indepenent RV';
        nameAbbreviation = 'RVInd';
    end
    
    properties (SetAccess = protected)
        isSupervised = false;
        isCrossValidateValid = true;
    end    
    
    properties (Hidden = true, Dependent = true)
        nDimensions  % Number of dimensions
    end

    properties
        baseRv  % The base random variable
        rvArray  % The array of random variables
    end
    
    methods
        function R = prtRvIndependent(varargin)
            R.baseRv = prtRvMvn;
            R = constructorInputParse(R,varargin{:});
        end
        
        function R = mle(R,X)
            % MLE Compute the maximum likelihood estimate
            %
            % RV = RV.mle(X) computes the maximum likelihood estimate based
            % the data X. X should be nObservations x nDimensions.

            X = R.dataInputParse(X); % Basic error checking etc
            
            tempRvArray = repmat(R.baseRv,size(X,2),1);
            for i = 1:size(X,2)
                tempRvArray(i) = R.baseRv.mle(X(:,i));
            end
            R.rvArray = tempRvArray;
        end
        
        function vals = pdf(R,X)
            % PDF Output the pdf of the random variable evaluated at the points specified
            %
            % pdf = RV.pdf(X) returns  the pdf of the prtRv
            % object evaluated at X. X must be an N x nDims matrix, where
            % N is the number of locations to evaluate the pdf, and nDims
            % is the same as the number of dimensions, nDimensions, of the
            % prtRv object RV.
            
            [isValid, reasonStr] = R.isValid;
            assert(isValid,'PDF cannot yet be evaluated. This RV is not yet valid %s.',reasonStr);
            
            X = R.dataInputParse(X); % Basic error checking etc
            
            assert(size(X,2) == R.nDimensions,'Data, RV dimensionality missmatch. Input data, X, has dimensionality %d and this RV has dimensionality %d.', size(X,2), R.nDimensions)
            assert(isnumeric(X) && ndims(X)==2,'X must be a 2D numeric array.');
            
            vals = zeros(size(X));
            for i = 1:length(R.rvArray)
                vals(:,i) = R.rvArray(i).pdf(X(:,i));
            end
            vals = prod(vals,2);
        end
        
        function vals = logPdf(R,X)
            % LOGPDF Output the log pdf of the random variable evaluated at the points specified
            %
            % logpdf = RV.logpdf(X) returns the logarithm of value of the
            % pdf of the prtRv object evaluated at X. X must be an N x
            % nDims matrix, where N is the number of locations to evaluate
            % the pdf, and nDims is the same as the number of dimensions,
            % nDimensions, of the prtRv object RV.
            [isValid, reasonStr] = R.isValid;
            assert(isValid,'LOGPDF cannot yet be evaluated. This RV is not yet valid %s.',reasonStr);
            
            X = R.dataInputParse(X); % Basic error checking etc
            
            assert(size(X,2) == R.nDimensions,'Data, RV dimensionality missmatch. Input data, X, has dimensionality %d and this RV has dimensionality %d.', size(X,2), R.nDimensions)
            
            vals = zeros(size(X));
            for i = 1:length(R.rvArray)
                vals(:,i) = R.rvArray(i).logPdf(X(:,i));
            end
            vals = sum(vals,2);
        end
        
        function varargout = plotCdf(R,varargin)
            % PLOTCDF Plots the CDF of the prtRv
            assert(R.nDimensions == 1,'prtRvIndependent.plotCdf can only be used for 1D RV objects.');
            
            varargout = cell(nargout,1); 
            
            [varargout{:}] = plotCdf@prtRv(R,varargin{:});
                
        end
        
        function vals = cdf(R,X)
            % CDF Output the cdf of the random variable evaluated at the points specified
            %
            % cdf = RV.cdf(X) returns the value of the cdf of the prtRv
            % object evaluated at X. X must be an N x nDims matrix, where
            % N is the number of locations to evaluate the pdf, and nDims
            % is the same as the number of dimensions, nDimensions, of the
            % prtRv object RV.
            
            [isValid, reasonStr] = R.isValid;
            assert(isValid,'CDF cannot yet be evaluated. This RV is not yet valid %s.',reasonStr);
            
            assert(size(X,2) == R.nDimensions,'Data, RV dimensionality missmatch. Input data, X, has dimensionality %d and this RV has dimensionality %d.', size(X,2), R.nDimensions)
            
            vals = zeros(size(X));
            for i = 1:length(R.rvArray)
                vals(:,i) = R.rvArray(i).cdf(X(:,i));
            end
            vals = prod(vals,2);
        end
        
        function vals = draw(R,N)
            % DRAW  Draw random samples from the distribution described by the prtRv object
            %
            % VAL = RV.draw(N) generates N random samples drawn from the
            % distribution described by the prtRv object RV. VAL will be a
            % N x nDimensions vector, where nDimensions is the number of
            % dimensions of RV.
            
            assert(numel(N)==1 && N==floor(N) && N > 0,'N must be a positive integer scalar.')
            [isValid, reasonStr] = R.isValid;
            assert(isValid,'DRAW cannot yet be evaluated. This RV is not yet valid %s.',reasonStr);
            
            vals = zeros(N,R.nDimensions);
            for i = 1:size(vals,2)
                vals(:,i) = R.rvArray(i).draw(N);
            end
        end
    end
    
    methods (Hidden=true)
        function [val, reasonStr] = isValid(R)
            
            if numel(R) > 1
                val = false(size(R));
                for iR = 1:numel(R)
                    [val(iR), reasonStr] = isValid(R(iR));
                end
                return
            end
            
            val = ~isempty(R.rvArray);
            
            if val
                reasonStr = '';
            else
                reasonStr = 'because rvArray has not been set';
            end
        end
        
        function val = plotLimits(R)
            [isValid, reasonStr] = R.isValid;
            val = [];
            if isValid
                for i = 1:length(R.rvArray)
                    val = cat(2,val,R.rvArray(i).plotLimits);
                end
            else
                error('prtRvIndependent:plotLimits','Plotting limits can not be determined for this RV. It is not yet valid %s',reasonStr)
            end
        end
        
        function R = weightedMle(R,X,weights)
            assert(numel(weights)==size(X,1),'The number of weights must mach the number of observations.');
            
            tempRvArray = repmat(R.baseRv,size(X,2),1);
            for i = 1:size(X,2)
                tempRvArray(i) = R.baseRv.weightedMle(X(:,i),weights);
            end
            R.rvArray = tempRvArray;
        end
    end
    
    % Get methods
    methods
        function val = get.nDimensions(R)
            val = length(R.rvArray);
        end
        
        function val = get.baseRv(R)
            val = R.baseRv;
        end
        
        function val = get.rvArray(R)
            val = R.rvArray;
        end
    end
    
    % Set Methods
    methods
        function R = set.baseRv(R,val)
            
            if ~isa(val,'prtRv')
                error('prtRvIndependent:baseRv','baseRv must be a prtRv; provided value was a %s',class(val));
            end
            
            R.baseRv = val;
        end
        
        function R = set.rvArray(R,val)
            
            if ~isa(val(1),class(R.baseRv)); %Need to fix; ask kenny
                error('prtRvIndependent:rvArray','When manually setting prtRvIndependent rvArray field, type of rvArray must match type of baseRv; try setting baseRv prior to setting rvArray');
            end
            for j = 1:length(val)
                if ~val.isValid
                    error('prtRvIndependent:rvArray','Attempt to set prtRvIndependent rvArray field using rv array containing invalid RVs; rvArray should contain only trained RVs');
                end
            end
            R.rvArray = val;
        end
        
    end
end

