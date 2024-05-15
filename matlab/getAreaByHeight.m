function tempR = getAreaByHeight(h, config)
    syms r
    a = config("a");
    b = config("b");
    etaLoS = config("etaLos");
    etaNLoS = config("etaNLoS");
    
    theta = atan(h / r);
    f =  pi * tan(theta) / (9 * log(10)) + (a * b * (etaLoS - etaNLoS) * exp(-b * (180 * theta / pi - a))) / ((a * exp(-b * (180 * theta / pi - a)) + 1) ^ 2);
    df = diff(f);
    tolerance = 1e-2;
    tempR = h; % 初始
    while 1
        tHeight = double(subs(f, r, tempR));
        if abs(tHeight) < tolerance
            break;
        end
        tempR = tempR - tHeight / double(subs(df, r, tempR));
    end
end