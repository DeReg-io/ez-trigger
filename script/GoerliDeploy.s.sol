// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {TriggerManager} from "../src/TriggerManager.sol";
import {SimpleTriggerable} from "../test/mock/SimpleTriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract GoerliDeployScript is Script, Test {
    function run() external {
        uint256 managerDeployKey = vm.envUint("DEPLOY_PRIV_KEY");

        vm.startBroadcast(managerDeployKey);

        TriggerManager trigManager =
            new TriggerManager(0x00078d6aaeba1b61a1881D352933671E07b14Af9, 0x6fF546eC084962Ac2A7962b0f94d5f766e467aF4);
        emit log_named_address("address(trigManager)", address(trigManager));

        vm.stopBroadcast();
    }
}
