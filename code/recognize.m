function licenseNumber = recognize(licensePlate,licensePlateBW,options)
% Recognize the license plate from the given image
%
% Author:
%   Yusen Zheng
%
% Input:
%   licensePlate: the source image
%   licensePlateBW: the input binary image
%
% Output:
%   licenseNumber: the recognized license plate number

  %% arguments
  arguments
    licensePlate (:,:,3) uint8
    licensePlateBW logical 
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  whiteCountPerColumnThreshold = options.whiteCountPerColumnThreshold;
  verbose = options.verbose;

  %% 预处理
  % 判断是否需要反色处理
  grayAvg = sum(licensePlateBW,"all");
  total = size(licensePlateBW,1)*size(licensePlateBW,2);
  grayPercentageThreshold = .5;
  
  % 新能源汽车需反色
  if grayAvg/total > grayPercentageThreshold
      licensePlateBW = ~licensePlateBW;
  end
  
  % 确定兴趣域
  whiteCountPerRow = sum(licensePlateBW,2);
  whiteCountPerRowThreshold = .5*mean(whiteCountPerRow);
  regionsRow = whiteCountPerRow > whiteCountPerRowThreshold;
  startIdx = find(diff(regionsRow)==1);
  endIdx = find(diff(regionsRow)==-1);
  licenseNumberBW = licensePlateBW(startIdx:endIdx,:);
  licenseNumberROI = [zeros(size(licenseNumberBW,1),1) licenseNumberBW zeros(size(licenseNumberBW,1),1)];
  
  % 存在字符的区域
  whiteCountPerColumn = sum(licenseNumberROI,1);
  regionsColumn = whiteCountPerColumn > whiteCountPerColumnThreshold;
  
  % 字符位置索引
  startIdx = find(diff(regionsColumn)==1);
  endIdx = find(diff(regionsColumn)==-1);

  % 字符分割及错误分割的处理
  gap = startIdx(2:end) - endIdx(1:end-1);
  wrongDivisionThreshold = .5*mean(gap);
  wrongDivisionIdx = find(gap < wrongDivisionThreshold);
  regionsColumn(endIdx(wrongDivisionIdx):startIdx(wrongDivisionIdx+1)) = 1;
  
  % 向后差分判断分割域
  startIdx = find(diff(regionsColumn)==1);
  endIdx = find(diff(regionsColumn)==-1);
  regions = endIdx-startIdx;
  widthThreshold = .5*mean(regions);

  % 丢弃分隔符
  del = find(regions<widthThreshold);
  startIdx(del) = [];
  endIdx(del) = [];
  regions(del) = [];

  % 单字符可视化
  if verbose
      figure
      whiteCountPerColumn = sum(licenseNumberROI,1);
      imshow(licenseNumberROI)
      hold on
      plot(max(whiteCountPerColumn) - whiteCountPerColumn,'r',"LineWidth",3)
      grid on
      axis tight
      hold off

      figure
      tiledlayout(1,size(regions,2))
      for i = 1:size(regions,2)
          letterImage = licenseNumberROI(:,startIdx(i):endIdx(i));
          nexttile
          imshow(letterImage)
      end
  end

  %% 字符识别 //TODO
  % 导入模板字符
  templateDir = fullfile('./templates');
  templates = dir(fullfile(templateDir,'*.bmp'));
  
  candidateImage = cell(length(templates),2);
  for p=1:length(templates)
      [~,fileName] = fileparts(templates(p).name);
      candidateImage{p,1} = fileName;
      templatesIm = imread(fullfile(templates(p).folder,templates(p).name));
      candidateImage{p,2} = imbinarize(uint8(templatesIm));
  end
  
  % 车牌识别
  licenseNumber = '';
  for p=1:length(regions)
      % Extract the letter
      letterImage = licenseNumberROI(:,startIdx(p):endIdx(p));
      % Compare to templates
      distance = zeros(1,length(templates));
      for t=1:length(templates)    
          candidateImageRe = imresize(candidateImage{t,2},size(letterImage));
          distance(t) = abs(sum((letterImage-candidateImageRe).^2,"all"));
      end
      [~,idx] = min(distance);
      letter = candidateImage{idx,1};
      licenseNumber(end+1) = letter;
  end

  figure,imshow(licensePlate),title(licenseNumber)

end