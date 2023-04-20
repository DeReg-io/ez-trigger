// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {TriggerManager} from "../src/infra/TriggerManager.sol";
import {SimpleTriggerable} from "../test/mock/SimpleTriggerable.sol";

interface ICreate2Factory {
    function safeCreate2(bytes32 salt, bytes calldata initializationCode) external payable returns (address);
}

/// @author philogy <https://github.com/philogy>
contract TriggerManagerDeploy is Script, Test {
    ICreate2Factory internal SAFE_CREATE2_FACTORY = ICreate2Factory(0x0000000000FFe8B47B3e2130213B802212439497);

    function run() external {
        uint256 deployKey = vm.envUint("DEPLOY_PRIV_KEY");
        address deployAddr = vm.addr(deployKey);
        address managerAddr = vm.envAddress("MANAGER_ADDR");

        vm.startBroadcast(deployKey);

        bytes memory deployCode =
            abi.encodePacked(type(TriggerManager).creationCode, abi.encode(managerAddr, deployAddr));

        address triggerManager =
            SAFE_CREATE2_FACTORY.safeCreate2(bytes32(abi.encodePacked(deployAddr, uint96(0))), deployCode);
        emit log_named_address("triggerManager", triggerManager);

        vm.stopBroadcast();
    }
}
