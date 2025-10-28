// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SecureMultiChain Wallet System
 * @dev A secure wallet smart contract that supports multi-chain interoperability.
 * Users can deposit, withdraw, and register chain mappings for cross-chain asset tracking.
 */

contract SecureMultiChainWallet {
    address public owner;

    // Mapping of user => token balance (for simplicity, using native ETH)
    mapping(address => uint256) private balances;

    // Mapping of user => chainId => cross-chain wallet address
    mapping(address => mapping(uint256 => address)) public chainAddresses;

    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event ChainLinked(address indexed user, uint256 indexed chainId, address chainWallet);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Deposit ETH into the wallet.
     */
    function deposit() external payable {
        require(msg.value > 0, "Must deposit more than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw ETH from your wallet.
     * @param amount The amount to withdraw.
     */
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    /**
     * @notice Link your wallet with another chain for multi-chain operations.
     * @param chainId The ID of the other blockchain.
     * @param chainWallet The address of the wallet on that chain.
     */
    function linkChainWallet(uint256 chainId, address chainWallet) external {
        require(chainWallet != address(0), "Invalid address");
        chainAddresses[msg.sender][chainId] = chainWallet;
        emit ChainLinked(msg.sender, chainId, chainWallet);
    }

    /**
     * @notice Check your balance.
     */
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}

