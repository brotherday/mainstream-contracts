// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../interface/IDataCap.sol";
import "@zondax/filecoin-solidity/contracts/v0.8/DataCapAPI.sol";
import "@openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";

abstract contract DataCap is IDataCap, IERC165 {
    function name() external returns (string memory) {
        return DataCapAPI.name();
    }

    function symbol() external returns (string memory) {
        return DataCapAPI.symbol();
    }

    function totalSupply() external returns (BigInt memory) {
        return DataCapAPI.totalSupply();
    }

    function balance(bytes calldata addr) external returns (BigInt memory) {
        return DataCapAPI.balance(addr);
    }

    function allowance(DataCapTypes.GetAllowanceParams calldata params) external returns (BigInt memory) {
        return DataCapAPI.allowance(params);
    }

    function transfer(DataCapTypes.TransferParams calldata params)
        external
        returns (DataCapTypes.TransferReturn memory)
    {
        return DataCapAPI.transfer(params);
    }

    function transferFrom(DataCapTypes.TransferFromParams calldata params)
        external
        returns (DataCapTypes.TransferFromReturn memory)
    {
        return DataCapAPI.transferFrom(params);
    }

    function increaseAllowance(DataCapTypes.IncreaseAllowanceParams calldata params) external returns (BigInt memory) {
        return DataCapAPI.increaseAllowance(params);
    }

    function decreaseAllowance(DataCapTypes.DecreaseAllowanceParams calldata params) external returns (BigInt memory) {
        return DataCapAPI.decreaseAllowance(params);
    }

    function revokeAllowance(DataCapTypes.RevokeAllowanceParams calldata params) external returns (BigInt memory) {
        return DataCapAPI.revokeAllowance(params);
    }

    function burn(DataCapTypes.BurnParams calldata params) external returns (DataCapTypes.BurnReturn memory) {
        return DataCapAPI.burn(params);
    }

    function burnFrom(DataCapTypes.BurnFromParams calldata params)
        external
        returns (DataCapTypes.BurnFromReturn memory)
    {
        return DataCapAPI.burnFrom(params);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IDataCap).interfaceId;
    }
}
