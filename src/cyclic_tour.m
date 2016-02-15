clear all;
close all;
num_weights = 20;
num_features = 2;
weights = rand([num_weights, num_features]); %Use a weight matrix of size 100x84 initialized to random numbers between zero and one
epochs = 2000;
step_size = 0.2;
init_hood_size = 2;
hood_size = init_hood_size;
dec = hood_size*(1/epochs);
cities;
num_cities = length(city);
for epoch = 1:epochs %outer training loop
    
    if(epoch > epochs/2)
        hood_size = 1;
    end
    
    if(epoch == epochs)
        hood_size = 0;
    end
    
    for a_city = 1:num_cities %Loop through the 32 animals one at a time, animal becomes our row index into props
        hood_floor = floor(hood_size);
        p = city(a_city,:); %Pick out an animal from the matrix (each row is an animal), p is an attribute vector
        
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
        
        index_array = 1:num_weights;
        shift_size = (num_weights/2)-winner_index+1;
        a = circshift(index_array',shift_size);
        neighbors_index = a([(winner_index+shift_size-hood_size):(winner_index+shift_size+hood_size)]);
        weights([neighbors_index]);
        
        num_neighbors = length([neighbors_index]);
        p_mat = repmat(p,num_neighbors,1);
        weight_hood = weights([neighbors_index],:);
        weights([neighbors_index],:) = weight_hood + step_size*(p_mat - weight_hood); %Update the winning weight
                
    end
end

pos = zeros(1,num_cities);

for a_city = 1:num_cities %Loop through the 32 animals one at a time, animal becomes our row index into props
        p = city(a_city,:); %Pick out an animal from the matrix (each row is an animal), p is an attribute vector
        
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
        pos(a_city) = winner_index;
        
       
end
% [dummy, order] = sort(pos);
% sorted_cities = city(order);
% sorted_cities'

tour = [weights;weights(1,:)];
plot(tour(:,1), tour(:,2),'b-*', city(:,1),city(:,2),'+')

