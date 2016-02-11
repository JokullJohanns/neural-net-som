clear all;
close all;
weights = rand([100,84]);
epochs = 20;
step_size = 0.2;
init_hood_size = 50;
hood_size = init_hood_size;
dec = hood_size*(1/epochs);
animals;
for epoch = 1:epochs
    for animal = 1:32
        p = props(animal,:);
        b = repmat(p,100,1);
        distance = b - weights;
       
        %There should be a vectorized way to do this
        norms = zeros(1,100);
        for i = 1:100
            norms(i) = norm(distance(i,:));
        end
        [mini, mini_index] = min(norms);
        weights(mini_index,:) = weights(mini_index,:) + step_size*(p - weights(mini_index,:));
        
        
    end
    hood_size = hood_size - dec;
    hood_floor = floor(hood_size);
    
end
