// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Owned} from "solmate/auth/Owned.sol";
import {Multicallable} from "solady/utils/Multicallable.sol";
import {Triggerable} from "../Triggerable.sol";

/// @author philogy <https://github.com/philogy>
abstract contract TriggeredOwner is Owned, Multicallable, Triggerable {
    constructor(address initialOwner, bytes memory deregInitUUID) Owned(initialOwner) Triggerable(deregInitUUID) {}

    function forwardCall(address to, bytes calldata cd, uint256 value, bool requireSuccess)
        external
        onlyOwner
        returns (bytes memory retData)
    {
        bool success;
        (success, retData) = to.call{value: value}(cd);
        if (!success && requireSuccess) {
            assembly {
                revert(add(0x20, retData), mload(retData))
            }
        }
    }
}
