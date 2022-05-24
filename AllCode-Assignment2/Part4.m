

%Cross-validation- leave-one-oout, 35-fold. 

for sub=5 %subject number
    datasub=importdata(strcat('DataSub',string(sub),'.txt'));
    %CrossValidation --> FLMP, CrossValidation2--> MLE
    [train_error, test_error,test_prob]= CrossValidation(datasub); 
    total_test=sum(test_error);
    test_prob=reshape(test_prob,[7 5]);
        
%     AllResults3.Subject5.FLMP.cross_val.trainError=train_error;
%     AllResults3.Subject5.FLMP.cross_val.testError=test_error;
%     AllResults3.Subject5.FLMP.cross_val.totalTestError=total_test;
%     AllResults3.Subject5.FLMP.cross_val.predprob=test_prob;
    
    AllResults3.Subject5.MLE.cross_val.trainError=train_error;
    AllResults3.Subject5.MLE.cross_val.testError=test_error;
    AllResults3.Subject5.MLE.cross_val.totalTestError=total_test;
    AllResults3.Subject5.MLE.cross_val.predprob=test_prob;
    
    
end

round(train_error,4)'