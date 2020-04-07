
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function Acc = extractEstimatedAcc_from_mu_dgiveny_fixed(berdy, dVectorOrder, mu_dgiveny)
%EXTRACTEDESTIMATEDACC_FROM_MUDGIVENY extracts the estimated 6D accelerations
% by MAP.

nrOfLinks = size(dVectorOrder,1);
range = zeros(nrOfLinks,1);
nrOfSamples  = size(mu_dgiveny  ,2);

Acc = zeros(6*size(dVectorOrder,1), nrOfSamples);
for i = 1 : nrOfLinks
    range(i,1) = (rangeOfDynamicVariable(berdy, ...
        iDynTree.LINK_BODY_PROPER_ACCELERATION, dVectorOrder{i}));
    tmpRange = range(i,1) : range(i,1)+5;
    Acc(6*(i-1)+1:6*i,:) = mu_dgiveny(tmpRange,:);
end
end
