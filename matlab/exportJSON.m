function json = exportJSON(locationOfUEs, UAVBSsSet, UAVBSsR, indexArrayOfUEsServedByUAVBS, config)
    keys = ["locationOfUEs"; "UAVBSsSet"; "UAVBSsR"; "indexArrayOfUEsServedByUAVBS"; "maxR"];
    values = {locationOfUEs; UAVBSsSet; UAVBSsR; indexArrayOfUEsServedByUAVBS; config("maxR")};
    data = containers.Map(keys, values);
    json = jsonencode(data);
end