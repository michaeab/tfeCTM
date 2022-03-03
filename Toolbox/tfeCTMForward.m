function [lagsFromParams] = tfeCTMForward(params,stimuli)
% Compute CTM forward model
%
% Synopsis
%    [responses,quadraticFactors] = tfeCTMForward(params,stimuli)
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

%% Get the ellipsoid parameters in cannonical form
dimension = size(stimuli,1);
if (dimension == 2)
    %The one mechanism model
   if length(params) == 4
        % Get the weight linear mechanism output
        m_hats = abs(params(1).*stimuli(1,:) - params(2).*stimuli(2,:));
   elseif  length(params) == 5
        m_mech1 = abs(params(1).*stimuli(1,:) - params(2).*stimuli(2,:));
        m_mech2 = abs(params(3).* params(2).*stimuli(1,:) + params(3).*params(1).*stimuli(2,:));
        
        m_hats = [m_mech1;m_mech2];
   else
          error('Must be either 1 or 2 mechanisms'); 
   end
    
    % take the max of the mechanism outputs
    m_Max = max(m_hats,[],1);
elseif (dimension == 3)
    % Loop over the number of mechaisms
    for ii = (size(params,1)-2)/2
        % Get the weight linear mechanism output
        m_hats(ii,:) = abs(params((3*ii)-2).*stimuli(1,:) + params((3*ii)-1).*stimuli(2,:) + params(3*ii).*stimuli(3,:));
    end
    
    % take the max of the mechanism outputs
    m_Max = max(m_hats,[],1);
else
    error('Dimension must be 2 or 3');
end

% Convert mechanism output to lags
lagsFromParams =  params(end-1) +  params(end).* exp(-1.*m_Max);





