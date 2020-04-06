
% Copyright (C) 2017 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function jointListForKinDynObject(kinDyn)

    model = kinDyn.getRobotModel();
    
    for i = 0 : model.getNrOfJoints() -1
        disp(model.getJointName(i));
    end    
end
