//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

import "./ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";




contract EliteToken is ERC20, AccessControl {

    //Variables
    //Creamos rol
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");



    constructor() ERC20 ("ELITE","ELT") {
        //Asignamos al msg.sender el rol de minter_role
       _grantRole(MINTER_ROLE, msg.sender);
       _grantRole(BURNER_ROLE, msg.sender);
    }


    function mintTokens () public onlyRole(MINTER_ROLE) {
        
        _mint(msg.sender, 1000000000000000000000);
    }

    function burnTokens () public onlyRole(BURNER_ROLE) {
        
        _burn(msg.sender, 100000000000000000000);
    }

}