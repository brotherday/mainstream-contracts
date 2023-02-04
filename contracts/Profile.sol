// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

contract Profile {
    address public owner;

    bytes32 public constant HOST = keccak256("HOST");
    bytes32 public constant PUBLIC = keccak256("PUBLIC");
    bytes32 public constant SPEAKER = keccak256("SPEAKER");

    mapping(address => string) public names;
    mapping(address => bytes32) public emails;
    mapping(address => bytes32) public pictures;
    mapping(address => bytes32) public roles;

    constructor(address _owner, bytes32 _role) {
        owner = _owner;
        roles[msg.sender] = _role;
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
