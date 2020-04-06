
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function Fext = extractEstimatedFext_from_mu_dgiveny(berdy, dVectorOrder, mu_dgiveny)
%EXTRACTEDESTIMATEDFEXT_FROM_MUDGIVENY extracts the estimated external
% wrenches by MAP.
%
% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

nrOfLinks = size(dVectorOrder,1);
range = zeros(nrOfLinks,1);
nrOfSamples  = size(mu_dgiveny  ,2);

Fext = zeros(6*size(dVectorOrder,1), nrOfSamples);
for i = 1 : nrOfLinks
    range(i,1) = (rangeOfDynamicVariable(berdy, iDynTree.NET_EXT_WRENCH, dVectorOrder{i}));
    tmpRange = range(i,1) : range(i,1)+5;
    Fext(6*(i-1)+1:6*i,:) = mu_dgiveny(tmpRange,:);
end
end
