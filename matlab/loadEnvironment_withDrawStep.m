function [ue_size, rangeOfPosition, r_UAVBS, minDataTransferRateOfUEAcceptable, maxDataTransferRateOfUAVBS, config] = loadEnvironment_withDrawStep()
    % ue_size = 600; % 生成UE的數量
    ue_size = 19; % del
    % rangeOfPosition = 400; % UE座標的範圍 X介於[a b] Y介於[a b] 
    rangeOfPosition = 40; % del
    r_UAVBS = 80; % UAVBS涵蓋的範圍

    minDataTransferRateOfUEAcceptable = 6*10^6; % 使用者可接受的最低速率
    % Cmin = 3*10^6; (MC2023) 
    % Cmin = 10^6; (APWCS2023) (一般)
    % maxDataTransferRateOfUAVBS = 1.5*10^8; % 無人機回程速率上限 1.6~1.7
    maxDataTransferRateOfUAVBS = 4 * minDataTransferRateOfUEAcceptable; % del

    config = dictionary(["bandwidth" "powerOfUAVBS" "noise"           "a"   "b"  "frequency" "constant" "etaLos" "etaNLos" "minHeight" "maxHeight" "maxNumOfOverlay"] ...
                       ,[2*10^7      0.1            4.1843795*10^-21  12.08 0.11 2*10^9      3*10^8     1.6      23        30          120          1]); % del
    minR = getAreaByHeight(10, config);
    maxR = getAreaByHeight(120, config);
    config("minR") = minR;
    config("maxR") = maxR;
    % bandwidth 頻寬
    % powerOfUAVBS 功率
    % noise 熱雜訊功率譜密度
    % a 環境變數
    % b 環境變數
    % frequency 行動通訊的載波頻寬(Hz)
    % constant 光的移動速率(m/s)
    % etaLos Los的平均訊號損失
    % etaNLos NLos的平均訊號損失
    % minHeight 法定最低高度
    % maxHeight 法定最高高度
    % minR 法定最低高度換算之半徑
    % maxR 法定最高高度換算之半徑
    % maxNumOfOverlay 能接受重疊區域最大的UE數量
end