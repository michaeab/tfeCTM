function [lagsFromParams] = tfeCTMIndivForward(params,stimuli,varargin)
% Compute CTM forward model
%
% Synopsis
%    [responses,quadraticFactors] = tfeCTMIndivForward(params,stimuli)
%
% Description:
%    Take stimuli and compute CTM responses.
%
% Inputs:
%      params        - CTM model parameter struct
%      stimuli       - Stimuli, with stimulus contrasts in columns
%
% Outputs:
%      responses     - Row vector of responses
%

% History:
%   11/09/21  mab   wrote it (from tfeQCM template).


% When paramsToVec is working write a parameter check
% %% Check parameterization
% if (~tfeCTMCheckParams(params))
%     error('Bad values in CTM parameters structure');
% end

p = inputParser; p.KeepUnmatched = true;
p.addRequired('params',@isvector);
p.addRequired('stimuli',@ismatrix);
p.addParameter('dimension',2,@isnumeric);
p.addParameter('numMechanisms',2,@isnumeric);

p.parse(params,stimuli,varargin{:});
params = p.Results.params;

%% Get the ellipsoid parameters in cannonical form
dimension   = p.Results.dimension;

paramsMat = parmas;
if (dimension == 2)
  for ii = 1:nDirections
      lagsFromParams(:,ii) = paramsMat(1,ii)*exp(-1 * contrast * paramsMat(2,ii)) + params(3,ii);
  end
elseif (dimension == 3)
    error('3 Dimension case to come');
else
    error('Dimension must be 2 or 3');
end






