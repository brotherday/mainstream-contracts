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
