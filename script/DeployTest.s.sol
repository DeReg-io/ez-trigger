// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {TriggerManager} from "../src/infra/TriggerManager.sol";
import {SimpleTriggerable} from "../test/mock/SimpleTriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract DeployTestScript is Script, Test {
    function run() external {
        uint256 managerDeployKey = vm.envUint("DEPLOY_PRIV_KEY");

        // Default Anvil keys
        uint256 startKey1 = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        uint256 startKey2 = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

        vm.startBroadcast(startKey1);
        payable(vm.addr(managerDeployKey)).transfer(1 ether);
        vm.stopBroadcast();

        vm.startBroadcast(managerDeployKey);

        TriggerManager trigManager = new TriggerManager(vm.addr(startKey2), vm.addr(startKey1));
        emit log_named_address("address(trigManager)", address(trigManager));

        SimpleTriggerable triggerable = new SimpleTriggerable(vm.envBytes("INIT_UUID"));
        emit log_named_address("address(triggerable)", address(triggerable));

        vm.stopBroadcast();
    }
}
