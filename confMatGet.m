function confMat = confMatGet(desiredOutput, computedOutput)
%confMatGet: Get confusion matrix from recognition results

if nargin<1, selfdemo; return; end

classCount=length(unique(desiredOutput));

confMat=zeros(classCount, classCount);
for i=1:classCount
	index=find(desiredOutput==i);
	roi=computedOutput(index);
	for j=1:classCount
		confMat(i,j)=length(find(roi==j));
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
