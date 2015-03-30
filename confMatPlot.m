function [obj, overall]=confMatPlot(confMat, opt)
%confMatPlot: Display the confusion matrix

if nargin<1, selfdemo; return; end
if ischar(confMat) && strcmpi(confMat, 'defaultOpt')   
	obj.mode='both';
	obj.format='8.2f';
	obj.className={};	
	obj.matPlotOpt=matPlot('defaultOpt');		
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end

if isempty(opt.className)
	for i=1:size(confMat, 1)
		opt.className{i}=int2str(i);
	end
end

%colordef black;
[m, n]=size(confMat);
fontSize=10;
prob = confMat./(sum(confMat')'*ones(1, size(confMat,1)));
diagCount=sum(diag(confMat));
allCount=sum(sum(confMat));
overall = diagCount/allCount;
newProb = round(prob*100000000)/1000000;
newOverall = round(overall*100000000)/1000000;

% Propogate the options to matPlot
opt.matPlotOpt.format=opt.format;
opt.matPlotOpt.rowLeftLabel=opt.className;
opt.matPlotOpt.colUpLabel=opt.className;

switch(lower(opt.mode))
	case lower('dataCount')
		opt.matPlotOpt.matrixName=sprintf('Data counts, RR = %d/%d = %g%%', diagCount, allCount, newOverall);
		obj=matPlot(confMat, opt.matPlotOpt);
		% === Modify "23.00" into "23"
		for i=1:m
			for j=1:n
				str = get(obj.element(i,j), 'string');
				set(obj.element(i,j), 'string', int2str(eval(str)));
			end
		end
		for i=1:m
			str = get(obj.rowRightLabel(i), 'string');
			set(obj.rowRightLabel(i), 'string', int2str(eval(str)));
		end
		for j=1:n
			str = get(obj.colDownLabel(j), 'string');
			set(obj.colDownLabel(j), 'string', int2str(eval(str)));
		end
	case lower('percentage')
		opt.matPlotOpt.matrixName=sprintf('Percentages, RR = %g%%', newOverall);
		opt.matPlotOpt.showColSum=0;
		obj=matPlot(newProb, opt.matPlotOpt);
		% === Add the percentage sign
		for i=1:m
			for j=1:n
				str = get(obj.element(i,j), 'string');
			%	set(obj.element(i,j), 'string', [str, '%']);
				if eval(str)
					set(obj.element(i,j), 'string', [str, '%']);
				else
					set(obj.element(i,j), 'string', '0');
				end
			end
		end
		for i=1:m
			str = get(obj.rowRightLabel(i), 'string');
			set(obj.rowRightLabel(i), 'string', [str, '%']);
		end
		for j=1:n
			str = get(obj.colDownLabel(j), 'string');
			set(obj.colDownLabel(j), 'string', [str, '%']);
		end
	case lower('both')
		opt.matrixName=sprintf('Data counts, RR = %d/%d = %g%%', diagCount, allCount, newOverall);
		rowSum=sum(confMat, 2);
		for i=1:m, opt.rowRightLabel{i}=['100%', 10, '(', mat2str(rowSum(i)), ')']; end
		colSum=sum(confMat, 1);
		for j=1:n, opt.colDownLabel{j}=['(', mat2str(colSum(j)), ')']; end
		[m, n]=size(confMat);
		for i=1:m
			for j=1:n
				if confMat(i,j)==0
					strMat{i,j}='0';
				else
					strMat{i,j}=[num2str(newProb(i,j), ['%', opt.format]), '%', 10, '(', num2str(confMat(i,j)), ')'];
				end
			end
		end
		obj=matPlot(strMat, opt.matPlotOpt);
end
for i=1:length(obj.rowLeftLabel)
	set(obj.rowLeftLabel(i), 'string', opt.matPlotOpt.rowLeftLabel{i});
end
for i=1:length(obj.colUpLabel)
	set(obj.colUpLabel(i), 'string', opt.matPlotOpt.colUpLabel{i});
end

function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
