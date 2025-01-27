filename = 'C:\Users\Stelios\Desktop\������������\1 �������\���������� ��������\������\pima-indians-diabetes.data'
whole_set = trainSet(filename);
% Counting the size of the data in the form of [rows columns]
data_size = size(whole_set);
% Size of data set will be the number of rows in file
n = data_size(1);
% Number of features will be the number of columns in file except last
% column, which is the class
features = data_size(2) - 1;

% Our folds
folds = 10;
remainder = 0;
remainder_counter = 0;

% If the data set size cannot be divided by folds, reserve the remainder to
% share it between the test sets
if mod(n, folds) ~= 0
    remainder_counter = mod(n, folds);
    remainder = 1;
end

% The approximate test set size in each fold
folding_size = (n - remainder_counter)/folds;
set_accuracy = [];
test_start = 1;

while(test_start < n)
    correct = 0;
    
    % Separating our test and training sets, according to the k-fold rule
    test_set = whole_set(test_start:test_start+(folding_size + remainder) - 1,:);
    % Training set includes everything except the test set
    training_set = whole_set([1:test_start-1, (test_start + folding_size + remainder):n],:);
    
    % Separating our two classes in the training set
    class_negative_diabetes = training_set([training_set{:,features+1}] == 0,:);
    class_positive_diabetes = training_set([training_set{:,features+1}] == 1,:);
    
     % Calculating means of the training set classes
    means_negative = mean(cell2mat(class_negative_diabetes(:,1:features)));
    means_positive = mean(cell2mat(class_positive_diabetes(:,1:features)));   
    
     % Calculating covariances matrices of the training set classes
    cov_negative = cov(cell2mat(class_negative_diabetes(:,1:features)));
    cov_positive = cov(cell2mat(class_positive_diabetes(:,1:features)));
    
    % Iterating between the test set data samples
    for test = 1:size(test_set, 1)
  
        %�orm for the third task(different matrix)
        negative_diabetes = Norm_i(means_negative, cov_negative, test_set(test,1:features));
        positive_diabetes = Norm_i(means_positive, cov_positive, test_set(test,1:features));
        
           if (negative_diabetes < positive_diabetes)
                    if test_set{test,end} == 0
                        correct = correct + 1;
                    end
                else
                    if test_set{test,end} == 1
                        correct = correct + 1;
                    end
           end
    end
        
        
        
            % Array with each test set accuracy
        set_accuracy(end + 1) = correct/size(test_set,1); %#ok<SAGROW>
        test_start = test_start + (folding_size + remainder);

        % If remainder was found between the data set and the folds, substract
        % 1 until it's completely shared
        remainder_counter = remainder_counter -1;
        if remainder_counter == 1
            remainder = 0;
        end 
    end
    complete_accuracy = sum(set_accuracy)/folds*100;
