function checkOutputDir(outputDir)
    if ~exist(outputDir, 'dir') % 確認out是否存在
        mkdir(outputDir);
    end
end