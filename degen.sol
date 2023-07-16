// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract degen is ERC20, Ownable {

    struct Item {
        string name;
    }

    mapping(uint256 => Item) public items;

    constructor() ERC20("Degen", "DGN") {}

    function mint(address to, uint256 value) public onlyOwner {
        _mint(to, value);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(balanceOf(msg.sender) >= value, "Balance is low!!");
        _transfer(msg.sender, to, value);
        return true;
    }

    function balance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burn(uint256 value) public {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _burn(msg.sender, value);
    }

    function degenstorehouse() public  {
        // Add items to the storehouse
        items[1] = Item("DGN MEMBERSHIP LOGO");                 
        items[2] = Item("DGN CARD");               
        items[3] = Item("DGN SURPRISE");                 
                
    }


    function getLastDigit() public view returns (uint256) {
        return uint256(uint160(msg.sender)) % 10;
    }

    function redeem(uint256 itemNo) public {
        require(itemNo >= 1 && itemNo <= 3, "Invalid item number");
        //uint256 price = items[itemNo].price;
        
    if (itemNo == 1){
    uint price= 100;
    require(balanceOf(msg.sender) >= price, "Insufficient balance");

        _burn(msg.sender, price);
        uint256 additionalTokens = 50;
        _mint(msg.sender, additionalTokens);

        // Add logic here to distribute the item to the user
    }

    if (itemNo == 2){
        uint price= 20;
        require(balanceOf(msg.sender) >= price, "Insufficient balance");
         _burn(msg.sender, price);
        
        

    }

    if (itemNo == 3){
        
                uint256 price = 150;
                require(balanceOf(msg.sender) >= price, "Insufficient balance");
                uint256 lastDigit = getLastDigit();

            if (lastDigit >= 5) {
                // If the last digit is 5 or greater, transfer additional tokens
                uint256 additionalTokens = 75;
                _mint(msg.sender, additionalTokens);
            }

            _burn(msg.sender, price);
        }       
    }
}
