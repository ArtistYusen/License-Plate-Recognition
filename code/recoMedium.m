function licenseNumber = recoMedium(path,task_id,options) 

  arguments
    path (1,1) string
    task_id (1,1) int32
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  switch task_id
    case 1
      licenseNumber = medium_1(path,"whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
    case 2
      licenseNumber = medium_2(path,"whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
    case 3
      licenseNumber = medium_3(path,"whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
  end

end

function licenseNumber = medium_1(path,options)

  arguments
    path (1,1) string
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  % Load image
  licensePlate = imread(path);
  licensePlateGray = rgb2gray(licensePlate);
  [r,g,b] = imsplit(licensePlate);
  mask = zeros(size(r));
  mask(find((b>130).*(r<12))) = 1;

  % 掩膜
  gray_mask = double(licensePlateGray).*mask;
  gray_mask(gray_mask~=0) = 255;

  % 形态学闭运算
  kernel = strel('rectangle',[50,50]);
  license_area = imclose(gray_mask,kernel);
  
  % 找到车牌区域
  [white_area_row,white_area_col] = find(license_area==255);
  white_area_row_min = min(white_area_row);
  white_area_row_max = max(white_area_row);
  white_area_col_min = min(white_area_col);
  white_area_col_max = max(white_area_col);
  license = licensePlate(white_area_row_min:white_area_row_max,white_area_col_min:white_area_col_max,:);

  if options.verbose
    figure,imshow(license);
  end

  % 车牌识别
  licenseNumber = recognize(licensePlate,license, ...
    "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
    "verbose",options.verbose);

end


function licenseNumber = medium_2(path,options)

  arguments
    path (1,1) string
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  % Load image
  licensePlate = imread(path);
  licensePlateGray = rgb2gray(licensePlate);
  [r,g,b] = imsplit(licensePlate);
  mask = zeros(size(r));
  mask(find((b>130).*(r<11))) = 1;

  % 掩膜
  gray_mask = double(licensePlateGray).*mask;
  gray_mask(gray_mask~=0) = 255;

  % 形态学闭运算
  kernel = strel('rectangle',[50,50]);
  license_area = imclose(gray_mask,kernel);
  
  % 找到车牌区域
  [white_area_row,white_area_col] = find(license_area==255);
  white_area_row_min = min(white_area_row);
  white_area_row_max = max(white_area_row);
  white_area_col_min = min(white_area_col);
  white_area_col_max = max(white_area_col);
  license = licensePlate(white_area_row_min:white_area_row_max,white_area_col_min:white_area_col_max,:);

  if options.verbose
    figure,imshow(license);
  end

  % 车牌识别
  licenseNumber = recognize(licensePlate,license, ...
    "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
    "verbose",options.verbose);

end


function licenseNumber = medium_3(path,options)

  arguments
    path (1,1) string
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  % Load image
  licensePlate = imread(path);
  licensePlateGray = rgb2gray(licensePlate);
  [r,g,b] = imsplit(licensePlate);
  mask = zeros(size(r));
  mask(find((b>100).*(r<80))) = 1;

  % 掩膜
  gray_mask = double(licensePlateGray).*mask;
  gray_mask(gray_mask~=0) = 255;

  % 形态学闭运算
  kernel = strel('rectangle',[30,20]);
  license_area = imclose(gray_mask,kernel);
  
  % 找到车牌区域
  [white_area_row,white_area_col] = find(license_area==255);
  white_area_row_min = min(white_area_row);
  white_area_row_max = max(white_area_row);
  white_area_col_min = min(white_area_col);
  white_area_col_max = max(white_area_col);
  license = licensePlate(white_area_row_min:white_area_row_max,white_area_col_min:white_area_col_max,:);
  
  if options.verbose
    figure,imshow(license);
  end
  
  % 车牌识别
  licenseNumber = recognize(licensePlate,license, ...
    "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
    "verbose",options.verbose);

end