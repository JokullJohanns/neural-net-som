clear all;
close all;
num_weights = 5;
num_features = 84;
weights = rand([num_weights, num_features]); %Use a weight matrix of size 100x84 initialized to random numbers between zero and one
epochs = 200;
step_size = 0.2;
init_hood_size = 50;
hood_size = init_hood_size;
dec = hood_size*(1/epochs);
animals;
for epoch = 1:epochs %outer training loop
    for animal = 1:32 %Loop through the 32 animals one at a time, animal becomes our row index into props
        hood_floor = floor(hood_size);
        p = props(animal,:); %Pick out an animal from the matrix (each row is an animal), p is an attribute vector
        
        %Find the row of the weight matrix with the shortest distance to
        %this attribute vector p
        
        p_mat = repmat(p,num_weights,1); %Make a copy of the selected animal vector to be equal to the size of the weight matrix
        difference = p_mat - weights; %Subtract two matrices to take the difference
       
        %Calculate the length of the difference vector
        %Create an array to store the distance from our difference vector
        %vector and all the weights
        
        norms = zeros(1,num_weights); 
        for i = 1:num_weights
            norms(i) = norm(difference(i,:)); %Compute the 2-norm distance
        end
        [winner, winner_index] = min(norms); %Find the smallest distance and its index
        
        
        if(winner_index + hood_floor > num_weights)
            indexEnd = num_weights;
        else
            indexEnd = winner_index + hood_floor;
        end
        if (winner_index - hood_floor < 1)
            indexStart = 1;
        else
            indexStart = winner_index - hood_floor;
        end
        
        num_neighbors = length(indexStart:indexEnd);
        p_mat = repmat(p,num_neighbors,1);
        weight_hood = weights(indexStart:indexEnd,:);
        weights(indexStart:indexEnd,:) = weight_hood + step_size*(p_mat - weight_hood); %Update the winning weight
                
    end
    hood_size = hood_size - dec; %Reduce our neighborhood size
     %Take the floor so it is not a decimal
    
end

pos = zeros(1,32);

for animal = 1:32 %Loop through the 32 animals one at a time, animal becomes our row index into props
        p = props(animal,:); %Pick out an animal from the matrix (each row is an animal), p is an attribute vector
        
        %Find the row of the weight matrix with the shortest distance to
        %this attribute vector p
        
        p_mat = repmat(p,num_weights,1); %Make a copy of the selected animal vector to be equal to the size of the weight matrix
        difference = p_mat - weights; %Subtract two matrices to take the difference
        
        %Calculate the length of the difference vector
        %Create an array to store the distance from our difference vector
        %vector and all the weights
        
        norms = zeros(1,num_weights); 
        for i = 1:num_weights
            norms(i) = norm(difference(i,:)); %Compute the 2-norm distance
        end
        [winner, winner_index] = min(norms); %Find the smallest distance and its index
        pos(animal) = winner_index;
        
       
end
[dummy, order] = sort(pos);
sorted_animals = snames(order);
sorted_animals'
