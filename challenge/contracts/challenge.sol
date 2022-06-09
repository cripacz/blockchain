pragma solidity ^0.5.0;

/*
******* CHALLENGE SMART CONTRACT *********
Attesa 20 secondi
1v1: 1.000 Paycoin per chi avvia. 10.000 per chi vince
1v2: 2.000 Paycoin per chi avvia. 50.000 per chi vince
*/

import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/token/ERC20/IERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/access/roles/MinterRole.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/math/SafeMath.sol";

contract challenge is MinterRole{

    using SafeMath for uint256;

    address public _paytoken;

    // reward to the starter, prize to the winner
    uint reward = 1000;
    uint prize = 10000;
    uint startTime;

    event Start (address starter);
    event End (address winner);

    constructor (address addr) public {
        _paytoken = addr;
    }

    //function setAddress_paytoken(address addr) public onlyMinter {
    //    _paytoken = addr;
    //}

    // Start function
    function start () public onlyMinter {
        
        // Transfers the reward to the starter 
        IERC20(_paytoken).transfer(msg.sender, reward);

        // Sets the clock
        startTime = chain.time();

        emit Start(msg.sender);

    }

    function acceptChallenge () public {
    
        require(chain.time() < startTime + 20);
        IERC20(_paytoken).transfer(msg.sender, prize);
    
    }

    function getPrize () public onlyMinter {

        require(chain.time() > startTime + 20);
        IERC20(_paytoken).transfer(msg.sender, prize);
    
    }
}

// minare i token, poi fare una nuova funzione che sia only minter che può richiamarli, ma solo dopo 20 sec
// e la funzione accept challenge, che possa ritirarli da chiunque prima di 20 sec