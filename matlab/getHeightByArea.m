function height = getHeightByArea(r_UAVBS, config)
    syms h
    r = r_UAVBS;
    a = config("a");
    b = config("b");
    etaLoS = config("etaLos");
    etaNLoS = config("etaNLoS");
    
    theta = atan(h/r);
    f =  pi*tan(theta)/(9*log(10)) + (a*b*(etaLoS-etaNLoS)*exp(-b*(180*theta/pi-a)))/((a*exp(-b*(180*theta/pi-a))+1)^2);
    df = diff(f);
    tolerance = 1e-3;
    height = r; % 初始
    while 1
        tArea = double(subs(f,h,height));
        if abs(tArea) < tolerance
            break;
        end
        height = height - double(subs(f,h,height)) / double(subs(df,h,height));
    end
end