% Created on Sat Oct 29 2016
% @author: vipulkhatana

function [resultAnswer] = multisvm(TrainingSet,GroupTrain,TestSet,AR)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 


u=unique(GroupTrain);
numClasses=length(u);
result = zeros(length(TestSet(:,1)),1);

%build models
for k=1:numClasses
    %Vectorized statement that binarizes Group
    %where 1 is the current class and 0 is all other classes
    G1vAll=(GroupTrain==u(k));
    models(k) = svmtrain(TrainingSet,G1vAll);
end

%classify test cases
for j=1:size(TestSet,1)
    for k=1:numClasses
        if(svmclassify(models(k),TestSet(j,:))) 
            break;
        end
    end
    result(j) = k;
    
if gt(AR,1000)&& le(AR,8000)
     resultAnswer = 'Rice';
%      msgbox('rice');
%      disp('rice');
    
elseif gt(AR,6204)&& le(AR,6204) 
    resultAnswer = 'Dosa & Idlli';
%     msgbox('dosa & ldlli ');
%      disp('dosa & ldlli');
   
elseif gt(AR,8111)&& le(AR,16790)
    resultAnswer = 'Bread';
%     msgbox('bread');
%      disp('bread');
   

elseif gt(AR,16831)&& le(AR,24011)
    resultAnswer = 'Dosa';
%     msgbox('dosa');
%      disp('dosa');
     

elseif gt(AR,24050)&& le(AR,29878)
    resultAnswer = 'Idlli';
%     msgbox('ldlli');
%      disp('ldlli');
    

elseif gt(AR,29911)&& le(AR,35912)
    resultAnswer = 'Puri';
%     msgbox('puri');
%      disp('puri');

end  
end
