//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

interface IERC20 {
    function transfer(address to, uint256 amount) external;
    function decimals() external view returns(uint);
}



contract TokenSale {

    //Variable
    uint256 tokenPrice = 1 ether;

    IERC20 token;

    constructor(address _token) {
        token = IERC20(_token);
    }


    function purchase() public payable {
        require (msg.value >=  tokenPrice, "Not enough money");
        uint256 tokensToTransfer = msg.value / tokenPrice;
        token.transfer(msg.sender, tokensToTransfer * 10 ** token.decimals());
    } 
}
