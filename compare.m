% function to calculate data for comparison
%TP: True positive
%FP: False positive
%TN: True negative
%FN: False negative
%TPR: True posistve rate
%TNR: True negative rate
%ACC: Accuracy
function [TP,FP,TN,FN,TPR,FPR,TNR,ACC]=compare(im1,im)
    [r c]=size(im);
    TP=0;
    FN=0;
    FP=0;
    TN=0;
    for x=1:r
        for y=1:c
            if im1(x,y)==1 && im(x,y)==1
                TP=TP+1;
            else if im1(x,y)==1 && im(x,y)==0
                    FP=FP+1;
                else if im1(x,y)==0 && im(x,y)==0
                        TN=TN+1;
                    else FN=FN+1;
                    end
                end
            end
        end
    end
    TPR=TP/(TP+FN);
    FPR=FP/(FP+TN);
    TNR=1-FPR;
    ACC=(TP+TN)/(TP+TN+FP+FN);
end