function licenseNumber = recognize(licensePlate,license,options)
% Recognize the license plate from the given image
%
% Author:
%   Yusen Zheng
%
% Input:
%   licensePlate: the source image
%   license: position of the license plate
%
% Output:
%   licenseNumber: the recognized license plate number

  %% arguments
  arguments
    licensePlate (:,:,3) uint8
    license (:,:,3) uint8 
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  whiteCountPerColumnThreshold = options.whiteCountPerColumnThreshold;
  verbose = options.verbose;

  %% 字符分割
  % 预处理
  licensePlateGray = im2gray(license);
  licensePlateBlur = imgaussfilt(licensePlateGray,4);   
  Threshold = graythresh(licensePlateBlur);
  licensePlateBW = imbinarize(licensePlateBlur,Threshold);

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

  %% 字符识别 

  % 导入字符库
  templateDir = fullfile('./templates');
  folder = dir(templateDir);
  folder = folder(3:end); % 去除.和..
  templates = cell(length(folder),2);
  for p=1:length(templates)
      templates{p,1} = folder(p).name;
      templates{p,2} = cell(length(dir(fullfile(templateDir,folder(p).name)))-2,1);
      imList = dir(fullfile(templateDir,folder(p).name,'*.png'))';
      for q=1:length(templates{p,2})
          templateIm = imread(fullfile(templateDir,folder(p).name,imList(q).name));
          templates{p,2}{q} = imbinarize(uint8(templateIm));
      end
  end

  % 车牌识别
  licenseNumber = '';
  for p=1:length(regions)
      % 提取字符
      letterImage = licenseNumberROI(:,startIdx(p):endIdx(p));
      
      % 字符识别
      distance = zeros(1,length(templates));
      for t=1:length(templates)    
        for s = 1:length(templates{t,2})
          candidateImageRe = imresize(templates{t,2}{s},size(letterImage));
          distance(t) = distance(t) + abs(sum((letterImage-candidateImageRe).^2,"all"));
        end
        distance(t) = distance(t)/s;
      end
      [~,idx] = min(distance);
      letter = templates{idx,1};
      licenseNumber(end+1) = letter;
  end

  figure,imshow(licensePlate),title(licenseNumber)

end