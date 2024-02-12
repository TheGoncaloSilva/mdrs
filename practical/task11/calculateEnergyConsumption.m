function consumption= calculateEnergyConsumption(Lengths, Loads)
    nInterfaces= 2;
    consumption= 0;
    
    auxLoads= Loads';
    for link=auxLoads
        if sum(link(3:4)) == 0 % Link in sleeping mode
            consumption= consumption + 0.5;
        else % Link in operation
            distance= Lengths(link(1), link(2));
            consumption= consumption + (nInterfaces*5) + (distance * 0.10);
        end
    end
end