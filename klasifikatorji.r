MajorityClassifier <- function(trainSet) 
{
    # vecinski razred
    majorityClass <- names(which.max(table(trainSet$O3)))

    # tocnost napovedi vecinskega klasifikatorja - 0.6211073
    majorityClassifier <- sum(trainSet$O3 == majorityClass) / length(trainSet$O3) 
}

