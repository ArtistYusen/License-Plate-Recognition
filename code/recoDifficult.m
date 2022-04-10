function licenseNumber = recoDifficult(path,task_id,options) 

  arguments
    path (1,1) string
    task_id (1,1) int32
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  switch task_id
    case 1
      licenseNumber = difficult_1(path,"whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
    case 2
      licenseNumber = difficult_2(path,"whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
    case 3
      licenseNumber = difficult_3(path,"whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
  end

end

function licenseNumber = difficult_1(path,options)

  arguments
    path (1,1) string
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  % Load image
  licensePlate = imread(path);
  licensePlateGray = rgb2gray(licensePlate);
  [r,~,b] = imsplit(licensePlate);
  mask = zeros(size(r));
  mask(b>120 & r<60) = 1;

  % 掩膜
  gray_mask = double(licensePlateGray).*mask;
  gray_mask(gray_mask~=0) = 255;

  % 形态学运算
  kernel = strel('rectangle',[5,5]);
  license_area = imclose(gray_mask,kernel);
  kernel = strel('rectangle',[15,15]);
  binary_mask = imdilate(license_area,kernel);
  kernel = strel('rectangle',[25,25]);
  binary_mask = imclose(binary_mask,kernel);
  
  % 找到车牌区域
  [white_area_row,white_area_col] = find(binary_mask==255);
  y0 = min(white_area_row);
  y1 = max(white_area_row);
  x0 = min(white_area_col);
  x1 = max(white_area_col);
  initial_im = licensePlate(y0:y1,x0:x1,:);
  
  % 四点法矫正
  deltax = x1 - x0;
  deltay = size(white_area_row,1) / deltax;

  p1 = [x0, y1-deltay];
  p2 = [x1, y0];
  p3 = [x0, y1];
  p4 = [x1, y0+deltay];

  t1 = [x0, y1-deltay];
  t2 = [x0+round(1.5*deltax), y1-deltay];
  t3 = [x0, y1];
  t4 = [x0+round(1.5*deltax), y1];

  initial_points = [p1; p2; p3; p4];
  target_points = [t1; t2; t3; t4];


  tform = fitgeotrans(initial_points, target_points, 'projective');
  licenseWarp = imwarp(licensePlate,tform,'OutputView',imref2d(size(licensePlate)));
  license = licenseWarp(t1(2):t4(2),t1(1):t4(1),:);

  if options.verbose
    figure, imshow(initial_im);
    figure, imshow(licenseWarp);
    figure, imshow(license);
  end

  % 车牌识别
  licenseNumber = recognize(licensePlate,license, ...
    "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
    "verbose",options.verbose);

end

function licenseNumber = difficult_2(path,options)

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
  mask(b<170 & r<165 & g>175) = 1;

  % 掩膜
  gray_mask = double(licensePlateGray).*mask;
  gray_mask(gray_mask~=0) = 255;

  % 形态学运算
  kernel = strel('rectangle',[5,5]);
  binary_mask = imopen(gray_mask,kernel);
  kernel = strel('rectangle',[25,25]);
  binary_mask = imclose(binary_mask,kernel);
  
  % 找到车牌区域
  [white_area_row,white_area_col] = find(binary_mask==255);
  y0 = min(white_area_row);
  y1 = max(white_area_row);
  x0 = min(white_area_col);
  x1 = max(white_area_col);
  initial_im = licensePlate(y0:y1,x0:x1,:);
  
  % 四点法矫正
  deltax = x1 - x0;
  deltay = size(white_area_row,1) / deltax;
  offset = 50;

  p1 = [x0, y0-offset];
  p2 = [x1, y1-deltay-offset];
  p3 = [x0, y0+deltay];
  p4 = [x1, y1];

  t1 = [x0, y0-offset];
  t2 = [x0+round(1.5*deltax), y0-offset];
  t3 = [x0, y0+deltay];
  t4 = [x0+round(1.5*deltax), y0+deltay];

  initial_points = [p1; p2; p3; p4];
  target_points = [t1; t2; t3; t4];


  tform = fitgeotrans(initial_points, target_points, 'projective');
  licenseWarp = imwarp(licensePlate,tform,'OutputView',imref2d(size(licensePlate)));
  license = licenseWarp(t1(2):t4(2),t1(1):t4(1),:);

  if options.verbose
    figure, imshow(initial_im);
    figure, imshow(licenseWarp);
    figure, imshow(license);
  end

  % 车牌识别
  licenseNumber = recognize(licensePlate,license, ...
    "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
    "verbose",options.verbose);

end

function licenseNumber = difficult_3(path,options)

  arguments
    path (1,1) string
    options.whiteCountPerColumnThreshold (1,1) double = 5
    options.verbose (1,1) logical = true
  end

  % Load image
  licensePlate = imread(path);
  licensePlateGray = rgb2gray(licensePlate);
  [r,~,b] = imsplit(licensePlate);
  mask = zeros(size(r));
  mask(b>150 & r<70) = 1;

  % 掩膜
  gray_mask = double(licensePlateGray).*mask;
  gray_mask(gray_mask~=0) = 255;

  % 形态学运算
  kernel = strel('rectangle',[8,8]);
  binary_mask = imopen(gray_mask,kernel);
  kernel = strel('rectangle',[20,20]);
  binary_mask = imclose(binary_mask,kernel);

  % 找到车牌区域
  [white_area_row,white_area_col] = find(binary_mask==255);
  y0 = min(white_area_row);
  y1 = max(white_area_row);
  x0 = min(white_area_col);
  x1 = max(white_area_col);
  initial_im = licensePlate(y0:y1,x0:x1,:);
  
  % 四点法矫正
  deltax = x1 - x0;
  deltay = size(white_area_row,1) / deltax;
  offset = 25;

  p1 = [x0+offset, y1-deltay-offset];
  p2 = [x1, y0];
  p3 = [x0, y1];
  p4 = [x1-offset, y0+deltay+offset];

  t1 = [x0, y1-deltay-offset];
  t2 = [x0+round(1.4*deltax), y1-deltay-offset];
  t3 = [x0, y1];
  t4 = [x0+round(1.4*deltax), y1];

  initial_points = [p1; p2; p3; p4];
  target_points = [t1; t2; t3; t4];


  tform = fitgeotrans(initial_points, target_points, 'projective');
  licenseWarp = imwarp(licensePlate,tform,'OutputView',imref2d(size(licensePlate)));
  license = licenseWarp(t1(2):t4(2),t1(1):t4(1),:);

  if options.verbose
    figure, imshow(initial_im);
    figure, imshow(licenseWarp);
    figure, imshow(license);
  end

  % 车牌识别
  licenseNumber = recognize(licensePlate,license, ...
    "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
    "verbose",options.verbose);

end