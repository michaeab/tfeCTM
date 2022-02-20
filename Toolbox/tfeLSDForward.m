function [pcFromParams] = tfeCTMForward(params,stimuli)
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
    % Loop over the number of mechaisms
    
    for ii = 1:(size(params,1)-2)/2
        
        % Get the weight linear mechanism output
        m_hat = abs(params((2*ii)-1).*stimuli(1,:) - params(2*ii).*stimuli(2,:));
        
        % Convert mechanism output to lags
        pc_hat(ii,:) =  1-exp((m_hat./params(end-1)).^params(end));
    end
elseif (dimension == 3)
    % Loop over the number of mechaisms
    for ii = (size(params,1)-2)/2
        % Get the weight linear mechanism output
        m_hat = abs(params((3*ii)-2).*stimuli(1,:) + params((3*ii)-1).*stimuli(2,:) + params(3*ii).*stimuli(3,:));
        
        % Convert mechanism output to lags
        pc_hat(ii,:) =  1-exp((m_hat./params(end-1)).^params(end));
    end
else
    error('Dimension must be 2 or 3');
end

%% Take the min of the lags
pcFromParams = max(pc_hat,[],1);




