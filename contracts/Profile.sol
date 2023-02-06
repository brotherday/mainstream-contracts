// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

contract Profile {
    address private owner;

    bytes32 public constant Host = keccak256("Host");
    bytes32 public constant Public = keccak256("Public");
    bytes32 public constant Speaker = keccak256("Speaker");

    mapping(address => string) public names;
    mapping(address => bytes32) public emails;
    mapping(address => bytes32) public pictures;
    mapping(address => bytes32) public roles;

    constructor(bytes32 _role) {
        require(_role == Host || _role == Public || _role == Speaker, "Invalid role type");
        owner = msg.sender;
        roles[msg.sender] = _role;
    }

    function Owner() public view returns (address) {
        return owner;
    }

    function setName(string memory _name) public {
        names[msg.sender] = _name;
    }

    function setEmail(bytes32 _email) public {
        emails[msg.sender] = _email;
    }

    function setPicture(bytes32 _picture) public {
        pictures[msg.sender] = _picture;
    }
}
