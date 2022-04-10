function licenseNumber = recoEasy(path, options)
%RECOEASY 用于识别easy模式中车牌的简单算法
%   author: Yusen Zheng
%   input1: path: 车牌图像的路径
%   option1: whiteCountPerColumnThreshold: 白色像素点数目的阈值
%   option2: verbose: 是否打印详细信息
%   output: licenseNumber: 车牌号码 

    arguments
        path (1,1) string
        options.whiteCountPerColumnThreshold (1,1) double = 5
        options.verbose (1,1) logical = true
    end

    licensePlate = imread(path);
    licenseNumber = recognize(licensePlate,licensePlate, ...
        "whiteCountPerColumnThreshold",options.whiteCountPerColumnThreshold, ...
        "verbose",options.verbose);
    
end