function [paramsFit,fVal,modelResponseStruct] = fitResponse(obj,thePacket,varargin)
% [paramsFit,fVal,modelResponseStruct] = fitResponse(obj,thePacket,varargin)
%
% Fit method for the tfeQCM class.  This overrides the tfe method, for the
% main purpose of allowing us to have multiple starting points chosen
% sensibly for the QCM model.
%
% Also eventually will allow us to put on some parameter constraints that
% are not generic.
%
% Inputs:
%   thePacket          - A valid packet
%
% Outputs:
%   paramsFit          - Fit parameters
%   fVal               - Fit error.
%   predictedResponse  - Response predicted from fit
%
% Optional key/value pairs
%  Those understood by tfe.fitResponse with the following adjustments.
%
% 'fminconAlgorithm'     - String (default 'interior-point'). If set to a string,
%                           passed on as algorithm in options to fmincon.
%                           Can be empty or any algorithm string understood
%                           by fmincon.
%                              [] - Use fmincon's current default algorithm
%                              'active-set' - Active set algorithm
%                              'interior-point' - Interior point algorithm.
%  'fitErrorScalar'       - Computed fit error is multiplied by this before
%                           return.  Sometimes getting the objective
%                           function onto the right scale makes all the
%                           difference in fitting. Passed along as an
%                           option to the fitError method, but overrides
%                           the fitError's default value, Default here is
%                           1000.
%  
%% Parse vargin for options passed here
%
% Setting 'KeepUmatched' to true means that we can pass the varargin{:})
% along from a calling routine without an error here, if the key/value
% pairs recognized by the calling routine are not needed here.
p = inputParser; p.KeepUnmatched = true; p.PartialMatching = false;
p.addRequired('thePacket',@isstruct);
p.addParameter('initialParams',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('fitErrorScalar',1000,@isnumeric);
p.addParameter('fminconAlgorithm','active-set',@(x) (isempty(x) | ischar(x)));
p.parse(thePacket,varargin{:});

%% Initial parameters
[initialParams,vlbParams,vubParams] = obj.defaultParams;
if (~isempty(p.Results.initialParams))
    initialParams = p.Results.initialParams;
end   
         
% Some custom fitting
if (obj.dimension == 2)
    
    % Setting the fitting flag allows the eventually called
    % computeResponse routine to take some shortcuts that we
    % don't want taken in general.  But we care enough about execution
    % speed to do this.  Be sure to set stimuli back to empty when setting
    % flag back to false.  The computeResponse routine will compute it when
    % the fitting flag is true and it is empty.
    obj.fitting = true; obj.stimuli = [];
    [paramsFit,fVal,modelResponseStruct] = fitResponse@tfe(obj,thePacket,varargin{:},...
        'initialParams',initialParams,'vlbParams',vlbParams,'vubParams',vubParams,...
        'fitErrorScalar',p.Results.fitErrorScalar,'fminconAlgorithm',p.Results.fminconAlgorithm);
    obj.fitting = false;
    obj.stimuli = [];
   
    % Use this to check error value as it sits here
    fValCheck = obj.fitError(obj.paramsToVec(paramsFit),thePacket,varargin{:},'fitErrorScalar',p.Results.fitErrorScalar);
    if (fValCheck ~= fVal)
        error('Cannot compute the same fit error twice the same way. Check.');
    end

else
     [paramsFit,fVal,modelResponseStruct] = fitResponse@tfe(obj,thePacket,varargin{:});
end   

end



