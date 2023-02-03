// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@zondax/filecoin-solidity/contracts/v0.8/types/DataCapTypes.sol";

interface IDataCap {
    function name() external returns (string memory);

    function symbol() external returns (string memory);

    function totalSupply() external returns (BigInt memory);

    function balance(bytes memory addr) external returns (BigInt memory);

    function allowance(DataCapTypes.GetAllowanceParams memory params)
        external
        returns (BigInt memory);

    function transfer(DataCapTypes.TransferParams memory params)
        external
        returns (DataCapTypes.TransferReturn memory);

    function transferFrom(DataCapTypes.TransferFromParams memory params)
        external
        returns (DataCapTypes.TransferFromReturn memory);

    function increaseAllowance(DataCapTypes.IncreaseAllowanceParams memory params)
        external
        returns (BigInt memory);

    function decreaseAllowance(DataCapTypes.DecreaseAllowanceParams memory params)
        external
        returns (BigInt memory);

    function revokeAllowance(DataCapTypes.RevokeAllowanceParams memory params)
        external
        returns (BigInt memory);

    function burn(DataCapTypes.BurnParams memory params)
        external
        returns (DataCapTypes.BurnReturn memory);

    function burnFrom(DataCapTypes.BurnFromParams memory params)
        external
        returns (DataCapTypes.BurnFromReturn memory);
}

contract Presentation {
    IDataCap DataCap;

    bytes public pieceCid;
    address public owner;
    bytes public topic;
    string public description;
    uint16 public ranking;
    uint256 public length;

    mapping(address => uint16) public votes;

    constructor(
        bytes memory _pieceCid,
        address _owner,
        bytes memory _topic,
        string memory _description,
        uint16 _ranking,
        address _dataCap
    ) {
        pieceCid = _pieceCid;
        owner = _owner;
        topic = _topic;
        description = _description;
        ranking = _ranking;
        DataCap = IDataCap(_dataCap);
    }

    function updateRanking(uint16 grade) public {
        return;
    }
}
