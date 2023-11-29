pragma solidity 0.8.19;

interface Living{
    function eat(string memory food) external returns(string memory);
}

contract HasName{
    string internal _name;
    constructor(string memory name){
        _name=name;
    }

    function getName() view public returns(string memory){
        return _name;
    }
}

contract Animal is Living{
    
    function eat(string memory food) view virtual public returns(string memory){
        return string.concat(string.concat("Animal eats ",food));
    }

    function sleep() view public returns(string memory){
        return "Z-z-z...";
    }

    function speak() view virtual public returns(string memory){
        return "...";
    }

    function compare(string memory str1, string memory str2) public pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

}

abstract contract Herbivore is Animal, HasName{
    string constant PLANT = "plant";
    
    modifier eatOnlyPlant(string memory food){
        require(compare(food,PLANT),"Can only eat plant food");
        _;
    }

    function eat(string memory food) view virtual override public eatOnlyPlant(food) returns(string memory){
        return super.eat(food);
    }
}

abstract contract Carnivore is Animal, HasName{
    string constant MEAT = "meat";
    modifier eatOnlyPlant(string memory food){
        require(compare(food,MEAT),"Can only eat meat food");
        _;
    }

    function eat(string memory food) view virtual override public eatOnlyPlant(food) returns(string memory){
        return super.eat(food);
    }
}

abstract contract Omnivore is Animal, HasName{
    string constant MEAT = "meat";
    string constant PLANT = "plant";

    modifier eatPlantandMeet(string memory food){
        if(compare(food,PLANT) || compare(food,MEAT)){
            _;
        }
        revert("Can only eat meat or plant food");
        _;
    }

    function eat(string memory food) view virtual override public eatPlantandMeet(food) returns(string memory){
        return super.eat(food);
    }
}


contract Cow is Herbivore{

    constructor(string memory name) HasName(name){
    }

    function speak() view override public returns(string memory){
        return "Mooo";
    }
}

contract Horse is Herbivore{

    constructor(string memory name) HasName(name){
    }
    function speak() view override public returns(string memory){
        return "Igogo";
    }

}
contract Wolf is Carnivore {
    constructor(string memory name) HasName(name) {
    }

    function speak() view override public returns (string memory) {
        return "Awoo";
    }
}

//contract Wolf is Carnivore{
   // constructor(string memory name) HasName(name){
 //   }
  //  function () view override public returns(string memory){
   //     return "Awoo";
    //}
//}

contract Dog is Omnivore{
    constructor(string memory name) HasName(name){
    }
    function speak() view override public returns(string memory){
        return "Bow-wow";
    }
}


contract Farmer {

    address[] public animals;

    function getAnimals() view public returns (address[] memory){
        return animals;
    }

    function addAnimal(address animalAddress) public {
        animals.push(animalAddress);
    }

    function getAnimal(uint256 index) view public returns(Animal){
        return Animal(animals[index]);
    }

    function feedByIndex(uint256 index, string calldata food) view public returns(string memory){
        return getAnimal(index).eat(food);
    }

    function callByIndex(uint256 index) view public returns(string memory){
        return getAnimal(index).speak();
    }

    function feedByAddress(address animal, string calldata food) view public returns(string memory){
        return Animal(animal).eat(food);
    }

    function callByAddress(address animal) view public returns(string memory){
        return Animal(animal).speak();
    }
}