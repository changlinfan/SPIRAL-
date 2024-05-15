function mobiles_location = UE_generator(ue_size, rangeOfPosition)
    while 1
        lambda = ue_size/10; %intensity of initial points (centers)
        mean_children = 0.9; %mean number of children of each point
        X = zeros(10^5,2); %initialise the points
        N = poissrnd(lambda); %number of centers
        % N = lambda;

        X(1:N,:) = rangeOfPosition(1,1)*rand(N,2); %generate the centers
        total_so_far = N; %total number of points generated
        next = 1;
        while next < total_so_far
            nextX = X(next,:); %select next point
            N_children = poissrnd(mean_children); %number of children
            NewX = repmat(nextX,N_children,1) + 11*randn(N_children,2);
            X(total_so_far+(1:N_children),:) = NewX; %update point list
            total_so_far = total_so_far+N_children;
            next = next+1;
        end
        X=X(1:total_so_far,:); %cut off unused rows

        num_generated_ue = length(X(:,1));
        if num_generated_ue >= ue_size && num_generated_ue < ue_size+100
            k = randperm(num_generated_ue);
            mobiles_location = X(k(1:ue_size),:); %請return這個矩陣
            for i=1:1:ue_size
                mobiles_location(i, 3) = 0;
                mobiles_location(i, 4) = i;
            end
            break
        end
    end
end