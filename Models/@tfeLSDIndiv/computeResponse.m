function modelResponseStruct = computeResponse(obj,params,stimulusStruct,kernelStruct,varargin)
% modelResponseStruct = computeResponse(obj,params,stimulusStruct,kernelStruct,varargin)
%
% Compute method for the quadratic color model with stimuli in
% direction/contrast form.
%
% Optional key/value pairs
%   'addNoise' - true/false (default false).  Add noise to computed
%                response?  Useful for simulations.

%% Parse input
%
% Setting 'KeepUmatched' to true means that we can pass the varargin{:})
% along from a calling routine without an error here, if the key/value
% pairs recognized by the calling routine are not needed here.
p = inputParser; p.KeepUnmatched = true;
p.addRequired('params',@isstruct);
p.addRequired('stimulusStruct',@isstruct);
p.addRequired('kernelStruct',@(x)(isempty(x) || isstruct(x)));
p.parse(params,stimulusStruct,kernelStruct,varargin{:});
params = p.Results.params;

%% Convert stimulus values to useful format

directions = atand(stimulusStruct.values(2,:)./stimulusStruct.values(1,:));
contrasts = vecnorm(stimulusStruct.values);

%% Figure out passed directions and make sure they match up with directions
% this was initialized with.
[indDirectionsTemp,directionIndices] = tfeCTMParseDirections(directions);
nIndDirections = size(indDirectionsTemp,2);

%  NOTE: MB:  This needs to be changed to allows for unused directions but
%  still checks for unkown directions. This applies to the number of
%  indicies below
if (nIndDirections ~= obj.nDirections)
    error('Passed stimulus array does not have same number of directions as object');
end

%% Match up directions found in stimuli with those that we have from initializtion
objDirectionIndices = zeros(nIndDirections,1);
for ii = 1:nIndDirections
    for jj = 1:obj.nDirections
        if (max(abs(indDirectionsTemp(:,ii) - obj.directions(:,jj))) < 1e-10)
            objDirectionIndices(ii) = jj;
        end
    end
end
if (any(objDirectionIndices == 0))
    error('A passed stimulus direction is not in set of directions we know about');
end
checkIndices = unique(objDirectionIndices);
if (length(checkIndices) ~= obj.nDirections)
    error('One direction in object set not in passed stimulus array')
end

%% Parse stimuli in terms of which stimulus belongs to which direction
%
% Match up order with parameters for initialized directions
for ii = 1:nIndDirections
    theDirection = objDirectionIndices(ii);
    indDirectionIndices{theDirection} = directionIndices{ii};
    indDirectionDirections{theDirection} = indDirectionsTemp(:,ii);
    indDirectionContrasts{theDirection} = contrasts(directionIndices{ii});
end

%% Get neural response from NR forward model
lagResponse = tfeLSDIndivForward(params,indDirectionContrasts);

%% Make the neural response structure
modelResponseStruct.timebase = stimulusStruct.timebase;
modelResponseStruct.values = lagResponse(:)';

%% Optional, convolve with a passed kernel
modelResponseStruct = obj.applyKernel(modelResponseStruct,kernelStruct,varargin{:});

end
