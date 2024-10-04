// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import { USER_1, USER_2, USER_3, USER_4 } from "test/utils/Constants.sol";
import { BaseFixture } from "test/utils/Fixtures.sol";
import { FakeUniV2Pair } from "test/utils/FakeUniV2Pair.sol";
import { BaseMillionCatHandler } from "test/utils/BaseMillionCatHandler.sol";
import { StakeHandler } from "test/utils/StakeHandler.sol";
import { WrappedBaseMillionCat } from "src/WrappedBaseMillionCat.sol";

/**
 * @title BaseMillionCatFixture
 * @dev Utils for testing BaseMillionCat.sol
 */
contract BaseMillionCatFixture is BaseFixture {
    BaseMillionCatHandler public ponzio;
    WrappedBaseMillionCat public wrappedBaseMillionCat;
    StakeHandler public stake;
    FakeUniV2Pair public uniV2Pair;

    function _setUp(address deployer) public virtual {
        address[] memory _actors = new address[](4);
        _actors[0] = USER_1;
        _actors[1] = USER_2;
        _actors[2] = USER_3;
        _actors[3] = USER_4;

        if (deployer != address(0)) {
            vm.startPrank(deployer);
        }

        ponzio = new BaseMillionCatHandler(_actors);
        wrappedBaseMillionCat = new WrappedBaseMillionCat(ponzio);

        uniV2Pair = new FakeUniV2Pair();

        stake = new StakeHandler(_actors, address(uniV2Pair), address(wrappedBaseMillionCat));

        uniV2Pair.approve(address(ponzio), UINT256_MAX);
        ponzio.initialize(address(stake), address(uniV2Pair));
        if (deployer != address(0)) {
            vm.stopPrank();
        }
    }
}
