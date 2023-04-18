// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
library UUIDLib {
    error InvalidUUIDLength();
    error InvalidUUIDCharOther(uint256 i, bytes1 char);
    error InvalidUUIDCharUpper(uint256 i, bytes1 char);
    error MissingUUIDDashes(uint256 i, bytes1 char);

    uint256 internal constant UUID_LENGTH = 36;
    uint256 internal constant UUID_DASH1 = 8;
    uint256 internal constant UUID_DASH2 = 13;
    uint256 internal constant UUID_DASH3 = 18;
    uint256 internal constant UUID_DASH4 = 23;

    uint256 internal constant UUID_DASH_MASK = 0x0000000000000000ff00000000ff00000000ff00000000ff0000000000000000;
    uint256 internal constant UUID_DASHES = 0x00000000000000002d000000002d000000002d000000002d0000000000000000;

    uint256 internal constant UUID_MASK1 = 0xffffffffffffffff000000000000000000000000000000000000000000000000;
    uint256 internal constant UUID_MASK2 = 0x000000000000000000ffffffff00000000000000000000000000000000000000;
    uint256 internal constant UUID_MASK3 = 0x0000000000000000000000000000ffffffff0000000000000000000000000000;
    uint256 internal constant UUID_MASK4 = 0x00000000000000000000000000000000000000ffffffff000000000000000000;
    uint256 internal constant UUID_MASK5 = 0x0000000000000000000000000000000000000000ffffffffffffffffffffffff;

    uint256 internal constant HEX_CHAR_MAP = 0x5858585858585858583031323334353637383961626364656658414243444546;
    uint256 internal constant CHAR_LOOKUP_MOD = 39;

    bytes16 internal constant HEX_CHARS = "0123456789abcdef";

    function toCompact(bytes memory uuid) internal pure returns (bytes32 compactUUID) {
        if (uuid.length != UUID_LENGTH) revert InvalidUUIDLength();

        assembly {
            let word1 := mload(add(uuid, 0x20))

            // Check dashes.
            if iszero(eq(and(word1, UUID_DASH_MASK), UUID_DASHES)) {
                // Store selector `MissingUUIDDashes(...)`
                mstore(0x00, 0x2f80fa24)

                // Find dash that was actually incorrect
                if iszero(eq(byte(UUID_DASH1, word1), 0x2d)) {
                    mstore(0x21, 0x2d)
                    mstore(0x00, UUID_DASH1)
                }
                if iszero(eq(byte(UUID_DASH2, word1), 0x2d)) {
                    mstore(0x21, 0x2d)
                    mstore(0x00, UUID_DASH2)
                }
                if iszero(eq(byte(UUID_DASH3, word1), 0x2d)) {
                    mstore(0x21, 0x2d)
                    mstore(0x00, UUID_DASH3)
                }
                if iszero(eq(byte(UUID_DASH4, word1), 0x2d)) {
                    mstore(0x21, 0x2d)
                    mstore(0x00, UUID_DASH4)
                }

                revert(0x1c, 0x44)
            }

            let word2 := mload(add(uuid, 0x24))

            compactUUID :=
                or(
                    or(and(word1, UUID_MASK1), shl(0x08, and(word1, UUID_MASK2))),
                    or(or(shl(0x10, and(word1, UUID_MASK3)), shl(0x18, and(word1, UUID_MASK4))), and(word2, UUID_MASK5))
                )
        }

        for (uint256 i; i < 32;) {
            checkChar(compactUUID[i], i);
            // forgefmt: disable-next-item
            unchecked { ++i; }
        }
    }

    function fromCompact(bytes32 compactUUID) internal pure returns (bytes memory uuid) {
        assembly {
            uuid := mload(0x40)
            mstore(uuid, UUID_LENGTH)
            let offset := add(uuid, 0x20)

            mstore(offset, compactUUID)
            offset := add(offset, 8)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0x40, compactUUID))
            offset := add(offset, 4)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0x60, compactUUID))
            offset := add(offset, 4)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0x80, compactUUID))
            offset := add(offset, 4)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0xa0, compactUUID))

            mstore(0x40, add(uuid, 0x60))
        }
    }

    /**
     * @dev Reverts if `char` is not a lower case hexadecimal character.
     * @param char The character byte to be checked.
     * @param i The position in the string to be reverted at.
     */
    function checkChar(bytes1 char, uint256 i) internal pure {
        assembly {
            let uchar := shr(248, char)
            let lookedUpChar := byte(mod(uchar, CHAR_LOOKUP_MOD), HEX_CHAR_MAP)
            let isHex := eq(lookedUpChar, uchar)
            let isUpper := eq(and(uchar, 0x70), 0x40)
            if iszero(eq(shl(isUpper, isHex), 1)) {
                switch isHex
                case 0 { mstore(0x00, 0x9a841ebf) }
                default { mstore(0x00, 0xd3772f31) }
                mstore(0x20, i)
                mstore(0x40, char)
                revert(0x1c, 0x44)
            }
        }
    }
}
