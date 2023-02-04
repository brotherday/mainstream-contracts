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

    function setName(address _user, string memory _name) public {
        names[_user] = _name;
    }

    function setEmail(address _user, bytes32 _email) public {
        emails[_user] = _email;
    }

    function setPicture(address _user, bytes32 _picture) public {
        pictures[_user] = _picture;
    }
}
