// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

contract Profile {
    address public owner;
    mapping(address => string) public names;
    mapping(address => bytes) public emails;
    mapping(address => bytes) public pictures;
    mapping(address => int256) public roles;
}
