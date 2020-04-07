
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function tau = extractEstimatedTau_from_mu_dgiveny(berdy, mu_dgiveny, q)
%EXTRACTEDESTIMATEDTAU_FROM_MUDGIVENY extracts via berdy the estimated
% torque by MAP.

% Initialize vectors
mu_dgiveny_berdy = iDynTree.VectorDynSize();
q_berdy = iDynTree.VectorDynSize();
tau_berdy = iDynTree.VectorDynSize(); %the output

% Resize vectors
mu_dgiveny_berdy.resize(berdy.getNrOfDynamicVariables());
q_berdy.resize(size(q,1));
tau_berdy.resize(size(q,1));

nrOfSamples  = size(q,2);
tau_vector = zeros(size(q));
tauFromBerdy = zeros(size(q));
for i = 1 : nrOfSamples
    mu_dgiveny_berdy.fromMatlab(mu_dgiveny(:,i));
    q_berdy.fromMatlab(q(:,i));
    tau_berdy.fromMatlab(tau_vector(:,i));
    berdy.extractJointTorquesFromDynamicVariables(mu_dgiveny_berdy,q_berdy, tau_berdy);
    tauFromBerdy(:,i) = tau_berdy.toMatlab();
end
tau = tauFromBerdy;
end
