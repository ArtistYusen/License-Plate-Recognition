trueClass = categorical({'沪','E','W','M','9','5','7', ...
    '沪','A','F','0','2','9','7','6', ...
    '鲁','N','B','K','2','6','8', ...
    '沪','E','W','M','9','5','7', ...
    '豫','B','2','0','E','6','8', ...
    '沪','A','9','3','S','2','0', ...
    '沪','E','W','M','9','5','7', ...
    '沪','A','D','E','6','5','9','8', ...
    '皖','S','J','6','M','0','7'});

% 使用良好筛选的超参数
predClass = categorical({'沪','E','W','M','9','5','7', ...
    '沪','A','F','0','2','9','7','6', ...
    '鲁','N','B','K','2','6','8', ...
    '沪','E','W','M','9','5','7', ...
    '豫','B','2','0','E','6','8', ...
    '沪','A','9','3','S','2','0', ...
    '沪','E','W','M','9','5','7', ...
    '沪','A','D','E','6','5','9','8', ...
    '皖','S','J','6','M','0','7'});
figure;
confusionchart(trueClass, predClass);

% 使用扰动后的超参数和另一套字符集
predClass = categorical({'沪','6','W','M','9','5','7', ...
    '沪','A','F','0','2','9','7','6', ...
    '鲁','N','B','K','2','6','8', ...
    '沪','6','W','M','9','5','7', ...
    '豫','B','2','G','6','6','8', ...
    '沪','A','9','3','S','2','0', ...
    '沪','6','W','M','9','5','7', ...
    '沪','A','D','E','6','5','9','8', ...
    '皖','5','J','8','M','0','V'});
figure;
confusionchart(trueClass, predClass);

% F1-score
cm = confusionmat(trueClass, predClass);
precision = diag(cm)./(sum(cm,1)+eps)';
recall = diag(cm)./(sum(cm,2)+eps);
avg_precision = mean(precision)
avg_recall = mean(recall)
% macroF1 = mean(2*precision.*recall./(precision+recall))
microF1 = sum(diag(cm))./sum(cm(:))