function [NRParams,fVal,modelResponseStruct] = fitResponse(obj,thePacket,varargin)
% Fit method for the tfeNakaRushtonDirection class.
%
% Syntax:
%     [NRParams,fVal,modelResponseStruct] = fitResponse(obj,thePacket,varargin)
%
% Descriptoin:
%     This is a custom fit method because this object allows us to impose
%     various constraints on the parameters across directions, and those
%     are not implemented in the standard fit method of tfe or tfeQCM.
%
% Inputs:
%   thePacket          - A valid packet
%
% Outputs:
%   NRParams           - Fit parameters
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

% History;
%  01/01/19  dhb   Take advantage of fact that tfe.fitResponse can now receive
%                   constraints.

%% Parse vargin for options passed here
%
% Setting 'KeepUmatched' to true means that we can pass the varargin{:})
% along from a calling routine without an error here, if the key/value
% pairs recognized by the calling routine are not needed here.
p = inputParser; p.KeepUnmatched = true; p.PartialMatching = false;
p.addRequired('thePacket',@isstruct);
p.addParameter('initialParams',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('fminconAlgorithm','interior-point',@(x) (isempty(x) | ischar(x)));
p.addParameter('fitErrorScalar',1000,@isnumeric);
p.parse(thePacket,varargin{:});

%% Check packet validity
if (~obj.isPacket(thePacket))
    error('The passed packet is not valid for this model');
else
    switch (obj.verbosity)
        case 'high'
            fprintf('valid\n');
    end
end

%% Set initial values and reasonable bounds on parameters
[initialNRParams,vlbNRParams,vubNRParams] = obj.defaultParams;
if (~isempty(p.Results.initialParams))
    initialNRParams = p.Results.initialParams;
end

%% Set up search bounds
ampLowBound = 0; ampHighBound = 5;
minLagLowBound = 0.005; minLagBound = 10;
scaleLowBound = 0.01; scaleHighBound = 10;


% Pack bounds into vector form of parameters.
for ii = 1:obj.nDirections
    vlbNRParams(ii).amplitude = ampLowBound;
    vlbNRParams(ii).minLag = minLagLowBound;
    vlbNRParams(ii).scale = scaleLowBound;
end
for ii = 1:obj.nDirections
    vubNRParams(ii).amplitude = ampHighBound;
    vubNRParams(ii).minLag = minLagBound;
    vubNRParams(ii).scale = scaleHighBound;
end

%% Set up linear parameter constraints
%
% This is a little tricky. We need to know the order
% of the parameters in the parameter vector, and then
% we set 1,-1 pairs between the entries for the first
% function and those for each subsequent function.
%
% I don't see any easy way around knowing the order in
% which the parameters are packed into vectors here.
tempvec = obj.paramsToVec(vlbNRParams(1));
nParams = length(tempvec);
if (obj.nDirections > 1)
    % Build constraint matrix if there is more than one direction.
    %
    % Initialize
    Aeq = [];
    beq = [];
    eqRowIndex = 1;
    
    % Common amplitude constraints
    if (obj.commonAmplitude)
        paramIndex = 1;
        for ii = 2:obj.nDirections
            Aeq(eqRowIndex,:) = zeros(1,nParams*length(vlbNRParams'));
            Aeq(eqRowIndex,paramIndex) = 1;
            Aeq(eqRowIndex,(ii-1)*nParams+paramIndex) = -1;
            beq(eqRowIndex) = 0;
            eqRowIndex = eqRowIndex+1;
        end
    end
    
    % Common semi-saturation constant constraints
    if (obj.commonSemi)
        paramIndex = 2;
        for ii = 2:obj.nDirections
            Aeq(eqRowIndex,:) = zeros(1,nParams*length(vlbNRParams'));
            Aeq(eqRowIndex,paramIndex) = 1;
            Aeq(eqRowIndex,(ii-1)*nParams+paramIndex) = -1;
            beq(eqRowIndex) = 0;
            eqRowIndex = eqRowIndex+1;
        end
    end
    
    % Common exponent constraints
    if (obj.commonExp)
        paramIndex = 3;
        for ii = 2:obj.nDirections
            Aeq(eqRowIndex,:) = zeros(1,nParams*length(vlbNRParams'));
            Aeq(eqRowIndex,paramIndex) = 1;
            Aeq(eqRowIndex,(ii-1)*nParams+paramIndex) = -1;
            beq(eqRowIndex) = 0;
            eqRowIndex = eqRowIndex+1;
        end
    end
    
    % Common offset constraints
    if (obj.commonOffset)
        paramIndex = 4;
        for ii = 2:obj.nDirections
            Aeq(eqRowIndex,:) = zeros(1,nParams*length(vlbNRParams'));
            Aeq(eqRowIndex,paramIndex) = 1;
            Aeq(eqRowIndex,(ii-1)*nParams+paramIndex) = -1;
            beq(eqRowIndex) = 0;
            eqRowIndex = eqRowIndex+1;
        end
    end
else
    % If there is only one independent direction, then there is no
    % constraint across directions to be had.
    Aeq = [];
    beq = [];
end

%% Fit using tfe method
[NRParams,fVal,modelResponseStruct] = fitResponse@tfe(obj,thePacket,varargin{:},...
        'initialParams',initialNRParams,'vlbParams',vlbNRParams,'vubParams',vubNRParams,...
        'Aeq',Aeq,'beq',beq,...
        'fminconAlgorithm',p.Results.fminconAlgorithm,...
        'fitErrorScalar',p.Results.fitErrorScalar);

end
        

